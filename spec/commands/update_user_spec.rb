describe UpdateUser do
  let(:user) { create :user }

  context 'update without password' do
    let(:params) do
      { user: { email: 'new_email@gmail.com' }, with_password: nil }
    end
    subject { UpdateUser.new(user, params) }
    before do
      allow(subject).to receive(:allowed_params).and_return(params[:user])
    end

    it 'update user' do
      expect(user).to receive(:update_without_password).with(params[:user])
      subject.call
    end

    it 'success update' do
      allow(user).to receive(:update_without_password).and_return(true)
      expect { subject.call }.to broadcast :valid
    end

    it 'failure update' do
      allow(user).to receive(:update_without_password).and_return(false)
      expect { subject.call }.to broadcast :invalid
    end

    context 'update with password' do
      let(:params) do
        { user: { password: 'Newpassword555',
                  password_confirmation: 'Newpassword555' },
          with_password: true }
      end
      subject { UpdateUser.new(user, params) }
      before do
        allow(subject).to receive(:allowed_params).and_return(params[:user])
      end

      it 'update user' do
        expect(user).to receive(:update_with_password).with(params[:user])
        subject.call
      end
    end
  end
end
