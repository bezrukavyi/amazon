require 'rails_helper'

describe CreateReview do
  let(:review_form) { ReviewForm.from_params attributes_for(:review) }

  context '#call' do
    subject { CreateReview.new(review_form) }

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
    end

    it 'invalid' do
      allow(subject.review_form).to receive(:valid?).and_return(false)
      expect { subject.call }.to broadcast(:invalid)
    end
  end
end
