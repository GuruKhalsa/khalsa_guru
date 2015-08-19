class PostsController < ApplicationController
	before_filter :authorize, only: [:new, :create, :edit, :update, :destroy]
	
	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		if @post.save
			redirect_to root_url, notice: "Thanks for posting!"
		else
			render "new"
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		if @post.update_attributes(post_params)
			redirect_to root_path
		else
			render edit
		end
	end

	def index
	end

	def show
		# @post = Post.where("active = ? AND id = ?", true, params[:id]).first
		@post = Post.find(params[:id])
		if !@post.active
			redirect_to root_url
		end
	end

	def destroy
		@post = Post.find(params[:id]).destroy
		redirect_to root_path
	end

	private

	def post_params
		params.require(:post).permit(:title, :content, :user_id, :image, :active)
	end


end
