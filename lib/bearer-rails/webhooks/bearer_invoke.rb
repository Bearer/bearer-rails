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

      def invoke(buid:, origin:, sha:, body:)
        check_sha(sha, body)
        check_origin(origin)

        records_to_invoke = BearerRails::Webhook.registry.select do |record|
          record[:handler] == buid
        end

        records_to_invoke.map do |record|
          record[:class].new(buid: buid, body: body).call
        end
      end

      def check_sha(sha, body)
        calculated_sha = OpenSSL::HMAC.hexdigest(digest, Bearer::Configuration.encryption_key, body)
        throw "Signature invalid" if sha != calculated_sha
      end

      def check_origin(origin) end

      def digest
        @digest ||= OpenSSL::Digest.new("sha256")
      end
    end
  end
end
