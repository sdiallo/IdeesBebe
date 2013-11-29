class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    unless user.new_record?
          
      can :manage, [Profile, Product], user_id: user.id

      can [:destroy, :become_starred], Asset do |asset|
        (user.products.map(&:id).include?(asset.referencer_id) and asset.referencer_type == 'Product') or (user.profile.id == asset.referencer_id and asset.referencer_type == 'Profile')
      end
      can :destroy, Comment, user_id: user.id
      can :destroy, User, id: user.id

      can :create, Comment
    end

    can :show, :all
    can :by_category, Product
    can :index, Product
  end
end
