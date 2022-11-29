module Qrier
  class Email
    attr_reader :to, :from, :sent_at, :subject

    def initialize(options=[])
      @to = options[:to]
      @from = options[:from]
      @sent_at = options[:sent_at]
      @subject = options[:subject]
    end
  end
end
