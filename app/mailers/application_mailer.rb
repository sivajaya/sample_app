require "letter_opener"
class ApplicationMailer < ActionMailer::Base
  default from: "from@gmail.com"
  layout 'mailer'
end
ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, :location => File.expand_path('../tmp/letter_opener', __FILE__)
ActionMailer::Base.delivery_method = :letter_opener