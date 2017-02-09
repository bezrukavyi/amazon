describe CategoryDecorator do

  subject { create(:category).decorate }

  it '#title_key' do
    allow(subject).to receive(:title).and_return('Web design')
    expect(subject.title_key).to eq('web_design')
  end

  it '#current?' do
    allow(subject).to receive(:title).and_return('Web design')
    expect(subject.current?('web design')).to be_truthy
  end


end
