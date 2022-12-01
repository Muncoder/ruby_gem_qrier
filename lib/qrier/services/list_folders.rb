module Qrier
  class ListFolders
    def execute
      connect
      list_folders do |folder|
        fetch_emails folder
      end
    ensure
      @imap.disconnect
    end

    def folders
      @folders ||= []
    end

    def connect
      @imap = Net::IMAP.new ENV['QRIER_SERVER'], 993, true
      @imap.login ENV['QRIER_USER'], ENV['QRIER_PWD']
    end

    def list_folders(&block)
      list = @imap.list "*", "*"
      list.each do |folder_data|
        folder = Folder.new(folder_data)
        folders << folder
        yield folder
      end
    end

    def fetch_emails(folder)
      service = FetchEmails.new(folder: folder.name, keep_alive: true)
      service.execute

      folder.add_emails(service.emails)
    end
  end
end