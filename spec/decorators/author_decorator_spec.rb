require 'rails_helper'

describe AuthorDecorator do

  subject { create(:author).decorate }

  context 'PersonDecorator' do
    it '#full_name' do
      expect(subject.full_name).to eq("#{subject.first_name} #{subject.last_name}")
    end
  end

end
