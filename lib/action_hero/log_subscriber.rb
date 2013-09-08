module ActionHero
  class LogSubscriber < ActiveSupport::LogSubscriber

    def start_processing( event )
      controller_name = "#{event.payload[:params]['controller'].camelize}Controller"
      unless event.payload[:controller] == controller_name
        info "[Action Hero] No explicit #{controller_name} defined, using #{event.payload[:controller]}"
      end
    end

  end
end
