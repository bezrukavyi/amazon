require 'cancan/matchers'

describe User, type: :model do
  let(:user) { create :user }
  let(:admin) { create :user, :admin }

  context 'when user as guest' do
    subject { Ability.new(nil) }

    it { should be_able_to(:read, Book) }
    it { should be_able_to(:read, Category) }
    it { should be_able_to(:read, Review) }
    it { should be_able_to(:show, build(:book)) }
  end

  context 'when user signed in' do
    subject { Ability.new(user) }

    it { should be_able_to(:manage, user) }
    it { should be_able_to(:new, Review.new) }
    it { should be_able_to(:create, Review.create(user: user)) }
  end

  context 'when user as admin' do
    subject { Ability.new(admin) }

    it { should be_able_to(:access, :rails_admin) }

    [Book, Author, Category, Review, Material, Picture,
     User].each do |class_name|
      it { should be_able_to(:manage, class_name.new) }
    end

    it { should_not be_able_to(:show_in_app, user) }
  end
end
