class InquiriesController < ApplicationController
  def create
    inquiry = Inquiry.new(inquiry_params)
    inquiry.user_id = current_user.id
    inquiry.request_datetime = Time.now
    if inquiry.save
      flash[:success] = '要望を送信しました。'
      redirect_to root_path
    else
      flash[:error] = '要望の送信に失敗しました。'
      redirect_to root_path
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:request_comment)
  end

end
