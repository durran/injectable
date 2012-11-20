Injectable [![Build Status](https://secure.travis-ci.org/durran/injectable.png?branch=master&.png)](http://travis-ci.org/durran/injectable) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/durran/injectable)
========

Injectable is an extremely simple dependency injection framework for Ruby. It's
stupid simple and experimental so don't expect support for now - but may turn out
to be something in the future.

Usage
-----

Say we have a `UserService` that has some basic logic for performing operations
related to a `User` and a `FacebookService`. We can tell the `UserService` what
its dependencies are via `Injectable` (Objects that have no dependencies do not)
need to include the module.

```ruby
class User; end
class FacebookService; end

class UserService
  include Injectable
  dependencies :user, :facebook_service
end
```

The `UserService` would then get a constructor defined that takes a `User` and
`FacebookService` as its arguments:

```ruby
user = User.new
facebook_service = FacebookService.new
user_service = UserService.new(user, facebook_service)
```

Reader methods are also automatically provided for each dependency:

```ruby
user_service.user
user_service.facebook_service
```

Say we just want to throw a bunch of objects in a container, and ask for an
object of a specific type and let the container figure out the dependencies:

```ruby
user = User.new
facebook_service = FacebookService.new
container = Injectable::Container.new(user, facebook_service)
user_service = container.get(UserService)
```

Since `User` and `FacebookService` take no arguments, we don't even need to
pass them into the container - it will automatically instantiate new ones:

```ruby
container = Injectable::Container.new
user = container.get(User)
user_service = container.get(UserService)
```

Polymorphism is not supported since we don't have interfaces in Ruby. Setter
injection is also not supported.

How about the real world
------------------------

Let's look at the above classes, but say we're in a Rails application:

```ruby
class User < ActiveRecord::Base
end

class FacebookService
  def post_to_wall(id, message)
    # ...
  end
end

class UserService
  include Injectable
  dependencies :user, :facebook_service

  def post_to_wall(message)
    facebook_service.post_to_wall(user.id, message)
  end
end
```

Now in our controller, we can just create a new container the user we find
and then ask the container to do all the other work. This is more closely
related to what one might do in a real application.

```ruby
class UsersController < ApplicationController

  def post_to_wall
    container.get(UserService).post_to_wall(params[:message])
    respond_with container.get(User)
  end

  private

  def container
    @container ||= Injectable::Container.new(User.find(params[:id]))
  end
end
```
