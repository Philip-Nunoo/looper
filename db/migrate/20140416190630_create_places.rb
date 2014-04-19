class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.text :location
      t.text :place
      t.string :description
      t.text :date
      t.text :time

      t.timestamps
    end
  end
end
