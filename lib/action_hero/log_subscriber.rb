module ActionHero
  class LogSubscriber < ActiveSupport::LogSubscriber

    def start_processing( event )
      controller_name = "#{event.payload[:params]['controller'].camelize}Controller"
      unless event.payload[:controller] == controller_name
        info "[ActionHero] No explicit #{controller_name} falling back to #{event.payload[:controller]}"
      end
    end

  end
end
