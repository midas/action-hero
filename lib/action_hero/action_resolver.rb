module ActionHero
  class ActionResolver

    attr_reader :module_name,
                :action_name

    def initialize( options )
      @module_name = normalize_controller( options )
      @action_name = options[:action_name]
    end

    def action_class
      @action_class ||= action_class_name.constantize
    end

    def action_class_name
      @action_class_name ||= [
        module_name,
        action_name.camelize
      ].join( '::' )
    end

    def action_class_file_exists?
      File.exists?( Rails.root.join( 'app', 'actions', "#{action_class_name.underscore}.rb" ))
    end

  protected

    def normalize_controller( options )
      if options[:controller_const]
        options[:controller_const].gsub( /Controller$/, '' )
      elsif options[:controller]
        options[:controller].classify
      end
    end

  end
end
