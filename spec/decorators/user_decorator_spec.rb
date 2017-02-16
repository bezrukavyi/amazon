describe UserDecorator do
  subject { create(:user).decorate }

  describe '#full_name' do
    it 'full_name exist' do
      expect(subject.full_name)
        .to eq("#{subject.first_name} #{subject.last_name}")
    end

    it 'full_name not exist' do
      subject.first_name = ''
      subject.last_name = ''
      expect(subject.full_name).to eq(subject.email)
    end
  end
end
