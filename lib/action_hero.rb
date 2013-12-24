require "action_hero/version"
require "dispatcher_ext" # TODO require for Rails only

module ActionHero

  class ActionNotFound < StandardError #:nodoc:
  end

  autoload :ActionResolver, 'action_hero/action_resolver'
  autoload :Configuration,  'action_hero/configuration'
  autoload :Grape,          'action_hero/grape'
  autoload :LogSubscriber,  'action_hero/log_subscriber'
  autoload :MockController, 'action_hero/mock_controller'
  autoload :ParamReader,    'action_hero/param_reader'
  autoload :Rails,          'action_hero/rails'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield( configuration ) if block_given?
  end

end

# TODO for Rails only
ActionHero::LogSubscriber.attach_to :action_controller
