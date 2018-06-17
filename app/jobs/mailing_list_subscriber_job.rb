class MailingListSubscriberJob < ActiveJob::Base
  queue_as :default

  def perform(entry_id)
    entry = Entry.find(entry_id)

    MailingList
      .find(entry.competition.mailing_list_id)
      .add_subscriber(given_name: entry.given_name, family_name: entry.family_name,
        email: entry.email)
  end
end
