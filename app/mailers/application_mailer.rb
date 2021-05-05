class ApplicationMailer < ActionMailer::Base
  default :from => 'from@example.com'
  layout 'mailer'

  def confirmation_instructions_notification_for_admin(new_user)
    @new_user = new_user

    admins = []
    User.where(:admin => true).each do |admin_user|
      admins << admin_user.email
    end

    mail(subject: "新規登録者通知(#{@new_user[:username]}様)", to: admins)
  end

  def login_approval_notification(user)
    @user = user

    mail(subject: "#{@user.username}様のログインが承認されました", to: @user.email)
  end
end
