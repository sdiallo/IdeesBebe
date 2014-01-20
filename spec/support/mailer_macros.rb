module MailerMacros

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def deliveries
    ActionMailer::Base.deliveries
  end

  def reset_email
    ActionMailer::Base.deliveries.clear
  end

  def deliveries_to(emails)
    ActionMailer::Base.deliveries.reject do |email|
      (email.to & emails).empty?
    end
  end

  def deliveries_with_subject(subject)
    ActionMailer::Base.deliveries.select do |email|
      email.subject == subject
    end
  end
end