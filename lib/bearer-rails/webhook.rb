# frozen_string_literal: true

module BearerRails::Webhook
  def self.registry
    @registry ||= []
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  attr_reader :integration_id, :org_id, :body

  def initialize(integration_id:, org_id:, body:)
    @integration_id = integration_id
    @org_id = org_id
    @body = body
  end

  def bearer_invoke(function_name, params: {})
    Bearer.call("#{org_id}-#{integration_id}", function_name, params: params)
  end

  module ClassMethods
    def integration_handler(handler)
      BearerRails::Webhook.registry.push(class: self, handler: handler)
    end
  end
end
