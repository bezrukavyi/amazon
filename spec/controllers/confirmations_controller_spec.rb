describe ConfirmationsController, type: :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#PUT update' do
    let(:user) { create :user }
    let(:params) { { password: 'Test5555', password_confirmation: 'Test5555' } }

    before do
      allow(controller).to receive(:set_resource)
      allow(controller).to receive(:resource).and_return(user)
      allow(controller).to receive(:allowed_params).and_return(params)
    end

    it 'call update attributes' do
      allow(user).to receive(:has_password?).and_return(false)
      expect(user).to receive(:update_attributes).with(params)
      put :update, params: params
    end

    context 'success update' do
      before do
        allow(user).to receive(:has_password?).and_return(false)
        allow(user).to receive(:update_attributes).and_return(true)
      end
      it 'auth user' do
        expect(controller).to receive(:bypass_sign_in).with(user)
        put :update, params: params
      end
      it 'redirect_to checkout first step' do
        put :update, params: params
        expect(response).to redirect_to(checkout_path(:address))
      end
      it 'flash notice' do
        put :update, params: params
        expect(flash[:notice]).to eq(I18n.t('devise.confirmations.confirmed'))
      end
    end

    context 'failure update' do
      before do
        allow(user).to receive(:has_password?).and_return(true)
        allow(user).to receive(:update_attributes).and_return(false)
      end
      it 'render :show' do
        put :update
        expect(response).to render_template(:show)
      end
    end

  end

end
