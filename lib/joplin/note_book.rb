# frozen_string_literal: true

require_relative "base"

module Joplin
  class NoteBook < Base
    get :all, "/folders", defaults: { token: token }
    get :find, "/folders/:id", defaults: { token: token }
    put :save, "/folders/:id?token=#{token}"
    post :create, "/folders?token=#{token}"
    delete :remove, "/folders/:id?token=#{token}"

    def self.find_by_title(title)
      all.find do |note_book|
        note_book.title == title
      end
    end
  end
end
