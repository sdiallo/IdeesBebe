class Ability
  include CanCan::Ability

  def initialize(user)

    unless user.nil?
          
      can :manage, [Profile, Product], user_id: user.id

      can [:destroy, :update], ProductAsset do |asset|
        user.products.map(&:id).include?(asset.product.id)
      end

      can :show, Conversation do |conv|
        conv.product.user == user or conv.buyer == user
      end

      can :index, Conversation do |conv|
        user.products.map(&:id).include?(conv.product.id)
      end

      can :destroy, Comment, user_id: user.id
      can :destroy, User, id: user.id

      can :create, Comment
      can :create, Message
    end

    can :show, :all
    can :by_category, Product
    can :index, Product
  end
end
