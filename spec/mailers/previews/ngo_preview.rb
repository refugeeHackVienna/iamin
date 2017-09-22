# Preview all emails at http://localhost:3000/rails/mailers/ngo
class NgoPreview < ActionMailer::Preview
  def admin_confirmed
    NgoMailer.admin_confirmed(Ngo.first)
  end

  def ongoing_event_opt_in
    ongoing_event = OngoingEvent.first
    NgoMailer.ongoing_event_opt_in(
      ngo: ongoing_event.ngo,
      ongoing_event: ongoing_event,
      user: User.first
    )
  end

  def notify_of_expiring_ongoing_event
    ongoing_event = OngoingEvent.first
    NgoMailer.notify_of_expiring_ongoing_event(
      ngo: ongoing_event.ngo,
      ongoing_event: ongoing_event
    )
  end

  def notify_of_expired_ongoing_event
    ongoing_event = OngoingEvent.first
    NgoMailer.notify_of_expired_ongoing_event(
      ngo: ongoing_event.ngo,
      ongoing_event: ongoing_event
    )
  end
end
