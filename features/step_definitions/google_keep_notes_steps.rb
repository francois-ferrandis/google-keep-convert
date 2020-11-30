# frozen_string_literal: true

require_relative "../../lib/keep_to_joplin"
require_relative "../../lib/google_keep/note"

Given "this Google Keep note" do |table|
  attributes = table.symbolic_hashes.first
  attributes[:timestamp] = Time.parse("#{attributes[:timestamp]} UTC") if attributes[:timestamp].presence.is_a?(String)
  if attributes[:timestamp].presence.is_a?(Time)
    attributes[:timestamp] = GoogleKeep.time_to_timestamp(attributes[:timestamp])
  end
  @keep_note = build_keep_note(attributes)
end

When "I convert it to Joplin" do
  @joplin_note = KeepToJoplin.new(@keep_note).joplin_note
end

Then "the Joplin note should have attributes" do |table|
  attributes = table.symbolic_hashes.first

  attributes[:updated_time] = attributes[:updated_time].to_i
  attributes[:user_created_time] = attributes[:user_created_time].to_i
  attributes[:user_updated_time] = attributes[:user_updated_time].to_i

  expect(@joplin_note).to have_attributes(attributes)
end
