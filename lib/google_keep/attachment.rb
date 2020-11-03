# frozen_string_literal: true

module GoogleKeep
  # An attachment to a note
  class Attachment
    def initialize(attachment_hash)
      @attachment_hash = attachment_hash
    end

    # @return [String, nil]
    def file_path
      attachment_hash["filePath"]
    end

    # @return [String, nil]
    def mimetype
      attachment_hash["mimetype"]
    end
  end
end
