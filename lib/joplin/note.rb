# frozen_string_literal: true

require_relative "base"

module Joplin
  class Note < Base
    get :all, "/notes", defaults: { token: token }
    get :find, "/notes/:id", defaults: { token: token }
    put :save, "/notes/:id?token=#{token}"
    post :create, "/notes?token=#{token}"
    delete :remove, "/notes/:id?token=#{token}"
  end
end
