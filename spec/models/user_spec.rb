describe User, type: :model do
  subject { create :user }

  context 'associations' do
    %i(providers reviews orders).each do |model_name|
      it { should have_many(model_name) }
    end
  end

  context 'validation' do
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_most(50) }
    it { should validate_length_of(:email).is_at_most(63) }
  end

  describe '#password?' do
    it 'return false' do
      user = User.new(email: 'test@gmail.com', password: 'Test5555',
                      password_confirmation: 'Test5555')
      expect(user.password?).to be_truthy
    end
    it 'return true' do
      user = User.new(email: 'test@gmail.com')
      expect(user.password?).to be_falsey
    end
  end

  describe '#password_required?' do
    context 'return true' do
      it 'not persisted' do
        user = User.new
        expect(user.password_required?).to be_truthy
      end
      it 'exist password' do
        user = User.create(email: 'test@gmail.com', password: 'Test5555')
        expect(user.password_required?).to be_truthy
      end
      it 'exist password_confirmation' do
        user = User.create(email: 'test@gmail.com',
                           password_confirmation: 'Test5555')
        expect(user.password_required?).to be_truthy
      end
    end
    it 'return false' do
      user = User.new(email: 'test@gmail.com')
      user.skip_password_validation = true
      expect(user.password_required?).to be_falsey
    end
  end

  context 'condition for human_password validate' do
    it 'without password validation' do
      user = User.new(email: 'test@gmail.com')
      user.skip_password_validation = true
      expect(user).to be_valid
    end
    it 'with password validation' do
      user = User.new(email: 'test@gmail.com')
      expect(user).not_to be_valid
    end
  end
end
