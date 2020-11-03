# frozen_string_literal: true

require "json"
require_relative "note"

module GoogleKeep
  # This class runs through all JSON files in the directory
  # and instantiates a Note objects for each file, through the #notes method.
  class ArchiveParser
    # @param archive_path [String]
    def initialize(archive_path)
      @archive_path = archive_path
    end

    # @return [Array<GoogleKeep::Note>] a list of GoogleKeep::Note objects, one for each JSON file
    def notes
      json_files.map do |json_file|
        note_attributes = JSON.parse(File.read(json_file))
        Note.new(note_attributes)
      end
    end

    # @return [Array] the list of JSON files in the archive
    def json_files
      Dir["#{@archive_path}/*.json"]
    end
  end
end
