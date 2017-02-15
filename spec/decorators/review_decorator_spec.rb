describe ReviewDecorator do
  subject { create(:review).decorate }

  it '#user_name' do
    expect(subject.user_name).to eq(subject.user.decorate.full_name)
  end

  it '#created_strf' do
    expect(subject.created_strf).to match(%r{\d{2}\/\d{2}\/\d{2}})
  end
end
