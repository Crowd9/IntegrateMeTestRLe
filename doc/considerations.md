# Thought Processes and Other Considerations

* To minimize performance impact for users, accessing the external API should be done outside the main controller process, ie. in a background job. I've added a basic Sidekiq setup for this purpose.

* I've decided that Mailchimp integration with competition management is out of the scope of this task. In the real app, when managing a competition, there could be several possibilities:
  * The admin could be given the option of selecting an existing Mailchimp mailing list to subscribe users to, or
  * A new mailing list is auto-created for each new competition.
Either way, the ID of that mailing list will be stored with the Competition record. I've created some test mailing lists in my personal Mailchimp account and hardcoded those via a data migration.

* Secrets support was minimal in Rails 4.2, so I've relied on loading my Mailchimp API key from an ENV var in both dev and production. If using Rails 5 I'd use encrypted secrets, or a library like Figaro.

* For i18n purposes, I decided against splitting the data entered into the name field, into first and last name components - there's no way to do this totally correctly even in English. Instead, I elected to change the one "Name" field into two - for given name and family name.
  * I've used naive string splitting for existing data only because I know there isn't any existing data that would fail by doing this :)
  * Alternatively, Mailchimp could have been configured to store a single "Name" field, but then this would prevent things like addressing emails with just a user's given name.

* Possible optimizations include:
  * Batching subscriptions into groups of a certain size or time range, to save hitting the API too many times
