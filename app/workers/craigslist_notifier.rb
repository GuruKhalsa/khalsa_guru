class CraigslistNotifier
  include Sidekiq::Worker
  def perform(name, count)
    easy = SMSEasy::Client.new
    easy.deliver(ENV[:notification_number], "at&t", "Hello Guru")
  end
end