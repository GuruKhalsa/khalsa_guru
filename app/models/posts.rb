class Posts < ActiveRecord::Base
	attr_accessible :content, :user_id

	belongs_to :user
end
