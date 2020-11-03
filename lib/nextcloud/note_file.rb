# frozen_string_literal: true

require "fileutils"

module Nextcloud
  # This represents a Note in Nexcloud, which are each stored in separate files
  class NoteFile
    def initialize(filename:, file_timestamp: Time.now, file_content: "")
      @filename = filename
      @file_timestamp = file_timestamp
      @file_content = file_content
    end

    def write_file(path:)
      file_path = File.join(path, @filename)
      FileUtils.touch(file_path)
      File.write(file_path, @file_content, mode: "w:utf-8")
      FileUtils.touch(file_path, mtime: @file_timestamp)
    end
  end
end
