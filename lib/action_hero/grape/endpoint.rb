module ActionHero
  module Grape
    module Endpoint

      def expose( *args )
        args.last.tap do |value|
          if args.size > 1
            name = args.first.is_a?( Symbol ) ? args.first : (raise NotImplementedError)
            self.class.send( :define_method, name, lambda { value } )
          end

          body( value )
        end
      end

    end
  end
end
