require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { create(:category) }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
    it 'when invalid uniqueness of title' do
      title = 'test'
      category = create(:category, title: title)
      subject.title = title
      expect(subject).not_to be_valid
    end
  end

  context 'association' do
    it 'has many books' do
      expect(subject).to have_many(:books)
    end
  end
end
