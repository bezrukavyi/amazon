describe Provider, type: :model do
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
      allow(Provider).to receive(:find_by)
        .with(name: auth.provider, uid: auth.uid).and_return(subject)
      expect(Provider.authorize(auth)).to eq(subject)
    end

    context 'when user exist and provider not exist' do
      before do
        allow(Provider).to receive(:find_by)
          .with(name: auth.provider, uid: auth.uid).and_return(nil)
        auth.info.email = user.email
      end
      it 'create provider' do
        expect { Provider.authorize(auth) }
          .to change { user.reload.providers.count }.by(1)
      end
      it 'not send email to user' do
        allow(user).to receive(:new_record?).and_return(false)
        expect { Provider.authorize(auth) }
          .not_to change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'when user and provide not exist' do
      before do
        allow(Provider).to receive(:find_by)
          .with(name: auth.provider, uid: auth.uid).and_return(nil)
        allow(HumanPasswordValidator).to receive(:generate_password)
          .and_return('OmniAuth5555')
      end
      it 'create new provider' do
        expect { Provider.authorize(auth) }.to change { Provider.count }.by(1)
      end
      it 'create new user' do
        expect { Provider.authorize(auth) }.to change { User.count }.by(1)
      end
      it 'send mail to user' do
        allow(user).to receive(:new_record?).and_return(true)
        expect { Provider.authorize(auth) }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
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
