class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :lastname
      t.string :phone_number
      t.string :carrer
      t.boolean :is_professor, default: false

      t.timestamps
    end
  end
end
