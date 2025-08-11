class Ability
  include CanCan::Ability

  def initialize(user)
    if user&.admin?
      can :manage, :all
      cannot :edit, Review
    else
      can :read, :all
      can :email_preview, Order
      cannot :index, User
      can :destroy, Order
    end
  end
end
