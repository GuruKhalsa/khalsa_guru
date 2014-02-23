class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
    	t.string :name
    	t.text :description
    	t.integer :user_id
    	t.string :image
    
    	t.timestamps
    end
    add_index :projects, [:name, :user_id]
  end
end
