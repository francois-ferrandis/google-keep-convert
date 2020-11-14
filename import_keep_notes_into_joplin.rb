# frozen_string_literal: true

require "getoptlong"
require_relative "lib/google_keep/archive_parser"
require_relative "lib/keep_to_joplin"
require_relative "lib/title_from_body"

opts = GetoptLong.new(
  ["--input-dir", "-i", GetoptLong::REQUIRED_ARGUMENT],
  ["--joplin-token", "-t", GetoptLong::REQUIRED_ARGUMENT],
)

input_dir = nil
joplin_token = nil
opts.each do |opt, arg|
  case opt
  when "--input-dir"
    input_dir = File.join(__dir__, arg)
  when "--joplin-token"
    joplin_token = arg
  end
end

raise "No --input-dir provided" unless input_dir
raise "No --joplin-token provided" unless joplin_token

require_relative "lib/joplin/note"
Joplin::Base.token = joplin_token
require_relative "lib/joplin/note_book"

keep_notes = GoogleKeep::ArchiveParser.new(input_dir).notes

note_book = Joplin::NoteBook.create(title: "Google Keep import #{Time.now}")

keep_notes.each do |keep_note|
  joplin_note = KeepToJoplin.new(keep_note).joplin_note
  joplin_note.title ||= TitleFromBody.new(
    body: joplin_note.body,
    created_at: Time.at(joplin_note.user_created_time / 1000),
  ).short_title_from_body
  puts "Creating note: #{joplin_note.title}"
  joplin_note.parent_id = note_book.id
  joplin_note.create
end
