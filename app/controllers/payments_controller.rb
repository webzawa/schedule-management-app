class PaymentsController < ApplicationController
  before_action :user_plan_judgement, except: [:new, :payment_cancel]

  INITIAL_USER_NAME = "新規ユーザー"
  STRIPE_PRODUCT_ID = "prod_JZfnW9uMmAGECi"  # 商品IDを記述

  #決済後の画面遷移
  def new
    # @session = Stripe::Checkout::Session.create({
    #   payment_method_types: ['card'],
    #   line_items: [{
    #     price: 'price_1IwXswARQpFlJcJAZdzuNjqC', # 料金API-IDを記述
    #     quantity: 13,
    #   }],
    #   mode: 'subscription',
    #   success_url: request.base_url + '/payments/after_payment_register?session_id={CHECKOUT_SESSION_ID}',  # 決済成功後の遷移先
    #   cancel_url: request.base_url + '/payments/payment_cancel',  #決済キャンセルした際の遷移先
    # })
  session = Stripe::BillingPortal::Session.create({
    customer: current_user.customer_id,
    return_url: request.base_url,
  })

  redirect_to session.url


  end

  #決済前のキャンセルのアクション
  def payment_cancel
  end

  # 初期パスワードを乱数生成、初期ユーザー名を新規ユーザー、customer_id, email, plan_idをユーザーデータテーブルに登録
  def after_payment_register
    generated_initial_password = Devise.friendly_token.first(8)
    stripe_user_data = Stripe::Checkout::Session.retrieve(params[:session_id])    

    @user = User.new(
      customer_id: stripe_user_data.customer,
      username: INITIAL_USER_NAME,
      email: stripe_user_data.customer_details["email"],
      # password: generated_initial_password,
      password: 123456,
      plan_id: user_plan_judgement,
      confirmed_at: Time.zone.now,
      admin: true
    )
    pp stripe_user_data
    @user.save
    # send_notification_email
  end

  private

  # 1.プランIDを取得
  def user_plan_judgement
    stripe_plan_data = Stripe::Checkout::Session.list_line_items(params[:session_id])
    if stripe_plan_data[:data][0][:price]["product"] == STRIPE_PRODUCT_ID
      plan_id = "1"
    end
  end


end
