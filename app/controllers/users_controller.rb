class UsersController < ApplicationController
  require 'bcrypt'
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, only: [:edit, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.getAll
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user=User.getUser(params[:id])
    @ratings = @user.getRatings
    @user_friends=@user.get_friends
    if current_user==@user
      @requests=Friendship.get_pending_requests(current_user)
    end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if(current_user==User.getUser(params[:id]))
      @user=User.getUser(params[:id])

    else
      redirect_to user_url(current_user), notice: "You can not edit other users!"
    end

  end

  # POST /users
  # POST /users.json
  def create
    byebug
    respond_to do |format|
      if User.validate?(user_params)
        password_salt = BCrypt::Engine.generate_salt
        password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
        User.createNew(user_params, password_encrypted,password_salt)
        @user= User.getUserByUsername(user_params["username"])
        #@user.save
        session[:user_id]=@user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user=current_user
    respond_to do |format|
      if User.validate_edit?(user_params)
        password_salt = BCrypt::Engine.generate_salt
        password_encrypted = BCrypt::Engine.hash_secret(user_params["password"], password_salt)
        @user.updateUser(password_encrypted, password_salt)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        if user_params["password"]!= user_params["password_confirmation"]
          format.html { redirect_to edit_user_path(@user), notice: "Password mistmatch!"}
        end
        if user_params["password_confirmation"].nil? or user_params["password"].nil? or user_params["old_password"].nil?
          format.html { redirect_to edit_user_path(@user), notice: "Fields cannot be empty!"}
        else
          format.html { redirect_to edit_user_path(@user), notice: "Old password not correct!"}
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroyUser
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :old_password, :password, :password_confirmation)
  end
end
