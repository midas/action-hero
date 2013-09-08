require "action_hero/version"
require "dispatcher_ext"

module ActionHero

  class ActionNotFound < StandardError #:nodoc:
  end

  autoload :Action,         'action_hero/action'
  autoload :ActionResolver, 'action_hero/action_resolver'
  autoload :Configuration,  'action_hero/configuration'
  autoload :Controller,     'action_hero/controller'
  autoload :LogSubscriber,  'action_hero/log_subscriber'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield( configuration ) if block_given?
  end

end

ActionHero::LogSubscriber.attach_to :action_controller
