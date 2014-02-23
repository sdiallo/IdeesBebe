class Ability
  include CanCan::Ability

  def initialize(user)

    unless user.nil?
          
      can :manage, [Profile, Product], user_id: user.id

      can [:destroy, :update], ProductAsset do |asset|
        user.is_owner_of? asset.product
      end
      can :destroy, Comment, user_id: user.id
      can :destroy, User, id: user.id

      can :create, Comment
      can :create, Message
      can :index, Status, product: { owner_id: user.id }
      can :show, Status do |status|
        user.is_owner_of?(status.product) or status.user.id == user.id
      end
      can :update, Status do |status|
        user.is_owner_of?(status.product)
      end
    end

    can :show, :all
    can :show_subcategory, Category
    can :index, Product
  end
end
