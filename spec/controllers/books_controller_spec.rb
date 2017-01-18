require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  subject { create :book }

  describe 'GET #index' do

    context 'without filter' do
      before { get :index }
      it 'populates of books' do
        expect(assigns(:books)).to eq([subject])
      end
      it 'renders the :index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'with filter' do
      let(:horror) { create :category }
      let(:drama) { create :category }
      let(:book_1) { create :book, category: horror, price: 25.0 }
      let(:book_2) { create :book, category: horror, price: 50.0 }
      let(:book_3) { create :book, category: drama, price: 100.0 }
      let(:book_4) { create :book, category: horror, price: 75.0 }

      it 'set category' do
        books = [book_1, book_2, book_3, book_4]
        get :index, params: { with_category: horror.title }
        expect(assigns(:books).count).to eq(3)
      end

      it 'set price' do
        books = [book_1, book_2, book_3, book_4]
        get :index, params: { sorted_by: :hight_price }
        expect(assigns(:books)).to eq([book_3, book_4, book_2, book_1])
      end

    end

  end

  describe 'GET #show' do
    before { get :show, params: { id: subject.id } }
    it 'assigns the requested book' do
      expect(assigns(:book)).to eq(subject)
    end
    it 'renders the :show template' do
      expect(response).to render_template(:show)
    end
  end

end
