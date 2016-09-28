class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :lat
      t.float :lng
      t.float :elevation
      t.string :time
      
      t.references :track, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
