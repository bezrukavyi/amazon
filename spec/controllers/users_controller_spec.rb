require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context 'Concern Addressable' do
    it_behaves_like 'addressable_attrubutes'
  end

  describe '#GET new' do
    it 'render fast_auth template' do
      get :new, params: { type: 'fast' }
      expect(response).to render_template('fast_auth')
    end
  end

  describe '#PUT create' do
    context 'when fast_auth' do
      it 'call skip_password_validation' do
        allow(controller).to receive(:resource).and_return(subject)
        expect(subject).to receive(:skip_password_validation=).with(true)
        put :create, params: { type: 'fast' }
      end
    end
  end

  describe 'PUT #update' do
    before(:each) { sign_in subject }

    context 'update user data' do
      let(:user_params) { { email: subject.email } }
      before do
        allow(controller).to receive(:current_user).and_return(subject)
        allow(controller).to receive(:allowed_params).and_return(user_params)
      end

      context 'Flash messages' do
        before do
          allow(controller).to receive(:params).and_return({ address: false, with_password: true })
        end
        it 'flash notice' do
          expect(subject).to receive(:update_with_password).and_return(true)
          put :update, params: user_params
          expect(flash[:notice]).to eq I18n.t('flash.success.user_update')
        end

        it 'flash alert' do
          expect(subject).to receive(:update_with_password).and_return(false)
          put :update, params: user_params
          expect(flash[:alert]).to eq I18n.t('flash.failure.user_update')
        end
      end

      context 'success update with password' do
        before do
          allow(controller).to receive(:params).and_return({ address: false, with_password: true })
        end
        it '#update_with_password' do
          expect(subject).to receive(:update_with_password).with(user_params)
          put :update, params: user_params
        end
        it '.bypass_sign_in' do
          allow(subject).to receive(:update_with_password).and_return(true)
          expect(controller).to receive(:bypass_sign_in).with(subject).and_return(true)
          put :update, params: user_params
        end
      end

      it 'update without password' do
        allow(controller).to receive(:params).and_return({ address: false, with_password: false })
        expect(subject).to receive(:update_without_password).with(user_params).and_return(true)
        put :update, params: user_params
      end

    end


    context 'address user data' do
      let(:address_params) { { address: attributes_for(:address_user, :billing) } }
      before do
        allow(controller).to receive(:params).and_return(address_params)
      end

      it '.set_address_by_params' do
        allow(UpdateAddress).to receive(:call)
        expect(controller).to receive(:set_address_by_params).with(address_params[:address])
        put :update, params: address_params
      end

      it 'UpdateAddress call' do
        address = double('address')
        allow(controller).to receive(:set_address_by_params).and_return(address)
        expect(UpdateAddress).to receive(:call).with({ addressable: subject, addresses: [address] })
        put :update, params: address_params
      end

    end

  end

  describe 'DELETE #destroy' do
    before(:each) { sign_in subject }

    context 'without agree' do
      before do
        allow(controller).to receive(:params).and_return({ agree_cancel: false })
        delete :destroy, params: { id: subject.id }
      end

      it 'redirect_to settings' do
        expect(response).to redirect_to(edit_user_path)
      end
      it 'flash alert' do
        expect(flash[:alert]).to eq I18n.t('flash.failure.confirm_intentions')
      end
    end
  end

end
