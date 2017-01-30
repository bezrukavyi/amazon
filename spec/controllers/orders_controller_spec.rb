require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #index' do

    before do
      @in_progress_order = create :order, :with_items, user: user, state: 'in_progress'
      @delivered_order = create :order, :with_items, user: user, state: 'delivered'
      @canceled_order = create :order, :with_items, user: user, state: 'canceled'
    end

    context 'default state' do
      before do
        get :index
      end
      it 'assigns user orders' do
        expect(assigns[:orders]).to eq([@in_progress_order, @delivered_order, @canceled_order])
      end

      it 'render index template' do
        expect(response).to render_template :index
      end
    end

    context 'with filter' do
      it 'with in_progress' do
        get :index, params: { state: 'in_progress' }
        expect(assigns[:orders]).to eq([@in_progress_order])
      end
      it 'with delivered' do
        get :index, params: { state: 'delivered' }
        expect(assigns[:orders]).to eq([@delivered_order])
      end
      it 'with canceled' do
        get :index, params: { state: 'canceled' }
        expect(assigns[:orders]).to eq([@canceled_order])
      end
    end


  end

end
