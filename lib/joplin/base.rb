# frozen_string_literal: true

require "flexirest"

module Joplin
  class Base < Flexirest::Base
    # proxy :json_api
    request_body_type :json

    class_attribute :token

    base_url "http://localhost:41184"
  end
end
