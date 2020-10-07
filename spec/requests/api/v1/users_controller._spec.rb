require 'swagger_helper'

RSpec.describe 'api/v1/users_controller.', type: :request do
  path "/api/v1/users/" do
    get "Retrieves all users" do
      tags "Users"
      consumes "application/json"

      response "200", "Users found" do
        schema type: :object,
               properties:{
                   id: {type: Integer,},
                   name: { type: :string },
                   email: { type: :string },
               },
               required:["id","name","email"]
        let(:user) { { name:"juanito",lastname:"alimaña",email:"juanito@gmail.com","phonenumber":"1548632157",carrer:"diseño",password:"9876543" } }
        run_test!
      end
      response "404", "users not found" do
        let(:user) {{name:"juanito"}}
        run_test!
      end
    end
    post "Create an User" do
      tags "Users"
      consumes "application/json"
      parameter name: :user, in: :body, schema:{
          type: :object,
          properties:{
              name: { type: :string },
              lastname: { type: :string },
              email: { type: :string },
              phone_number: { type: :string },
              carrer: { type: :string },
              password: { type: :string },
              is_professor: {type: :boolean}
          },
          required: ["name","lastname","email","phone_number","carrer","password"]
      }
      response "201", "user created" do
        let(:user) { { name:"juanito",lastname:"alimaña",email:"juanito@gmail.com","phonenumber":"1548632157",carrer:"diseño",password:"9876543" } }
        run_test!
      end
      response "422", "invalid requuest" do
        let(:user) {{name:"juanito"}}
        run_test!
      end
    end
  end
  path "/api/v1/users/{id}" do
    get "Retrieves an User" do
      tags "Users"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer

      response "200", "User found" do
        schema type: :object,
               properties:{
                   id: {type: Integer,},
                   name: { type: :string },
                   lastname: { type: :string },
                   email: { type: :string },
                   phone_number: { type: :string },
                   carrer: { type: :string },
                   is_professor: {type: :boolean}
               },
               required:["id","name","email"]
        let(:id){User.create(name:"cesar",email:"cesar@gmail.com",password:"456789",lastname:"velasco",carrer:"ing",phone_number:"3212382302")}
        run_test!
      end
      response "404", "user not found" do
        let(:id) {invalid}
        run_test!
      end
    end
    put "Updates an User" do
      tags "Users"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :user, in: :body, schema:{
          type: :object,
          properties:{
              name: { type: :string },
              lastname: { type: :string },
              email: { type: :string },
              phone_number: { type: :string },
              carrer: { type: :string },
              is_professor: {type: :boolean}
          },
          required:["id"]
      }
      response "202", "User update accepted" do
        let(:id){User.create(name:"cesar",email:"cesar@gmail.com",password:"456789",lastname:"velasco",carrer:"ing",phone_number:"3212382302")}
        run_test!
      end

      response "404","User not found" do
      let(:id){"invalid"}
      run_test!
      end
    end

    delete "Delete an User" do
      tags "Users"
      parameter name: :id, in: :path, type: :integer

      response "204", "User deleted succesfully" do
        let(:id){User.create(name:"cesar",email:"cesar@gmail.com",password:"456789",lastname:"velasco",carrer:"ing",phone_number:"3212382302")}
        run_test!
      end

      response "404", "User not found" do
        let(:id){"invalid"}
        run_test!
      end
    end
  end
end
