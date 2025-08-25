# frozen_string_literal: true

require "rspec"
require_relative "../lib/suchemer/cons"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |m|
    m.verify_partial_doubles = true
  end
end
