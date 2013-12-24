module ActionHero
  module ParamReader

    def param_reader( *param_names )
      param_names.each do |param_name|
        define_method param_name do
          params[param_name]
        end
      end
    end

  end
end
