class ApplicationMailer < ActionMailer::Base
  default from: "koutaro130205@icloud.com", charset: 'ISO-2022-JP'
  layout "mailer"
end
