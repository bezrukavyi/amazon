class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    return unless @user
    can :new, Review
    can :create, Review, user_id: user.id

    return unless @user.admin?
    can :access, :rails_admin
    can :dashboard
    can :manage, [Book, Author, Category, Review, Country, Material, Picture,
                  Delivery, Coupon, Order, User]
    can :all_events, Order
    can :read, Address
  end
end
