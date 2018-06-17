require 'rails_helper'

RSpec.describe MailingListSubscriberJob, type: :job do
  describe "#perform" do
    it "subscribes the user to the correct mailing list for the competition" do
      competition = Competition.create!(name: "Stargate competition", mailing_list_id: "12345")
      entry = competition.entries.create!(given_name: "Samantha", family_name: "Carter",
        email: "scarter@example.com")

      mailing_list_double = instance_double(MailingList)
      expect(MailingList).to receive(:find).with("12345") { mailing_list_double }
      expect(mailing_list_double).to receive(:add_subscriber).with(given_name: "Samantha",
        family_name: "Carter", email: "scarter@example.com")

      MailingListSubscriberJob.perform_now(entry.id)
    end
  end
end
