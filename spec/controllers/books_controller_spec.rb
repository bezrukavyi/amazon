require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  subject { create :book }
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #index' do

    it 'get categories' do
      create_list :category, 2
      get :index
      expect(assigns(:categories).size).to eq(2)
    end

    it 'get book_count' do
      create_list :book, 2
      get :index
      expect(assigns(:book_count)).to eq(2)
    end

    context 'without filter' do
      before do
        @first_book = create :book, title: 'A'
        subject.title = 'B'
        subject.save
        get :index
      end
      it 'populates of books' do
        expect(assigns(:books)).to eq([@first_book, subject])
      end
      it 'renders the :index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'with filter' do
      before do
        @horror = create :category
        @drama = create :category
        @harry_potter = create(:book, category: @horror, price: 25.0)
        @ruby_way = create(:book, category: @horror, price: 50.0)
        @rails_way = create(:book, category: @drama, price: 100.0)
        @book = create(:book, category: @horror, price: 75.0)
      end

      it 'set category' do
        get :index, params: { with_category: @horror.title }
        expect(assigns(:books).count).to eq(3)
      end

      it 'set price' do
        get :index, params: { sorted_by: :hight_price }
        expect(assigns(:books)).to eq([@rails_way, @book, @ruby_way, @harry_potter])
      end

      it 'set category and price' do
        get :index, params: { sorted_by: :low_price, with_category: @horror.title }
        expect(assigns(:books)).to eq([@harry_potter, @ruby_way, @book])
      end

    end

  end

  describe 'GET #show' do
    context 'when book found' do
      before { get :show, params: { id: subject.id } }
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
