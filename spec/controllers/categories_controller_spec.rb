describe CategoriesController, type: :controller do

  subject { create :category }
  let(:book) { create :book, category: subject }
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #show' do
    it 'when category exist' do
      params = { sorted_by: 'asc_title', id: subject.id }
      allow(controller).to receive(:params).and_return(params)
      expect(Books::IndexPresenter).to receive(:new).with(params: params, category: subject)
      get :show, params: { id: subject.id }
    end
    it 'when category isnt exist' do
      expect(Books::IndexPresenter).not_to receive(:new)
      get :show, params: { id: 10001 }
      expect(response).to redirect_to(books_path)
      expect(flash[:alert]).to eq(I18n.t('flash.failure.category_found'))
    end
  end

end
