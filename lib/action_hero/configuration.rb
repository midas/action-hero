module ActionHero

  class Configuration

    def implicit_controllers
      @implicit_controllers ||= []
    end

    def implicit_controllers=( value )
      @implicit_controllers = value
    end

  end

end
