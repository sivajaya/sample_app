class UsersController < ApplicationController
	before_action	:correct_user,    only:	[:edit,	:update]
	before_action	:logged_in_user,	only:	[:index, :edit,	:update, :destroy]
	before_action :admin_user,      only: :destroy

	def index
		@users = User.page(params[:page])
	end
	def show
		@user = User.find(params[:id])
	end
	def new
		@user=User.new
	end
	def edit
		@user = User.find(params[:id])
	end
	def update
		@user =User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success]	=	"Profile	updated"
			redirect_to	@user
		else
		  render edit
		end
	end
	def create
		@user = User.create(user_params)
		if @user.save
		# log_in @user
		# flash[:success] = "Welcome to the Sample App!"
		# redirect_to @user
		@user.send_activation_email
		p @user
		UserMailer.account_activation(@user).deliver_now
		flash[:info]	=	"Please	check	your	email	to	activate	your	account."
		redirect_to	
		end
	end
	def	destroy
		User.find(params[:id]).destroy
		flash[:success]	=	"User	deleted"
		redirect_to	users_url
	end
	def	logged_in_user
		unless	logged_in?
			flash[:danger]	=	"Please	log	in."
			redirect_to	login_url
   	end
	end

	private
	def logged_in_user
		unless logged_in?
			flash[:danger] = "Please Log in"
			redirect_to login_path
	 end
  end

	def	correct_user
		@user	=	User.find(params[:id])
		redirect_to(root_url)	unless	@user	==	current_user
	end
	private
	def user_params
	  params.require(:user).permit(:name,	:email,	:password, :password_confirmation)
	end
	def	admin_user
	  redirect_to(root_url)	unless	current_user.admin?
	end
end