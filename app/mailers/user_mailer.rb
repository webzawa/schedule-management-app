class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts={})
    @record = record

    #record内にユーザ情報が格納されている。"unconfirmed_email"の有無で登録／変更を分離
    #opts属性を上書きすることで、Subjectやfromなどのヘッダー情報を変更可能
    if @record.unconfirmed_email.blank?
      opts[:subject] = "ユーザ登録が完了しました、管理者の承認をお待ち下さい"
    else
      opts[:subject] = "メールアドレス変更手続きを完了してください"
    end
    #件名の指定以外は親を継承
    super
  end
end
