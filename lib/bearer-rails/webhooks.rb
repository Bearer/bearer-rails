# frozen_string_literal: true

require "rack/request"
require_relative "./webhooks/bearer_invoke"
require_relative "./webhooks/base"

module BearerRails
  class Webhooks
    BEARER_SCENARIO_HANDLER = "BEARER-SCENARIO-HANDLER"
    private_constant :BEARER_SCENARIO_HANDLER
    BEARER_SHA = "BEARER-SHA"
    private_constant :BEARER_SHA
    BEARER_ORIGIN = "BEARER-ORIGIN"
    private_constant :BEARER_ORIGIN

    include ::BearerRails::BearerInvoke

    def call(env)
      req = Rack::Request.new(env)
      org_id, integration_id = get_integration_id(req) #=> 4lic3-github-attach-pull-request

      response = self.class.invoke(
        integration_id: integration_id,
        org_id: org_id,
        origin: origin,
        sha: sha,
        body: req.body
      )

      [response.status, { "Content-Type" => "application/json" }, [response.payload]]
    end

    private

    def get_bearer_header(req, header)
      rack_header = "HTTP_#{header.tr('-', '_')}"
      raise "Missing #{header} header" unless req[rack_header]

      req[rack_header]
    end

    def get_integration_id(req)
      header = get_bearer_header(req, BEARER_SCENARIO_HANDLER)
      org_id, *integration_title = header.split("-")
      [org_id, integration_title.join("_")]
    end

    def get_sha(req)
      get_bearer_header(req, BEARER_SHA)
    end

    def get_origin(req)
      get_bearer_header(req, BEARER_ORIGIN)
    end
  end
end
