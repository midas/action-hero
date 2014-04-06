require 'active_support/concern'

module ActionHero
  module Rails
    module Controller

      extend ActiveSupport::Concern

      def expose( *args )
        name = args.first.is_a?( Symbol ) ? args.first : (raise NotImplementedError)
        value = args.last
        data.merge!( name => value )
        self.class.send( :define_method, name, lambda { data[name] } )
        self.class.helper_method name
        value
      end

    protected

      def action_missing( name, *args, &block )
        begin
          action_class
        rescue NoMethodError
          # protect against misidentification due to
          # NoMethodError being descendent of NameError
          raise
        rescue NameError => ex
          raise ActionNotFound,
                "The action #{action_class_name} nor #{self.class.name}##{name} could be found, INNER EXCEPTION: #{ex.message}",
                ex.backtrace
        end
        prepend_view_path "#{::Rails.root}/app/views/#{params[:controller]}"
        execute_action
      end

      # override _normalize_render in order to insert implied controller's view prefix
      def _normalize_render(*args, &block)
        options = _normalize_args(*args, &block)
        _normalize_options(options)
        unless options[:prefixes].include?( params[:controller] )
          options[:prefixes].insert( 0, params[:controller] )
        end
        options
      end

      def data
        @data ||= {}.with_indifferent_access
      end

      def execute_action
        action = action_class.new( self )
        action.call
      end

      def resolver
        @resolver ||= ActionResolver.new( :controller_const => "#{params[:controller].classify}Controller",
                                          :action_name => action_name )
      end

      def action_class
        resolver.action_class
      end

      def action_class_name
        resolver.action_class_name
      end

    end
  end
end
