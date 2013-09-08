# ActionHero

Move actions from methods in Rails controllers to action classes.


## Motiviation

Simple Rails controllers implementing all of the REST actions get crowded enough with at least seven methods.  Add any
helper methods, etc and things get much worse.  In addition, the spec file is even more crowded.  All of these concerns
jammed into a single class provide many opportunities for bugs.  Why should you risk breaking your already implemented and
tested index action just because you are adding a show action?

Finally, controller specs are painfully slow.  When ActionHero is used to implement your actions as classes you can achieve
full coverage without writing a single controller spec.


## Installation

Add this line to your application's Gemfile:

    gem 'action-hero'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action-hero


## Usage

### Simplest Case

Include the ActionHero::Controller module in a controller.

    # app/controllers/things_controller.rb
    class ThingsController < ApplicationController
      include ActionHero::Controller
    end

Define the action class.

    # app/actions/things/index.rb
    module Things
      class Index
        include ActionHero::Action

        def call
          expose :things, Thing.all
          respond_with @things
        end

      end
    end

Use the exposed object in the view.

    <%= things.each do |thing| %>
      ...
    <% end %>

### Exposure

Unlike controller instance variables, the instance variables set in the action class will not automatically be available 
in the view.  This is just as well, as blindly making all instance variables in the controller available to the view is
arguably a bad idea.  In order to solve this problem, ActionHero provides the #expose method.  

The expose method does the following:

* Sets an instance variable in the action class with the same name as provided in the first argument to expose
* Returns the value passed in the second parameter so that you can set a local variable 
* Stores the value in a data store held on the controller
* Implements a helper method on the controller to access the exposed value
* Makes the helper method available in the view

Example of usage:

    # in the action class
    count = expose( :count, 1 ) 
    count  # => 1
    @count # => 1

    #in the controller
    count  # => 1
    @count # => nil

    #in the view
    count  # => 1
    @count # => nil


### Implicit Controller

Because controller actions can now be defined outside of the controller, defining the controller is optional.  If you
do not expcitily define a controller, ActionHero will fall back to the ImplicitController.

Ensure an implicit controller is defined.  Without configuration, the implicit controller defaults to ImplicitController.

    # app/controllers/implicit_controller.rb
    class ImplicitController < ApplicationController
      include ActionHero::Controller
    end


### Define Several Implicit Controllers and Configure Usage

In the case you want several implicit controllers due to different use cases, such as web app controller vs API you can
define several implicit controllers and configure the usage.

Define the implicit controllers.

    # app/controllers/implicit_controller.rb
    class ImplicitController < ApplicationController
      include ActionHero::Controller
    end

    # app/controllers/api/v1/implicit_controller.rb
    class Api::V1::ImplicitController < ApplicationController
      include ActionHero::Controller
    end

Configure the usage.  The configuration uses regexs to match against the #controller_name and will use the first one 
matched, so order matters.

    # config/initializers/action_hero.rb
    ActionHero.configure do |config|
      config.implicit_controllers = [
        [/^\/api\/.*/, Api::ImplicitController],
        [/^\/.*/, ImplicitController]
      ]
    end

### Mix and Match

You can mix and match usage of ActionHero action classes and standard Rails controller action methods.

In order to unobtrusively tie in to the controller, ActionHero::Controller implements the #action_missing 
method.  Thus, if you implement both an aciton class and an action method, the action method will win.

Define a controller with a show action method and define an action class for the index action.

    # app/controllers/things_controller.rb
    class ThingsController < ApplicationController
      include ActionHero::Controller

      def show
        ...
      end
    end

    # app/actions/things/index.rb
    module Things
      class Index
        include ActionHero::Action

        def call
          ...
        end
      end
    end

### Controller Methods Available in Action Class

The following methods forward from the the action class to the controller.

* action_name
* env
* flash
* formats
* head
* headers
* params
* redirect_to
* render
* render_to_string
* request
* reset_session
* respond_with
* response
* session
* url_for
* url_options

### Logging And Implicit Controllers

When an implicit controller is used ActionHero adds a line to the normal Rails request logging in order
to clarify that the implicit controller is being used in place of an explicit controller, giving the
correct information of what th eexplicit controller would be inorder to clarify what is going on and 
aid in debugging, etc.

    Started GET "/" for 127.0.0.1 at 2013-09-08 12:38:26 -0500                                                                                                    │
      [Action Hero] No explicit DashboardController defined, using ImplicitController
      Processing by ImplicitController#show as HTML
