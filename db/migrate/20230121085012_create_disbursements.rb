class CreateDisbursements < ActiveRecord::Migration[6.0]
  def change
    create_table :disbursements do |t|
      t.references :order
      t.decimal :fee_amount
      t.decimal :final_amount
      t.timestamps
    end
  end
end
