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
      expect(Order).to receive_message_chain(:order, :where, :not_empty)
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

  describe 'GET #show' do
    let(:order) { create :order }

    it 'find order' do
      allow(Order).to receive(:find_by).with(id: order.id.to_s, user: user)
        .and_return(order)
      get :show, params: { id: order.id }
      expect(response).to render_template(:show)
    end

    it 'not find order' do
      allow(Order).to receive(:find_by).and_return(nil)
      get :show, params: { id: order.id }
      expect(flash[:alert]).to eq I18n.t('flash.failure.order_found')
      expect(response).to redirect_to(orders_path)
    end
  end
end
