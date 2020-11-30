# frozen_string_literal: true

require_relative "../../lib/google_keep/note"

def build_keep_note(title: "My note title",
                    text_content: "My note body",
                    color: "DEFAULT",
                    trashed: false,
                    pinned: false,
                    archived: false,
                    timestamp: nil,
                    list_content: nil,
                    labels: [])
  raise "Can't have both list content and text content" if list_content && text_content

  timestamp ||= GoogleKeep.time_to_timestamp(Time.now)
  labels = labels.map { |l| { name: l } } if labels.any?

  config = {
    color: color,
    isTrashed: trashed,
    isPinned: pinned,
    isArchived: archived,
    textContent: text_content,
    listContent: list_content,
    title: title,
    userEditedTimestampUsec: timestamp,
    labels: labels,
  }.compact
  GoogleKeep::Note.new(config.transform_keys(&:to_s))
end
