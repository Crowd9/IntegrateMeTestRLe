require "rails_helper"

RSpec.describe MailingList do
  describe "#add_subscriber" do
    context "when the Mailchimp API responds successfully" do
      it "returns true" do
        # The actual response is a lot bigger but this is enough to ensure the integration is working.
        stub_request(:post, "https://us18.api.mailchimp.com/3.0/lists/123456/members")
          .with(body: hash_including(email_address: "tealc@example.com"))
          .to_return(status: 200, body: '{
            "id":"bb365e8477053edcc55b40c3d27781d8",
            "email_address":"tealc@example.com",
            "unique_email_id":"38d27fcb79",
            "email_type":"html",
            "status":"subscribed"
          }')

        expect(MailingList.find("123456").add_subscriber(email: "tealc@example.com")).to eq true
      end
    end

    context "when the Mailchimp API responds with an error" do
      it "rewraps the error and throws it" do
        stub_request(:post, "https://us18.api.mailchimp.com/3.0/lists/123456/members")
          .with(body: hash_including(email_address: ""))
          .to_return(status: 400, body: '{
            "type":"http://developer.mailchimp.com/documentation/mailchimp/guides/error-glossary/",
            "title":"Invalid Resource",
            "status":400,
            "detail":"Please provide a valid email address.",
            "instance":"8b85d2a7-5ad6-4d84-87f1-7dc9c2ddc540"
          }')

        expect { MailingList.find("123456").add_subscriber(email: "") }
          .to raise_error(MailingList::APIError)
      end
    end
  end
end
