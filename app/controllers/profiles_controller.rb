class ProfilesController < ApplicationController

  before_action :set_profile
  before_filter :must_be_current_user, except: [:show] 


  # GET /profiles/1
  def show
  end

  # GET /profiles/1/edit
  def edit
    if @profile.asset.nil?
      @profile.build_asset
    end
  end

  # PATCH/PUT /profiles/1
  def update
    if @profile.update(profile_params)
      unless profile_params[:asset_attributes].nil? 
        Cloudinary::Uploader.upload(profile_params[:asset_attributes][:asset])
      end
      flash[:notice] = 'Votre profil à été mise à jour.'
      redirect_to edit_profile_path(@user.slug)
    else
      render :edit
    end
  end

  # DELETE /profiles/1
  def destroy
    @user.destroy
    flash[:notice] = 'Votre compte et vos informations ont été supprimé'
    redirect_to root_url
  end

  private

    def set_profile
      @user = User.find_by_slug(params[:id])
      @user ||= User.find(params[:id])
      @profile = @user.profile
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, asset_attributes: [:asset])
    end
end
