# frozen_string_literal: true

module GoogleKeep
  # An item of a list-type Note:
  #   ☐ Do laundry         -> checked?=> false, text=> "Do laundry"
  #   ☑ Code a library     -> checked?=> true , text=> "Code a library"
  #   ☐ Eat                -> checked?=> false, text=> "Eat"
  class ListItem
    def initialize(item_hash)
      @item_hash = item_hash
    end

    # @return [String]
    def text
      @item_hash["text"].to_s
    end

    # @return [Boolean]
    def checked?
      @item_hash["isChecked"] == true
    end

    def to_markdown
      checkbox = checked? ? "[x] " : "[ ]"
      "- #{checkbox} #{text}"
    end
  end
end
