class Api::V1::UsersController < ApplicationController
  # before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users.to_json(only: [:id, :name, :email,:encrypted_password])
  end

  # GET /users/{email}
  def show
    find_user_by_email
    if @user != nil
      if a = @user.valid_password?(params[:password])
        render json: @user, status: :ok
      else
        render json: a, status: :not_acceptable
      end
    end
  end


  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      #render json: "created user:"+ @user.name.to_s, status: :created
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/{email}
  def update
    find_user_by_email
    if @user!=nil
      @user.update(user_update_params)
      render json: @user, status: :accepted
    end

  end

  # DELETE /users/1
  def destroy
    find_user_by_email
    if @user != nil
      #render  json: "user deleted succesfully", status: :no_content
      render text:"user deleted succesfully", status: :no_content
      @user.destroy
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.



  def auth_user (password)
    email=(params[:email])
    email = email + ".com"
    @user = User.find_by! email: email
    User.find(1).valid_pa
  end


  def find_user_by_email
    email=(params[:email])
    email = email + ".com"
    @user = User.find_by! email: email
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'user not found' }, status: :not_found
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:name, :lastname,:phone_number, :carrer, :is_professor, :email,:user,:password, :id )
  end

  def user_update_params
    params.permit(:name, :lastname,:phone_number, :carrer, :is_professor )
  end
end
