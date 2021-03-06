class ProjectsController < ApplicationController
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

	def project_params
		params.require(:project).permit(:name, :description, :user_id, :image)
	end

end
