class DelayedJobMessenger < Messenger
  def send(message)
    priority = (Time.now.usec % 8 + 1)
    Delayed::Job.enqueue Delayed::PerformableMethod.new(self, :do_request, message), priority
  end
end
