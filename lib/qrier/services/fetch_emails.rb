module Qrier
  class FetchEmails
    def initialize(options={})
      @folder = options[:folder] || "INBOX"
      @imap = options[:imap]
      @keep_alive = options[:keep_alive] || false
    end

    def execute
      connect
      fetch_emails
      transform
    ensure
      @imap.disconnect unless @keep_alive
    end

    def emails
      @emails ||= []
    end

    private

    def connect
      unless @imap
        @imap = Net::IMAP.new ENV['QRIER_SERVER'], 993, true
        @imap.login ENV['QRIER_USER'], ENV['QRIER_PWD']
      end
    end

    def fetch_emails
      @email_data = []
      @imap.examine "MUN"
      @imap.search([ "ALL" ]).each do |id|
        # require 'pry'; binding.pry
        envelope = @imap.fetch(id, "ENVELOPE")[0].attr["ENVELOPE"]
        uid = @imap.fetch(id, "UID")[0].attr["UID"]
        flags = @imap.fetch(id, "FLAGS")[0].attr["FLAGS"]
        body = @imap.fetch(id, "BODY[TEXT]")[0].attr["BODY[TEXT]"]
        @email_data << { envelope: envelope,
                         uid: uid,
                         flags: flags,
                         body: body}
      end
    end

    def transform
      @email_data.each do |item|
        # require 'pry'; binding.pry
        emails << Email.new({
                                from: address(item[:envelope].from),
                                to: address(item[:envelope].to),
                                subject: item[:envelope].subject,
                                sent_at: Time.parse(item[:envelope].date),
                                body: item[:body].force_encoding('utf-8'),
                              })

      end
      # require 'pry'; binding.pry

    end

    def address(field)
      field ? field.map{ |item| [item.mailbox, '@', item.host].join } : nil
    end
  end
end

