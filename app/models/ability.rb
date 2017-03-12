class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, [Book, Category]
    can :show, Book.full_joins
    can :read, Review

    if user.persisted?
      can :read, Corzinus::Order, user_id: user.id
      can :manage, User, id: user.id
      can :new, Review
      can :update, Book
      can :create, Review, user_id: user.id

      if user.admin?
        can :access, :rails_admin
        can :dashboard
        can :read, Corzinus::Address
        can :all_events, Corzinus::Order
        can :manage, [Book, Author, Category, Review, Corzinus::Country, Material, Picture,
                      Corzinus::Delivery, Corzinus::Coupon, Corzinus::Order, User]

        cannot :show_in_app, Corzinus::Order
        cannot :show_in_app, User
      end
    end
  end
end
