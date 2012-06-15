class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table(:people) do |t|
      t.string :title
      t.string :name
      t.string :email
      t.boolean :employee
      t.string :password
      t.text :bio
    end
  end

  def self.down
    drop_table :people
  end
end

