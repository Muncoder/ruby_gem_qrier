require 'test_helper'
require "net/imap"
require 'time'
require 'qrier/models/email'
require 'qrier/services/fetch_emails'

module Qrier
  class FetchEmailsTest < Minitest::Test
    @@service = FetchEmails.new
    @@service.execute

    def test_fetches_emails
      assert_kind_of Email, @@service.emails.first
    end

    def test_email_has_proper_data
      assert_kind_of Time, @@service.emails.first.sent_at
    end
  end
end
