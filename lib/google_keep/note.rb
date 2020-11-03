# frozen_string_literal: true

require_relative "attachment"
require_relative "list_item"

module GoogleKeep
  # This data-object takes a Google Keep JSON config
  # as hash and provides helpers around it.
  class Note
    # @param raw_attributes [Hash] a config as provided in Google Keep Takeout file
    def initialize(raw_attributes)
      @raw_attributes = raw_attributes
    end

    attr_reader :raw_attributes

    # @return [String, nil]
    def title
      @raw_attributes["title"] unless @raw_attributes["title"].to_s.strip.empty?
    end

    # @return [String, nil]
    def text_content
      @raw_attributes["textContent"] unless @raw_attributes["textContent"].to_s.strip.empty?
    end

    # @return [Array<GoogleKeep::ListItem>]
    def list_items
      return unless @raw_attributes["listContent"]

      @raw_attributes["listContent"].map { |list_item_hash| ListItem.new(list_item_hash) }
    end

    # @return [Array<GoogleKeep::Attachment>]
    def attachments
      @raw_attributes["attachments"]
    end

    def annotations
      raise "Unimplemented!"
      @raw_attributes["annotations"]
    end

    def sharees
      raise "Unimplemented!"
      @raw_attributes["sharees"]
    end

    # @return [Time]
    def last_edited_at
      return unless @raw_attributes["userEditedTimestampUsec"]

      microseconds_timestamp = @raw_attributes["userEditedTimestampUsec"]
      seconds_timestamp = microseconds_timestamp / 1_000_000
      Time.at(seconds_timestamp)
    end

    # @return [String, nil]
    def color
      @raw_attributes["color"]
    end

    # @return [Boolean, nil]
    def archived?
      @raw_attributes["isArchived"]
    end

    # @return [Boolean, nil]
    def pinned?
      @raw_attributes["isPinned"]
    end

    # @return [Boolean, nil]
    def trashed?
      @raw_attributes["isTrashed"]
    end

    # @return [String]
    def inspect
      @raw_attributes.to_json
    end
  end
end
