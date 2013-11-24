class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    unless user.new_record?
      alias_action :new, :create, :edit, :update, :destroy, to: :crud
      
      can :crud, [Profile, Product], user_id: user.id

      can :destroy, Comment, user_id: user.id
      can :destroy, User, id: user.id

      can :create, Comment
    end

    can :show, :all
    can :index, Product
  end
end
