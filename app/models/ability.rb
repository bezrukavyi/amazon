class Ability
  include CanCan::Ability

  def initialize(user)

    if user
      can :new, Review
      can :create, Review, user_id: user.id
    end

    if user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, [Book, Author, Category, Review, Country, Material, Picture]
      can :read, User
    else


    end
  end
end
