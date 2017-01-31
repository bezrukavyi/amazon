require 'rails_helper'

RSpec.describe MainPagesController, type: :controller do

  describe 'GET #index' do
    it 'get best_sellers' do
      expect(Book).to receive(:best_sellers)
      get :index
    end
  end

end
