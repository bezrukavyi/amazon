require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in subject
  end

  describe 'PUT #update' do

    context 'Valid' do
      context 'updating email' do
        it 'updated data' do
          params = { email: 'rspec555@gmail.com' }
          expect { put :update, params: { user: params } }
            .to change { subject.reload.email }
        end
        it 'redirect to the new user' do
          put :update, params: { user: attributes_for(:user) }
          expect(response).to redirect_to(edit_user_path)
        end
      end

      context 'updating address' do
        it 'updated data' do
          params = attributes_for(:address_user, :billing)
          put :update, params: { address: params }
          expect { put :update, params: { address: params } }
            .to change { subject.reload.billing }
        end
        it 'redirect to the new user' do
          put :update, params: { user: attributes_for(:user) }
          expect(response).to redirect_to(edit_user_path)
        end
      end
    end

    context 'Invalid' do
      context 'updating email' do
        it 'updated data' do
          params = { email: '' }
          expect { put :update, params: { user: params } }
            .not_to change { subject.reload.email }
        end
        it 'redirect to the new user' do
          put :update, params: { user: attributes_for(:user) }
          expect(response).to redirect_to(edit_user_path)
        end
      end

      context 'updating address' do
        it 'updated data' do
          params = attributes_for(:address_user, :invalid)
          expect { put :update, params: { address: params } }
            .not_to change { subject.reload.shipping }
        end
        it 'redirect to the new user' do
          put :update, params: { user: attributes_for(:user) }
          expect(response).to redirect_to(edit_user_path)
        end
      end
    end

  end
end
