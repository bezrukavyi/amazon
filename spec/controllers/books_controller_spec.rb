require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  subject { create :book }
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #index' do

    it 'get book_count' do
      expect(Book).to receive(:count)
      get :index
    end

    it 'get sort_types' do
      get :index
      expect(assigns(:sort_types)).not_to be_nil
    end

    it 'get filter book' do
      params = { with_category: 'test', sorted_by: 'low_price' }
      expect(Book).to receive(:filter_with).with(params).and_return(Book.none)
      get :index, params: params
    end

  end

  describe 'GET #show' do

    context 'when book found' do
      before { get :show, params: { id: subject.id } }

      it 'review form' do
        expect(assigns(:review_form)).to be_kind_of(ReviewForm)
      end

      it 'assigns the requested book' do
        expect(assigns(:book)).to eq(subject)
      end
      it 'renders the :show template' do
        expect(response).to render_template(:show)
      end
    end

    it 'when book not found' do
      get :show, params: { id: 1001 }
      expect(response).to redirect_to(books_path)
    end
  end

  describe 'PUT #update' do
    context 'Valid' do
      let(:params) { attributes_for(:review) }

      it 'updated book reviews' do
        expect { put :update, params: { id: subject.id, review: params } }
          .to change { Review.count }.by(1)
      end

      it 'redirect to the book' do
        put :update, params: { id: subject.id, review: params }
        expect(response).to redirect_to(book_path(subject))
      end
    end

    context 'Invalid' do
      let(:params) { attributes_for :review, :invalid }

      it 'updated book reviews' do
        expect { put :update, params: { id: subject.id, review: params } }
          .not_to change { subject.reviews.count }
      end

      it 'redirect to the new user' do
        put :update, params: { id: subject.id, review: params }
        expect(response).to render_template(:show)
      end
    end
  end

end
