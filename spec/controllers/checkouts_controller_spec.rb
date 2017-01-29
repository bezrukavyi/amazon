require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do

  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #show' do

    context 'accessed' do
      let(:order) { create :order, :checkout_package, user: user }

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
      let(:order) { create :order, :with_items, user: user }

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

      context 'delivery step' do
        let(:delivery) { create :delivery }
        it 'updated data' do
          expect { put :update, params: { id: :delivery, delivery_id: delivery.id } }
            .to change(order, :delivery)
        end
        it 'redirect to payment' do
          put :update, params: { id: :delivery, delivery_id: delivery.id }
          expect(response).to redirect_to checkout_path(:payment)
        end
      end

      context 'payment step' do
        before do
          order.credit_card = nil
          @params = { credit_card_attributes: attributes_for(:credit_card) }
        end
        it 'updated data' do
          expect { put :update, params: { id: :payment, order: @params } }
            .to change { order.credit_card }
        end
        it 'redirect to payment' do
          put :update, params: { id: :payment, order: @params }
          expect(response).to redirect_to checkout_path(:confirm)
        end
      end

      context 'confirm step' do
        it 'updated data' do
          expect { put :update, params: { id: :confirm, confirm: true } }
            .to change { order.state }
        end
        it 'redirect to payment' do
          put :update, params: { id: :confirm, confirm: true }
          expect(response).to redirect_to checkout_path(:complete)
        end
      end

    end

  end

end
