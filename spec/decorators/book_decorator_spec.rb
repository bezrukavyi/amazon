require 'rails_helper'

describe BookDecorator do

  subject { create(:book).decorate }

  it '#publicate_at' do
    expect(subject.publicate_at).to match(/\w{1}$/)
  end

  context 'Pictures' do
    let(:first_picture) { create :picture }
    let(:second_picture) { create :picture }
    let(:third_picture) { create :picture }

    describe '#main_picture' do
      it 'pictures exist' do
        subject.pictures = [first_picture, second_picture]
        expect(subject.main_picture).to eq(first_picture)
      end

      it 'pictures not exist' do
        subject.pictures = []
        expect(subject.main_picture).to eq(subject.avatar_url.to_s)
      end
    end

    describe '#other_picutres' do
      it 'pictures exist' do
        subject.pictures = [first_picture, second_picture, third_picture]
        expect(subject.other_picutres).to eq([second_picture, third_picture])
      end

      it 'pictures not exist' do
        subject.pictures = []
        expect(subject.other_picutres).to be_blank
      end
    end

  end

end
