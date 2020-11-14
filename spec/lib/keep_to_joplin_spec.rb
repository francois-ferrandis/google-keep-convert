# frozen_string_literal: true

require "spec_helper"

require_relative "../../lib/keep_to_joplin"

describe KeepToJoplin do
  subject(:joplin_note) { described_class.new(keep_note).joplin_note }

  context "when note has a title and a body" do
    let(:keep_note) do
      build_keep_note(
        title: "A cool idea",
        text_content: "Spend less time managing my notes. \nAlso, write tests for that program that converts my notes.",
      )
    end

    it "keeps title and body as is" do
      expect_attrs = {
        title: "A cool idea",
        body: "Spend less time managing my notes. \nAlso, write tests for that program that converts my notes.",
      }
      expect(joplin_note).to have_attributes(expect_attrs)
    end
  end

  context "when note is a list" do
    let(:keep_note) do
      build_keep_note(
        title: "I need to do these things",
        text_content: nil,
        list_content: [
          { "text" => "Eat", "isChecked" => false },
          { "text" => "Write a library", "isChecked" => true }
        ],
      )
    end

    it "keeps title and body as is" do
      expect_attrs = {
        title: "I need to do these things",
        body: <<~MARKDOWN.strip,
          - [ ] Eat
          - [x]  Write a library
        MARKDOWN
      }
      expect(joplin_note).to have_attributes(expect_attrs)
    end
  end

  context "when note has no title and a short body" do
    let(:keep_note) do
      build_keep_note(
        title: "",
        text_content: "Spend less time managing my notes.",
      )
    end

    it "keeps title and body as is" do
      expect_attrs = {
        title: nil,
        body: "Spend less time managing my notes.",
      }
      expect(joplin_note).to have_attributes(expect_attrs)
    end
  end

  context "when note has labels" do
    let(:keep_note) do
      build_keep_note(
        labels: %w[tag1 tag2],
      )
    end

    it "keeps concatenates them, as well as the color" do
      expect_attrs = {
        tags: "tag1,tag2,google-keep-color-DEFAULT",
      }
      expect(joplin_note).to have_attributes(expect_attrs)
    end
  end
end
