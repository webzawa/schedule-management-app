# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :check_guest, only: %i[update destroy]

  # GET /resource/sign_up
  def new
    @stores = Store.all
    super
  end

  # POST /resource
  def create
    if User.find_by(:email => params[:user][:email])
      flash[:error] = '入力されたメールアドレスはすでに使用されています。'
      redirect_to users_paying_user_sign_in_path
      return
    end
    @stores = Store.all
    super

    if params[:user][:paying_signup_flag]
      customer = Stripe::Customer.create({
        email: params[:user][:email],
        description: "My First Test Customer (created for API docs) #{Time.zone.now}",
      })
      subscription = Stripe::Subscription.create(
        customer: customer.id,
        items: [{
          plan: "price_1IymOnARQpFlJcJAeUDkrGee",
        }],
      )
      user = User.find_by(:email => params[:user][:email])
      user.admin = true
      user.confirmed_at = Time.zone.now
      user.customer_id = customer.id
      user.plan_id = subscription.id
      user.save!
    end


    # 新規ユーザ登録を管理者に通知（paramsだとidがわからないが、リファクタリング後は管理者（課金ユーザ）に紐付けるので改修は容易か）
    # ApplicationMailer.confirmation_instructions_notification_for_admin(params[:user]).deliver
  end

  # GET /resource/edit
  def edit
    @stores = Store.all
    super
  end

  # PUT /resource
  def update
    @stores = Store.all
    super
  end

  def new_paying
    self.new
    # resource = User.new
    # byebug
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def check_guest
    if resource.email == 'guest@example.com' || resource.email == 'guest_admin@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません。'
    end
  end

end
