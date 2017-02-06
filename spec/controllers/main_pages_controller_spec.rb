require 'rails_helper'

RSpec.describe MainPagesController, type: :controller do

  describe 'GET #index' do
    before do
      create :book
    end

    it 'with category web design' do
      expect(Book).to receive_message_chain(:with_category).with('Web design').and_return(Book.all)
      get :home, params: { category: 'web_design' }
    end
    it 'without category' do
      stub_const("Category::HOME", 'web_dev')
      expect(Book).to receive(:with_category).with('Web dev').and_return(Book.all)
      get :home
    end
    it 'get newest' do
      expect(Book).to receive_message_chain(:newest, :limit)
      get :home
    end
    it 'get best_sellers' do
      expect(Book).to receive(:best_sellers)
      get :home
    end
  end

end
