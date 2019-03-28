# frozen_string_literal: true

class BearerRails::Webhooks
  class Base
    attr_reader :integration_id, :org_id, :body

    def initialize(integration_id:, org_id:, body:)
      @integration_id = integration_id
      @org_id = org_id
      @body = body
    end

    def bearer_invoke(function_name, params: {})
      Bearer.call("#{org_id}-#{integration_id}", function_name, params: params)
    end
end
end
