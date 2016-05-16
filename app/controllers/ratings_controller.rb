class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, only:[:edit, :update, :destroy]


  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.getAll
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show

  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  def redirect_from_ratings
  redirect_to places_path, notice:"Search for the desired place and rate that!"
  end

#   GET /ratings/1/edit
#  def edit
#  end

  # POST /ratings
  # POST /ratings.json
  def create

    @rating = Rating.new(rating_params)
    respond_to do |format|
      if Rating.validate?(rating_params)
        if current_user
        Rating.createNew(rating_params, current_user.id)
        else
        Rating.createNew(rating_params,nil)
        end
        format.html { redirect_to @rating, notice: 'Rating was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      else
      format.html { redirect_to :back, notice: 'Valitsit väärät parametrit' }
      end
    session[:place_id]=nil
    end

  end

  def update

      @rating=Rating.get_rating(params[:id])
    if current_user and current_user==User.getUser(@rating.user_id)
      respond_to do |format|
        if Rating.validate_edit?(rating_params)
            @rating.update_rating(rating_params, @rating.id)
            format.html { redirect_to ratings_path, notice: "Rating was succesfully updated!"}
        else
            format.html { redirect_to edit_rating_path(@rating), notice: "Score cannot be null and must be between 0 and 10!"}
        end


        end
      else
          redirect_to ratings_path, notice:"You cannot edit other users ratings!"
      end
  end



  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    if current_user==@rating.get_user
    @rating.destroyRating
    respond_to do |format|
      format.html { redirect_to ratings_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }



    end
    else
        redirect_to :back, notice: "Cannot destroy other user's ratings"
        end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.require(:rating).permit(:score, :user_id, :place_id, :comment)
    end


end
