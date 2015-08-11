class CreateCalagators < ActiveRecord::Migration
  def change
    create_table :calagators do |t|

      t.timestamps
    end
  end
end
