require 'rails_helper'

describe CreateReview do
  let(:user) { create :user }
  let(:review_form) { ReviewForm.from_params attributes_for(:review) }

  context '#call' do
    subject { CreateReview.new(user, review_form) }

    context 'valid' do
      before do
        allow(subject.review_form).to receive(:valid?).and_return(true)
      end
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'set processing state' do
        expect { subject.call }.to change{ Review.count }.by(1)
      end
      describe 'verifiding' do
        it 'when verified' do
          allow(user).to receive(:buy_book?).with(review_form[:book_id]).and_return(true)
          subject.call
          expect(Review.last.verified).to be_truthy
        end
        it 'when not verified' do
          allow(user).to receive(:buy_book?).with(review_form[:book_id]).and_return(false)
          subject.call
          expect(Review.last.verified).to be_falsey
        end
      end

    end

    it 'invalid' do
      allow(subject.review_form).to receive(:valid?).and_return(false)
      expect { subject.call }.to broadcast(:invalid)
    end

  end
end
