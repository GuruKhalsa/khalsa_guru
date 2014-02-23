class Projects < ActiveRecord::Base
	attr_accessible :name, :description, :user_id, :image

	belongs_to :user
end
