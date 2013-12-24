require 'active_support/concern'
require 'forwardable'

module ActionHero
  module Grape
    module Action

      extend ActiveSupport::Concern

      included do

        extend Forwardable
        extend ActionHero::ParamReader

        attr_reader :endpoint
        protected :endpoint

        def_delegators :endpoint, :content_type,
                                  :cookies,
                                  :error!,
                                  :headers,
                                  :params,
                                  :redirect,
                                  :route,
                                  :routes,
                                  :status,
                                  :version

      end

      def initialize( endpoint )
        @endpoint = endpoint
      end

      module ClassMethods

        def endpoint_delegations( *method_names )
          def_delegators :endpoint, *method_names
        end

      end

    protected

      def expose( *args )
        value = args.last

        if args.size > 1
          name = args.first.is_a?( Symbol ) ? args.first : (raise NotImplementedError)
          instance_variable_set "@#{name}", value
          self.class.send( :define_method, name, lambda { instance_variable_get "@#{name}" } )
        end

        endpoint.send :expose, *args
      end

    end
  end
end
