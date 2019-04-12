# frozen_string_literal: true

require "rack/request"
require_relative "./webhooks/bearer_invoke"

module BearerRails
  class Webhooks
    BEARER_INTEGRATION_HANDLER = "BEARER-INTEGRATION-HANDLER"
    private_constant :BEARER_INTEGRATION_HANDLER
    BEARER_SHA = "BEARER-SHA"
    private_constant :BEARER_SHA
    BEARER_ORIGIN = "BEARER-ORIGIN"
    private_constant :BEARER_ORIGIN

    include ::BearerRails::BearerInvoke

    def call(env)
      req = Rack::Request.new(env)
      buid = get_bearer_header(req, BEARER_INTEGRATION_HANDLER)
      origin = get_origin(req)
      sha = get_sha(req)

      result = self.class.invoke(
        buid: buid,
        origin: origin,
        sha: sha,
        body: req.body.string
      )

      return [200, { "Content-Type" => "application/json" }, ["{\"ack\":\"ok\"}"]] if result

      [422, { "Content-Type" => "application/json" }, [""]]
    rescue StandardError => e
      [500, { "Content-Type" => "application/json" }, ["{\"error\":#{e.to_json}}"]]
    end

    private

    def get_bearer_header(req, header)
      rack_header = "HTTP_#{header.tr('-', '_')}"
      header_value = req.env[rack_header]
      raise "Missing #{header} header" unless header_value

      header_value
    end

    def get_sha(req)
      get_bearer_header(req, BEARER_SHA)
    end

    def get_origin(req)
      get_bearer_header(req, BEARER_ORIGIN)
    end
  end
end
