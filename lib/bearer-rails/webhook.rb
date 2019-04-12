# frozen_string_literal: true

module BearerRails
  module Webhook
    def self.registry
      @registry ||= []
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    attr_reader :buid, :body

    def initialize(buid:, body:)
      @buid = buid
      @body = body
    end

    def bearer_invoke(function_name, params: {})
      Bearer.call(buid, function_name, params: params)
    end

    module ClassMethods
      def integration_handler(handler)
        BearerRails::Webhook.registry.push(class: self, handler: handler)
      end
    end
  end
end
