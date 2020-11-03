require "spec_helper"

describe Nextcloud::FromGoogleKeepNote do
  subject(:nextcloud_note) { described_class.new(keep_note) }

  context "when keep note is purely text" do
    let(:keep_note) do
      build_keep_note(
        title: "",
        text_content: "Singing trashcans\n\nand\n\nother things"
      )
    end

    it "uses the first line for file name" do
      expect(nextcloud_note.filename).to eq("Singing trashcans.txt")
    end

    it "uses the untouched text for file content" do
      expect(nextcloud_note.content).to eq("Singing trashcans\n\nand\n\nother things")
    end

    context "when first line is longer that 60 chars" do
      let(:keep_note) do
        build_keep_note(
          title: "",
          text_content: "123456789x----------20--------30--------40--------50--------60--------70----"
        )
      end

      it "file name is computed by trimming it to 60 chars" do
        expect(nextcloud_note.filename).to eq("123456789x----------20--------30--------40--------50--------.txt")
      end
    end
  end

  context "when keep note has title and text" do
    let(:keep_note) do
      build_keep_note(
        title: "I need to tell Jim about this",
        text_content: "Singing trashcans\n\nand\n\nother things"
      )
    end

    it "uses the title for file name" do
      expect(nextcloud_note.filename).to eq("I need to tell Jim about this.txt")
    end

    it "uses the the title and body file content" do
      expected_note_content = <<~MARKDOWN.strip
        # I need to tell Jim about this

        Singing trashcans

        and

        other things
      MARKDOWN
      expect(nextcloud_note.content).to eq(expected_note_content)
    end
  end

  context "when keep note has a title and list items" do
    let(:keep_note) do
      build_keep_note(
        title: "Todo this month",
        list_content: [
          { "text" => "Eat", "isChecked" => false },
          { "text" => "Write a library", "isChecked" => true }
        ]
      )
    end

    it "uses the title for file name" do
      expect(nextcloud_note.filename).to eq("Todo this month.txt")
    end

    it "uses the the title and body file content" do
      expected_note_content = <<~MARKDOWN.strip
        # Todo this month

        - [ ] Eat
        - [x]  Write a library
      MARKDOWN
      expect(nextcloud_note.content).to eq(expected_note_content)
    end
  end

  context "when keep note has no title and list items" do
    let(:keep_note) do
      build_keep_note(
        title: "",
        list_content: [
          { "text" => "Eat", "isChecked" => false },
          { "text" => "Write a library", "isChecked" => true }
        ],
        timestamp: 1547664660978000
      )
    end

    it "uses the title for file name" do
      expect(nextcloud_note.filename).to eq("List from 2019-01-16.txt")
    end

    it "uses the the title and body file content" do
      expected_note_content = <<~MARKDOWN.strip
        # List from 2019-01-16

        - [ ] Eat
        - [x]  Write a library
      MARKDOWN
      expect(nextcloud_note.content).to eq(expected_note_content)
    end
  end
end
