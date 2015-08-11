class StaticPagesController < ApplicationController

	def home
		@posts = Post.all
	end

	def about
	end

	def spirit_voyage
	end

	def opal
	end

	def battleship
	end

	def static_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end
end
