#if %w(test development).include?(Rails.env)
#  ActionMailer::Base.delivery_method = :test
#  ActionMailer::Base.sendmail_settings = {:location => '/usr/bin/fake_sendmail.sh'}
#else
#  ActionMailer::Base.delivery_method = :smtp
#
#end

#config.action_mailer.delivery_method = :sendmail
## Defaults to:
## config.action_mailer.sendmail_settings = {
##   location: '/usr/sbin/sendmail',
##   arguments: '-i -t'
## }
#config.action_mailer.perform_deliveries = true
#config.action_mailer.raise_delivery_errors = true
#config.action_mailer.default_options = {from: 'no-replay@example.com'}

# Defaults to:
# config.action_mailer.sendmail_settings = {
#   location: '/usr/sbin/sendmail',
#   arguments: '-i -t'
# }

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default :charset => "utf-8"
ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :authentication => "login",
    :domain               => 'foodpal.com',
    :host                 => 'gmail.com',
    :user_name            => 'info@foodpal.com',
    :password             => 'Alexander55',
    :enable_starttls_auto => true
}