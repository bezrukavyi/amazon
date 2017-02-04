require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#GET new' do
    it 'render fast_auth template' do
      get :new, params: { fast_auth: true }
      expect(response).to render_template('fast_auth')
    end
  end

end
