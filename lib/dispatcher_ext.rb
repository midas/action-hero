module ActionDispatch
  module Routing
    class RouteSet
      class Dispatcher

      private

        def controller(params, default_controller=true)
          if params && params.key?(:controller)
            controller_param = params[:controller]
            action_param = params[:action]
            controller_reference(controller_param, action_param)
          end
        rescue NameError => e
          raise ActionController::RoutingError, e.message, e.backtrace if default_controller
        end

        def controller_reference(controller_param, action_param)
          const_name = @controller_class_names[controller_param] ||= "#{controller_param.camelize}Controller"
          ActiveSupport::Dependencies.constantize(const_name)
        rescue NoMethodError
          # protect against misidentification due to
          # NoMethodError being descendent of NameError
          raise
        rescue NameError
          action_hero_resolver = ActionHero::ActionResolver.new( :controller => controller_param,
                                                                 :action_name => action_param )
          unless action_hero_resolver.action_class_file_exists?
            raise
          end

          controller_const = nil
          ActionHero.configuration.implicit_controllers.each do |regex, controller|
            if regex.match( "/#{controller_param}" )
              controller_const = controller
              break
            end
          end

          raise NameError unless controller_const
          controller_const
        end

      end
    end
  end
end
