describe OrdersController, type: :controller do
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns states' do
      get :index
      expect(assigns[:states]).not_to be_nil
    end

    it 'assigns orders' do
      expect(Order).to receive_message_chain(:not_empty, :order)
      get :index
    end

    it 'assigns orders with sort' do
      expect(Order).to receive(:in_progress)
      get :index, params: { state: 'in_progress' }
    end

    it 'render index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end
