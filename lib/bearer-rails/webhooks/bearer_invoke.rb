# frozen_string_literal: true

require "bearer"
require "openssl"
require "active_support"

module BearerRails
  module BearerInvoke
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      include ActiveSupport::Inflector

      def invoke(integration_id:, org_id:, origin:, sha:, body:)
        check_sha(sha, body)
        check_origin(origin)
        klass = constantize(classify(integration_id))
        klass.new(integration_id: integration_id, org_id: org_id, body: body).call
      end

      def check_sha(sha, body)
        calculated_sha = OpenSSL::HMAC.hexdigest(digest, Bearer::Configuration.secret, body)
        throw "Signature invalid" if sha != calculated_sha
      end

      def check_origin(origin) end

      def digest
        @digest ||= OpenSSL::Digest.new("sha256")
      end
    end
  end
end
