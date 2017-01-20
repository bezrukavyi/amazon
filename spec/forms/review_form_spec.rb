require 'rails_helper'

RSpec.describe ReviewForm, :review_form do

  subject { ReviewForm.from_params attributes_for(:review) }

  it 'valid object' do
    is_expected.to be_valid
  end

  [:grade, :book_id, :user_id, :title].each do |name|
    it { is_expected.to validate_presence_of(name) }
  end


end