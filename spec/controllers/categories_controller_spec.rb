include Support::CanCanStub

describe CategoriesController, type: :controller do
  subject { create :category }
  let(:book) { create :book, category: subject }
  let(:user) { create :user }

  before do
    sign_in user
  end

  it 'GET #show' do
    params = { sorted_by: 'asc_title', id: subject.id }
    allow(controller).to receive(:params).and_return(params)
    receive_cancan(:load_and_authorize, category: subject)
    expect(Books::IndexPresenter).to receive(:new).with(params, subject)
    get :show, params: { id: subject.id }
  end
end
