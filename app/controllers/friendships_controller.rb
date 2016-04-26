class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, only: [:show, :edit, :update, :destroy]

  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
  end

  def accept_request
    request=Friendship.get_pending_requests(current_user)
                .select{|req| req.friend_a_id==friendship_params[:friend_a_id].to_i and req.friend_b_id == friendship_params[:friend_b_id].to_i}.first
    request.accept_request
    redirect_to :back, notice: "Friend accepted!"
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
  end

  # GET /friendships/new
  def new
    @friendship = Friendship.new
  end

  # GET /friendships/1/edit
  def edit
  end

  def delete_friendship
    Friendship.delete(current_user.id, params["friend_a_id"])
    redirect_to :back
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new(friendship_params)

    respond_to do |format|
      if Friendship.validate?(friendship_params)
        Friendship.send_invitation(friendship_params)
        format.html { redirect_to @friendship, notice: 'Friendship was successfully created.' }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { redirect_to :back, notice: 'Ystäväpyyntö odottaa/lähetetty' }
      end
    end
  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
    respond_to do |format|
      if @friendship.update(friendship_params)
        format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
        format.json { render :show, status: :ok, location: @friendship }
      else
        format.html { render :edit }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    Friendship.delete(current_user, params["delete_friend_id"])
    respond_to do |format|
      format.html { redirect_to friendships_url, notice: 'Friendship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def friendship_params
    params.require(:friendship).permit(:friend_a_id, :friend_b_id, :status)
  end
end
