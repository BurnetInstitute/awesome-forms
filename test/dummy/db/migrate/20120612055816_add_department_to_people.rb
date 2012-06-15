class AddDepartmentToPeople < ActiveRecord::Migration
  change_table :people do |t|
    t.references :department
  end
end
