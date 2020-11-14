# frozen_string_literal: true

require_relative "joplin/note"

class KeepToJoplin
  # @param [GoogleKeep::Note]
  def initialize(keep_note)
    @keep_note = keep_note
  end

  def joplin_note
    Joplin::Note.new(
      title: title,
      body: body,
      updated_time: timestamp,
      user_created_time: timestamp,
      user_updated_time: timestamp,
      tags: tags,
    )
  end

  private

  def title
    @keep_note.title
  end

  def body
    @keep_note.markdown_body
  end

  def timestamp
    @timestamp ||= @keep_note.last_edited_at.to_i * 1000
  end

  def tags
    tags = @keep_note.labels || []
    tags += ["google-keep-color-#{@keep_note.color}"] if @keep_note.color
    tags.join(",")
  end
end
