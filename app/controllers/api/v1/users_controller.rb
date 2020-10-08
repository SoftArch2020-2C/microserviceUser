class Api::V1::UsersController < ApplicationController
  # before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users.to_json(only: [:id, :name, :email])
  end

  # GET /users/{id}
  def show
    find_user
    if @user != nil
      render json: @user, status: :ok
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

  # PATCH/PUT /users/{id}
  def update
    find_user
    unless @user.update(user_params)
      render json: {errors: @user.errors.full_messages}, status: :not_acceptable
      else
      render json: "user named: "+ @user.name + " updated succesfully", status: :accepted
    end

  end

  # DELETE /users/1
  def destroy
    find_user

    if @user != nil
      #render  json: "user deleted succesfully", status: :no_content
      render text:"user deleted succesfully", status: :no_content
      @user.destroy
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.

  def find_user
    @user = User.find_by_id!(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'user not found' }, status: :not_found
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:name, :lastname,:phone_number, :carrer, :is_professor, :email,:user,:password, :id )
  end
end
