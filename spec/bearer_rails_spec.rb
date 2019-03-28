# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe BearerRails do
  it "has a version number" do
    expect(BearerRails::VERSION).not_to be nil
  end
end
