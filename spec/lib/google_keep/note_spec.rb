# frozen_string_literal: true

require "spec_helper"

describe GoogleKeep::Note do
  subject(:keep_note) { build_keep_note(attributes) }

  describe "#markdown_body" do
    subject(:markdown_body) { keep_note.markdown_body }

    context "when text content is empty" do
      let(:attributes) { { text_content: "" } }

      it { is_expected.to be nil }
    end

    context "when text content is present" do
      let(:attributes) do
        {
          text_content: <<~TEXT_CONTENT,
            My first line
            My second line
          TEXT_CONTENT
        }
      end

      it { is_expected.to eq("My first line\nMy second line\n") }
    end

    context "when keep note is a list items" do
      let(:attributes) do
        {
          text_content: nil,
          list_content: [
            { "text" => "Eat", "isChecked" => false },
            { "text" => "Write a library", "isChecked" => true }
          ],
        }
      end

      it { is_expected.to eq("- [ ] Eat\n- [x]  Write a library") }
    end
  end
end
