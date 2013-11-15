class ProfilesController < ApplicationController
 #before_filter :authenticate_user!, :except => :show
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_filter :must_be_current_user, except: [:show] 


  # GET /profiles/1
  def show
  end

  # GET /profiles/1/edit
  def edit
  end

  # PATCH/PUT /profiles/1
  def update
    if @user.profile.update(profile_params)
      redirect_to profile_path(@user.slug), notice: 'Votre profil à été mise à jour.'
    else
      render action: 'edit', notice: "Une erreur s'est produite."
    end
  end

  # DELETE /profiles/1
  def destroy
    @user.destroy
    redirect_to root_url
  end

  private

    def set_profile
      @user = User.find_by_slug(params[:id])
      @user ||= User.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name)
    end
end
