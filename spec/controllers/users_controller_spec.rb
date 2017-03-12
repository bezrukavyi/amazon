include Support::CanCanStub

describe UsersController, type: :controller do
  subject { create :user }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
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
    before(:each) do
      sign_in subject
      receive_cancan(:load_and_authorize)
    end

    context 'UpdateUser' do
      let(:params) { { email: subject.email } }
      before { allow(controller).to receive(:params).and_return(params) }

      it 'UpdateUser call' do
        expect(UpdateUser).to receive(:call).with(subject, params)
        put :update
      end

      context 'success update' do
        before do
          stub_const('UpdateUser', Support::Command::Valid)
          put :update
        end
        it 'flash notice' do
          expect(flash[:notice]).to eq(I18n.t('flash.success.privacy_update'))
        end
        it 'redirect to edit user' do
          expect(response).to redirect_to(edit_user_path)
        end
      end

      context 'failure update' do
        before do
          stub_const('UpdateUser', Support::Command::Invalid)
          put :update
        end
        it 'flash notice' do
          expect(flash[:alert]).to eq(I18n.t('flash.failure.privacy_update'))
        end
        it 'redirect to edit user' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) { sign_in subject }

    context 'without agree' do
      before do
        allow(controller).to receive(:params).and_return(agree_cancel: false)
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
