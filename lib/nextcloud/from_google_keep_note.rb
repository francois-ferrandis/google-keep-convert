# frozen_string_literal: true

require "date"
require_relative "note_file"
require_relative "../title_from_body"

module Nextcloud
  # Convert from Keep to Nextcloud notes
  class FromGoogleKeepNote
    # @param keep_note [GoogleKeep::Note]
    def initialize(keep_note)
      @keep_note = keep_note
    end

    def call
      file_timestamp = @keep_note.last_edited_at
      NoteFile.new(filename: filename, file_timestamp: file_timestamp, file_content: content)
    end

    def filename
      title_from_body = TitleFromBody.new(
        body: @keep_note.markdown_body,
        created_at: @keep_note.last_edited_at,
      ).short_title_from_body
      filename = @keep_note.title || title_from_body || Time.now.to_s
      filename = filename.gsub(%r{[#°<>:;"/\\|?*]}, "")[0, 60].strip
      raise "Can't compute file name for #{@keep_note.raw_attributes}" if filename.blank?

      filename += ".txt"
      filename
    end

    def content
      @keep_note.body
    end
  end
end
