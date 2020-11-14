# frozen_string_literal: true

require "spec_helper"

require_relative "../../../lib/joplin/base"
Joplin::Base.token = "j0pl1n_t0k3n"
require_relative "../../../lib/joplin/note"

describe Joplin::Note do
  describe ".all" do
    subject(:all) { described_class.all }

    it "calls the local instance of Joplin" do
      stub_request(:get, /localhost/)
      all
      expect(WebMock).to have_requested(:get, "http://localhost:41184/notes?token=j0pl1n_t0k3n")
    end
  end

  describe ".save" do
    it "calls the local instance of Joplin" do
      joplin_note = Joplin::Note.new(title: "That's sweet!")

      stub_request(:post, /localhost/)
      joplin_note.create
      body = { title: "That's sweet!" }.to_json
      expect(WebMock).to have_requested(:post, "http://localhost:41184/notes?token=j0pl1n_t0k3n").with(body: body)
    end
  end
end
