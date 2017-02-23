class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, [Book, Category]
    can :show, Book.full_joins
    can :read, Review

    if user.persisted?
      can :read, Order, user_id: user.id
      can :manage, User, id: user.id
      can :new, Review
      can :update, Book
      can :create, Review, user_id: user.id

      if user.admin?
        can :access, :rails_admin
        can :dashboard
        can :read, Address
        can :all_events, Order
        can :manage, [Book, Author, Category, Review, Country, Material, Picture,
                      Delivery, Coupon, Order, User]

        cannot :show_in_app, Order
        cannot :show_in_app, User
      end
    end
  end
end
