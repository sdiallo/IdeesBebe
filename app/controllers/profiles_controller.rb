class ProfilesController < ApplicationController
 #before_filter :authenticate_user!, :except => :show
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_filter :must_be_current_user, except: [:show] 


  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/1/edit
  def edit
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    if @user.profile.update(profile_params)
      redirect_to profile_path(@user.slug), notice: 'Votre profil à été mise à jour.'
    else
      render action: 'edit', notice: "Une erreur s'est produite."
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @user.destroy
    redirect_to root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @user = User.find_by_slug(params[:id])
      @user ||= User.find(params[:id])
      # if @user == current_user
      #   authorize! params[:action].to_s, Profile
      # end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name)
    end
end
