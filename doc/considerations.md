# Considerations

* To minimize performance impact for users, accessing the external API should be done outside the main controller process, ie. in a background job. I've added a basic Sidekiq setup for this purpose.
