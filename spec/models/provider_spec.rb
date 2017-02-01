require 'rails_helper'

RSpec.describe Provider, type: :model do

  subject { create :provider }
  let(:user) { subject.user }

  before do
    set_omniauth(:facebook)
  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  describe '#authorize' do
    let(:auth) { OmniAuth.config.mock_auth[:facebook] }

    it 'when provider exist' do
      allow(Provider).to receive(:find_by_omniauth).and_return([subject])
      expect(Provider.authorize(auth)).to eq(subject)
    end

    context 'when provider not exist' do

      before do
        allow(Provider).to receive(:find_by_omniauth).and_return(nil)
      end

      it 'when user exist' do
        auth.info.email = user.email
        expect { Provider.authorize(auth) }.to change { user.reload.providers.count }.by(1)
      end

      describe 'when user not exist' do
        it 'create new provider' do
          expect { Provider.authorize(auth) }.to change { Provider.count }.by(1)
        end
        it 'create new user' do
          expect { Provider.authorize(auth) }.to change { User.count }.by(1)
        end
        it 'set user attributes' do
          auth.info.name = 'Rspec Rspecovich'
          Provider.authorize(auth)
          expect(User.last.first_name).to eq('Rspec')
          expect(User.last.last_name).to eq('Rspecovich')
        end
      end

    end

  end

end
