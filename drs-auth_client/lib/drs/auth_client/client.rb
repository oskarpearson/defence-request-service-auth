require 'active_support/core_ext/hash/keys'
require 'faraday'

module Drs
  module AuthClient
    class Client
      def initialize(auth_token)
        @auth_token = auth_token
      end

      def get(path)
        response = conn.get do |request|
          request.url path
          request.headers['Authorization'] = "Bearer #{@auth_token}"
        end

        if response.status == 200
          response.body
        else
          nil
        end
      end

      def organisation(uid)
        single_resource_get("organisations/#{uid}", Models::Organisation)
      end

      def organisations
        collection_resource_get("organisations", Models::Organisation)
      end

      private

      def resource_get(path)
        JSON.parse(get(path)).deep_symbolize_keys
      end

      def single_resource_get(path, model)
        hash = resource_get(path)
        model.from_hash(hash)
      end

      def collection_resource_get(path, model)
        hash = resource_get(path)
        model.collection_from_hash(hash) 
      end

      def conn
        api_url = "#{AuthClient.host}/api/#{AuthClient.version}"

        Faraday.new(api_url)
      end
    end
  end
end