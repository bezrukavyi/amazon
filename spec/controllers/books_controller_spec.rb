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

    it 'assigns book' do
      expect(Book).to receive_message_chain(:full_includes, :find_by)
      get :show, params: { id: subject.id }
    end

    context 'when book found' do
      before do
        get :show, params: { id: subject.id }
        allow(Book).to receive_message_chain(:full_includes, :find_by)
          .and_return(subject)
      end

      it 'assigns book' do
        expect(assigns(:book)).to eq(subject)
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

    it 'redirect to the book' do
      put :update, params: { id: subject.id, review: attributes_for(:review) }
      expect(response).to redirect_to(book_path(subject))
    end

    it 'redirect to the new user' do
      put :update, params: { id: subject.id, review: attributes_for(:review, :invalid) }
      expect(response).to render_template(:show)
    end

  end

end
