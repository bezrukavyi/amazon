describe CreateReview do
  let(:user) { create :user }
  let(:book) { create :book }
  let(:params) { { review: attributes_for(:review) } }

  context '#call' do
    subject { CreateReview.new(user: user, book: book, params: params) }

    context 'valid' do
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'set processing state' do
        expect { subject.call }.to change { Review.count }.by(1)
      end
      describe 'verifiding' do
        it 'when verified' do
          allow(user).to receive(:bought_book?).with(book.id)
            .and_return(true)
          subject.call
          expect(Review.last.verified).to be_truthy
        end
        it 'when not verified' do
          allow(user).to receive(:bought_book?).with(book.id)
            .and_return(false)
          subject.call
          expect(Review.last.verified).to be_falsey
        end
      end
    end

    it 'invalid' do
      invalid_params = { review: attributes_for(:review, :invalid) }
      allow(subject).to receive(:params).and_return(invalid_params)
      expect { subject.call }.to broadcast(:invalid)
    end
  end
end
