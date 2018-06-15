class MailingListSubscriberJob < ActiveJob::Base
  queue_as :default

  def perform(entry_id)
    entry = Entry.find(entry_id)

    MailingList
      .find(entry.competition.mailing_list_id)
      .add_subscriber(name: entry.name, email: entry.email)
  end
end
