require "active_support/core_ext/hash/keys"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/string/inflections"
require "faraday"

require "drs/auth_client/models/organisation"
require "drs/auth_client/models/user"

module Drs
  module AuthClient
    class Client
      def initialize(auth_token)
        @auth_token = auth_token
      end

      def get(path, params = {})
        raise Errors::Unauthorised if @auth_token.blank?

        response = conn.get do |request|
          request.url path
          request.headers["Authorization"] = "Bearer #{@auth_token}"
          request.params = params
        end

        process_response(response)
      end

      #
      # Resource access methods
      #
      def organisation(id)
        get_resource("organisations/#{id}", Models::Organisation, :from_hash, nil)
      end

      def organisations(params = {})
        get_resource("organisations", Models::Organisation, :collection_from_hash, [], params)
      end

      def user(id)
        get_resource("users/#{id}", Models::User, :from_hash, nil)
      end

      def users(params = {})
        get_resource("users", Models::User, :collection_from_hash, [], params)
      end

      private

      def process_response(response)
        case (response.status)
          when 401
            raise Errors::Unauthorised
          when 403
            raise Errors::Forbidden
          when 500
            raise Errors::Internal
          when 200
            response.body
        end
      end

      def parse_response(response)
        JSON.parse(response).deep_symbolize_keys
      end

      def get_resource(path, model, model_method, default_result, params = {})
        return default_result if params.values.any?(&:empty?)

        response = get(path, params)
        if response
          model.send(model_method, parse_response(response))
        else
          default_result
        end
      end

      def conn
        api_url = "#{AuthClient.host}/api/#{AuthClient.version}"

        Faraday.new(api_url)
      end
    end
  end
end
