require 'rails_helper'

RSpec.describe Book, type: :model do

  subject { create(:book) }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
  end

  context 'association' do
    it 'HABM authors' do
      expect(subject).to have_and_belong_to_many(:authors)
    end
    it 'belong to category' do
      expect(subject).to belong_to(:category)
    end
  end

  context 'Scopes' do
    describe '#with_category' do
      let(:fantasy) { create :category }
      let(:drama) { create :category }
      before do
        create :book, category: fantasy
        create :book, category: fantasy
        create :book, category: fantasy
        create :book, category: drama
      end
      it '#with fantasy' do
        expect(Book.with_category(fantasy.title).count).to eq(3)
      end
    end


    describe '#sorted_by' do
      let(:harry_potter) { create :book, price: 2.0 }
      let(:ruby_way) { create :book, price: 3.0 }
      let(:rails_way) { create :book, price: 1.0 }
      let(:book) { create :book, price: 4.0 }

      it '#newest' do
        answer = [harry_potter, ruby_way, rails_way, book]
        expect(Book.sorted_by(:newest)).to eq(answer)
      end

      it '#low_price' do
        answer = [rails_way, harry_potter, ruby_way, book]
        expect(Book.sorted_by(:low_price)).to eq(answer)
      end

      it '#hight_price' do
        answer = [book, ruby_way, harry_potter, rails_way]
        expect(Book.sorted_by(:hight_price)).to eq(answer)
      end
    end
  end

end
