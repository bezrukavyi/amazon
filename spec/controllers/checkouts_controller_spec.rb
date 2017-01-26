require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do

  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #show' do

    context 'accessed' do
      let(:order) { create :order, :checkout_package, user: user }
      let(:order_item) { create :order_item, quantity: 1, order: order }

      before do
        allow(controller).to receive(:current_order).and_return(order)
      end

      it 'address step' do
        get :show, params: { id: :address }
        expect(response).to render_template :address
      end

      it 'delivery step' do
        get :show, params: { id: :delivery }
        expect(response).to render_template :delivery
      end

      it 'payment step' do
        get :show, params: { id: :payment }
        expect(response).to render_template :payment
      end

      it 'confirm step' do
        get :show, params: { id: :confirm }
        expect(response).to render_template :confirm
      end

      it 'complete step' do
        order.confirm
        get :show, params: { id: :complete }
        expect(response).to render_template :complete
      end
    end

    context 'not accessed' do
      let(:order) { create :order, user: user }
      let(:order_item) { create :order_item, quantity: 1, order: order }

      before do
        allow(controller).to receive(:current_order).and_return(order)
      end

      it 'delivery step' do
        get :show, params: { id: :delivery }
        expect(response).to redirect_to checkout_path(:address)
      end

      it 'payment step' do
        get :show, params: { id: :payment }
        expect(response).to redirect_to checkout_path(:delivery)
      end

      it 'confirm step' do
        get :show, params: { id: :confirm }
        expect(response).to redirect_to checkout_path(:payment)
      end

      it 'complete step' do
        get :show, params: { id: :complete }
        expect(response).to redirect_to checkout_path(:confirm)
      end
    end

  end

  describe 'PUT #update' do

    let(:order) { create :order, :checkout_package, user: user }
    let(:order_item) { create :order_item, quantity: 1, order: order }

    before do
      allow(controller).to receive(:current_order).and_return(order)
    end

    context 'When attributes valid' do

      context 'address step' do
        before do
          @params = { billing_attributes: attributes_for(:address_order, :billing),
           shipping_attributes: attributes_for(:address_order, :shipping) }
        end
        it 'updated shipping' do
          expect { put :update, params: { id: :address, order: @params } }
            .to change { order.reload.shipping }
        end
        it 'updated billing' do
          expect { put :update, params: { id: :address, order: @params } }
            .to change { order.reload.billing }
        end
        it 'updated with user billing' do
          @params = { billing_attributes: attributes_for(:address_order, :billing) }
          expect { put :update, params: { id: :address, use_billing: true, order: @params } }
            .to change { order.reload.shipping }
        end
        it 'redirect to the new user' do
          put :update, params: { id: :address, order: @params }
          expect(response).to redirect_to checkout_path(:delivery)
        end
      end


    end

  end

end
