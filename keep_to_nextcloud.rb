# frozen_string_literal: true

require_relative "lib/google_keep/archive_parser"
require_relative "lib/nextcloud/from_google_keep_note"

require "getoptlong"

opts = GetoptLong.new(
  ["--input-dir", "-i", GetoptLong::REQUIRED_ARGUMENT],
  ["--output-dir", "-o", GetoptLong::REQUIRED_ARGUMENT]
)

input_dir = nil
output_dir = nil
opts.each do |opt, arg|
  case opt
  when "--input-dir"
    input_dir = File.join(__dir__, arg)
  when "--output-dir"
    output_dir = File.join(__dir__, arg)
  end
end

raise "No --input-dir provided" unless input_dir
raise "No --output-dir provided" unless output_dir

keep_notes = GoogleKeep::ArchiveParser.new(input_dir).notes

keep_notes.each do |keep_note|
  subdir = if keep_note.archived?
             "archived"
           elsif keep_note.pinned?
             "pinned"
           elsif keep_note.trashed?
             "trashed"
           elsif keep_note.color == "PINK"
             "lol"
           end
  current_output_dir = output_dir
  current_output_dir = File.join(current_output_dir, subdir) if subdir
  Dir.mkdir(current_output_dir) unless File.exist?(current_output_dir)
  nexcloud_note = Nextcloud::FromGoogleKeepNote.new(keep_note).call
  nexcloud_note.write_file(path: current_output_dir)
end
