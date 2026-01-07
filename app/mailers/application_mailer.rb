class ApplicationMailer < ActionMailer::Base
  default from: "odinbook-no-reply@outlook.com",
          reply_to: "odinbook-no-reply@outlook.com"

  layout "mailer"
end
