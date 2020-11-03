# frozen_string_literal: true

def build_keep_note(title: "", text_content: nil, color: "DEFAULT", trashed: false, pinned: false, archived: false, timestamp: nil, list_content: nil)
  raise "Can't have both list content and text content" if list_content && text_content

  timestamp ||= Time.now.to_i * 1_000_000 # microseconds

  config = {
    color: color,
    isTrashed: trashed,
    isPinned: pinned,
    isArchived: archived,
    textContent: text_content,
    listContent: list_content,
    title: title,
    userEditedTimestampUsec: timestamp
  }.compact
  GoogleKeep::Note.new(config.transform_keys(&:to_s))
end
