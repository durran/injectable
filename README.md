Injectable [![Build Status](https://secure.travis-ci.org/durran/injectable.png?branch=master&.png)](http://travis-ci.org/durran/injectable) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/durran/injectable)
========

Injectable is an extremely simple dependency injection framework for Ruby. It's
stupid simple and experimental so don't expect support for now - but may turn out
to be something in the future.

Usage
-----

Say we have a `UserService` that has some basic logic for performing operations
related to a `User` and a `FacebookService`. We can tell the `UserService` what
its dependencies are via `Injectable`. Note that as of `0.0.2` all objects that
can be injected into others must include the `Injectable` module.

```ruby
class User
  include Injectable
end

class FacebookService
  include Injectable
end

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
user_service = container.get(:user_service)
```

Since `User` and `FacebookService` take no arguments, we don't even need to
pass them into the container - it will automatically instantiate new ones:

```ruby
container = Injectable::Container.new
user = container.get(:user)
user_service = container.get(:user_service)
```

Injectable also supports depending on roles rather than concrete classes by
allowing the registration of classes whose instances perform that role. An
implementation can be registered on a single container itself as a "one off":

```ruby
container = Injectable::Container.new
container.register_implementation(:facebook_service, DifferentFacebookService)
user_service = container.get(:user_service)
# `user_service`'s facebook_service will be an instance of DifferentFacebookService
```

You can also define concrete implementations at the global level via `configure`:

```ruby
Injectable.configure do |config|
  config.register_implementation(:facebook_service, DifferentFacebookService)
end

container = Injectable::Container.new
user_service = container.get(:user_service)
# `user_service`'s facebook_service will be an instance of DifferentFacebookService
```

Setter injection is not supported.

How about the real world
------------------------

Let's look at the above classes, but say we're in a Rails application:

```ruby
class User < ActiveRecord::Base
  include Injectable
end

class FacebookService
  include Injectable

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
    container.get(:user_service).post_to_wall(params[:message])
    respond_with container.get(:user)
  end

  private

  def container
    @container ||= Injectable::Container.new(User.find(params[:id]))
  end
end
```

Copyright (c) 2012 Durran Jordan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
