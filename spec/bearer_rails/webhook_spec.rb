# frozen_string_literal: true

require "spec_helper"

RSpec.describe BearerRails::Webhook do
  let!(:klass) do
    Class.new do
      include BearerRails::Webhook
      integration_handler :"goats-are-fun"
    end
  end

  it "registers the class to be a bearer webhook" do
    expect(BearerRails::Webhook.registry).to match_array([{ class: klass, handler: :"goats-are-fun" }])
  end
end
