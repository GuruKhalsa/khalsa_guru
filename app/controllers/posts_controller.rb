class PostsController < ApplicationController
	before_filter :authorize, only: [:new, :create, :edit, :update, :destroy]
	
	def new
	end

	def create
	end

	def edit
	end

	def update
	end

	def index
	end

	def show
	end

	def destroy
	end

	private

	def post_params
		params.require(:post).permit(:content, :user_id)
	end


end
