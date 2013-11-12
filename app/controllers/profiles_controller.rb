class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :must_be_current_user, only: [:edit, :update, :destroy]

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
    respond_to do |format|
      if @user.profile.update(profile_params)
        format.html { redirect_to profile_path(@user.slug), notice: 'Votre profil à été mise à jour' }
        format.json { render json: true }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    def must_be_current_user
      if @user != current_user
        redirect_to profile_path(@user.slug), notice: "Vous ne pouvez pas altérer le profil d'un autre utilisateur" 
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @user = User.find_by_slug(params[:id])
      @user ||= User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name)
    end
end
