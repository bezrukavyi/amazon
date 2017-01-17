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
