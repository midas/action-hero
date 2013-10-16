require 'active_support/concern'
require 'forwardable'

module ActionHero
  module Action

    extend ActiveSupport::Concern

    included do

      extend Forwardable

      attr_reader :controller
      protected :controller

      def_delegators :controller, :action_name,
                                  :env,
                                  :flash,
                                  :formats,
                                  :head,
                                  :headers,
                                  :params,
                                  :redirect_to,
                                  :render,
                                  :render_to_string,
                                  :request,
                                  :reset_session,
                                  :respond_with,
                                  :response,
                                  :session,
                                  :url_for,
                                  :url_options

    end

    def initialize( controller )
      @controller = controller
    end

  protected

    def expose( *args )
      name = args.first.is_a?( Symbol ) ? args.first : (raise NotImplementedError)
      value = args.last
      instance_variable_set "@#{name}", value
      self.class.send( :define_method, name, lambda { instance_variable_get "@#{name}" } )
      controller.send :expose, *args
    end

  end
end
