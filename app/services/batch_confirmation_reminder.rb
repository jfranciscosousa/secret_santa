class BatchConfirmationReminder
  attr_reader :reminders_sent

  def initialize(users = nil)
    @success = false
    @reminders_sent = 0
    @users = users || User.unconfirmed
  end

  def successful?
    @success
  end

  def perform
    @reminders_sent = users.inject(0) do |acc, user|
      remind(user) ? acc + 1 : acc
    end

    @success = reminders_sent != 0
  end

  private

  attr_reader :users

  def remind(user)
    confirmation_reminder = ConfirmationReminder.new(user)
    confirmation_reminder.perform

    confirmation_reminder.successful?
  end
end
