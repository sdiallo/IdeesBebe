class ProfilesController < ApplicationController

  load_resource :user, find_by: :slug, id_param: :id
  load_and_authorize_resource :profile, through: :user, singleton: true

  # GET /profiles/1
  def show
  end

  # GET /profiles/1/edit
  def edit
  end

  # TODO : improve method
  # PATCH/PUT /profiles/1
  def update
    # Avatar is store on Asset
    if @profile.update(profile_params.except(:avatar)) and not params[:profile][:avatar].nil?
      if @user.avatar.nil?
        Cloudinary::Uploader.upload(params[:profile][:avatar])
        @user.assets.create(asset: params[:profile][:avatar])
      else
        flash[:notice] = 'Vous avez déjà un avatar.'
      end
    else
      flash[:notice] = 'Votre profil à été mise à jour.'
    end
    render :edit
  end

  # DELETE /profiles/1
  def destroy
    @user.destroy
    flash[:notice] = 'Votre compte et vos informations ont été supprimé'
    redirect_to root_url
  end

  private

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar)
    end
end
