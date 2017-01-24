require 'rails_helper'

RSpec.describe Country, type: :model do

  context 'validation' do
    it { should validate_presence_of(:name) }
  end
end
