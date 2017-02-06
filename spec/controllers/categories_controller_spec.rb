require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  subject { create :category }
  let(:book) { create :book, category: subject }
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #show' do
    it 'get category' do
      expect(Category).to receive(:find_by).with(id: subject.id.to_s)
      get :show, params: { id: subject.id }
    end

    it 'get book_count' do
      expect(Book).to receive(:count)
      get :show, params: { id: subject.id }
    end

    it 'get sort_types' do
      get :show, params: { id: subject.id }
      expect(assigns(:sort_types)).not_to be_nil
    end

    it 'get filter book' do
      params = { id: subject.id, sorted_by: 'low_price' }
      expect(Book).to receive(:sorted_by).with(params[:sorted_by]).and_return(Book.none)
      get :show, params: params
    end
  end

end
