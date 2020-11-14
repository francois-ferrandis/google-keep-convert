# frozen_string_literal: true

require "active_support/core_ext/string/filters"

# This class helps us determine a short title for an untitled note
class TitleFromBody
  MAX_TITLE_LENGTH = 80

  def initialize(body:, created_at:)
    @body = body
    @created_at = created_at
  end

  def short_title_from_body
    if @body.blank?
      nil
    elsif list_body?
      "List from #{Date.parse(@created_at.to_s)}"
    elsif @body.lines.first.length < MAX_TITLE_LENGTH
      @body.lines.first
    else
      @body.lines.first.truncate(MAX_TITLE_LENGTH, separator: " ")
    end
  end

  def list_body?
    @body.start_with?("- [")
  end
end
