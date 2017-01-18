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

      before do
        @harry_potter = create(:book, category: horror, price: 25.0)
        @ruby_way = create(:book, category: horror, price: 50.0)
        @rails_way = create(:book, category: drama, price: 100.0)
        @book = create(:book, category: horror, price: 75.0)
      end


      it 'set category' do
        get :index, params: { with_category: horror.title }
        expect(assigns(:books).count).to eq(3)
      end

      it 'set price' do
        get :index, params: { sorted_by: :hight_price }
        expect(assigns(:books)).to eq([@rails_way, @book, @ruby_way, @harry_potter])
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
