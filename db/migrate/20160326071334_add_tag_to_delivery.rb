class AddTagToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :archive_tagged, :boolean , default: false, after: :archive_delivered
  end
end
