require 'test_helper'
require "net/imap"
require 'time'
require 'qrier/models/email'
require 'qrier/models/folder'
require 'qrier/services/list_folders'
require 'qrier/services/fetch_emails'

module Qrier
  class ListFoldersTest < Minitest::Test
    @@service = ListFolders.new
    @@service.execute

    def test_lists_folders
      assert_kind_of Folder, @@service.folders.first
    end

    def test_folders_has_emails
      assert_kind_of Email, @@service.folders.first.emails.first
    end
  end
end
