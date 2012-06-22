class AddReadToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :read, :boolean

  end
end
