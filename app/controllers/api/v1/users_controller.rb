class Api::V1::UsersController < ApplicationController
  require 'jwt'
  require 'net/ldap'

  HOST = ENV["LDAP_HOST"]
  PORT = ENV["LDAP_PORT"]
  HOST = "ec2-18-210-24-118.compute-1.amazonaws.com"
  PORT = "389"
  BASE = "ou=sa,dc=froid,dc=unal,dc=edu,dc=co"
  # before_action :set_user, only: [:show, :update, :destroy]

  def ldap_login( email, password )
    ldap = Net::LDAP.new(:host => HOST, :port => PORT)
    ldap.bind(:method => :simple, :username => "cn="+email+","+BASE,
                 :password => password)
  end

  def ldap_register( email, password )
    Net::LDAP.open(:host => HOST, :port => PORT) do |ldap|
      if ldap.bind(:method => :simple, :username => "cn=admin,dc=froid,dc=unal,dc=edu,dc=co",
                   :password => "admin")
        # authentication succeeded
        dn = "cn="+email+","+BASE
        attr = {
            :cn => email,
            :objectclass => ["top", "inetorgperson"],
            :sn => email,
            :mail => email,
            :userPassword => Net::LDAP::Password.generate(:md5, password)
        }
        ldap.add(:dn => dn, :attributes => attr)
      end
    end
  end

  # GET /users
  def index
    @users = User.all

    render json: @users.to_json(only: [:id, :name, :email,:encrypted_password])
  end

  # GET /users/{id}
  def show
    if ldap_login((params[:email]),(params[:password]))
      # JWT CLAIMS
      #Issuer
      iss= "Froid.com"
      #expiration date
      exp = Time.now.to_i + 4 * 3600
      #issued at
      iat = Time.now.to_i


      find_user_by_email
      if @user != nil
        if a = @user.valid_password?(params[:password])
          data ={
              iss: iss,
              exp: exp,
              iat: iat,
          }

          token = JWT.encode data,Rails.application.secrets.secret_key_base, 'HS256'
          login ={
              "id": @user.id,
              name: @user.name,
              lastname: @user.lastname,
              email: @user.email,
              phone_number: @user.phone_number,
              "token":token,
              carrer: @user.carrer,
          }
          render json:login, status: :ok
        else
          render json: a, status: :not_acceptable
        end
      end
    else
      render json: false, status: :not_acceptable
    end
  end


  # POST /users
  def create
    if ldap_register((params[:email]),(params[:password]))
      @user = User.new(user_params)
      if @user.save
        #render json: "created user:"+ @user.name.to_s, status: :created
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: false, status: :not_acceptable
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




  def find_user_by_email
    email=(params[:email])
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
