require "rails_helper"

RSpec.describe EntriesController do
  let(:competition) { Competition.create!(name: "Stargate Competition") }

  describe "#create" do
    context "when the entry is saved successfully" do

      it "adds the entry to the competition mailing list" do
        allow(MailingListSubscriberJob).to receive(:perform_later)

        post :create, entry: { competition_id: competition, given_name: "Daniel",
          family_name: "Jackson", email: "djackson@example.com" }

        entry = Entry.find_by!(email: "djackson@example.com")
        expect(MailingListSubscriberJob).to have_received(:perform_later).with(entry.id)
      end
    end

    context "when the entry could not be saved" do
      it "does not attempt to add the entry to the competition mailing list" do
        expect(MailingListSubscriberJob).not_to receive(:perform_later)

        post :create, entry: { competition_id: competition }
      end
    end
  end
end
