# frozen_string_literal: true

require "active_support/core_ext/object/blank"
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
      @raw_attributes["title"] unless @raw_attributes["title"].blank?
    end

    # @return [String, nil]
    def text_content
      @raw_attributes["textContent"] unless @raw_attributes["textContent"].blank?
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

    def labels
      @raw_attributes["labels"]&.map { |hash| hash[:name] }
    end

    def annotations
      @raw_attributes["annotations"]
    end

    def sharees
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
      @raw_attributes["color"] if @raw_attributes["color"]&.strip&.size&.positive?
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

    def markdown_body
      if list_items&.any?
        list_items.map(&:to_markdown).join("\n")
      elsif text_content
        text_content
      end
    end
    alias body markdown_body
  end
end
