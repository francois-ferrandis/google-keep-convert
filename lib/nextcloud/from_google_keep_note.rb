# frozen_string_literal: true

require "date"
require_relative "note_file"

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
      filename = title || body.lines(chomp: true).first || Time.now.to_s
      filename = filename.gsub(%r{[#°<>:;"/\\|?*]}, "")[0, 60]
      raise @keep_note.attributes if filename.to_s.strip.empty?

      filename += ".txt"
      filename
    end

    def content
      if title
        "# #{title}\n\n#{body}"
      else
        body
      end
    end

    def title
      if @keep_note.title
        @keep_note.title
      elsif @keep_note.list_items&.any?
        "List from #{Date.parse(@keep_note.last_edited_at.to_s)}"
      end
    end

    def body
      if @keep_note.list_items&.any?
        @keep_note.list_items.map(&:to_s).join("\n")
      elsif @keep_note.text_content
        @keep_note.text_content
      else
        ""
      end
    end
  end
end
