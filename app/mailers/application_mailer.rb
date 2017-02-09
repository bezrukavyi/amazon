class ApplicationMailer < ActionMailer::Base
  default from: Figaro.env.mail_sender
  layout 'mailer'
end
