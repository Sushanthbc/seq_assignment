class CreateFeeSlabs < ActiveRecord::Migration[6.0]
  def change
    create_table :fee_slabs do |t|
      t.decimal :value
      t.integer :lower_range
      t.integer :higher_range
      t.timestamps
    end
  end
end
