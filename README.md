Injectable [![Build Status](https://secure.travis-ci.org/durran/injectable.png?branch=master&.png)](http://travis-ci.org/durran/injectable) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/durran/injectable)
========

Injectable is an extremely simple dependency injection framework for Ruby.

Usage
-----

Say we have a `UserService` that has some basic logic for performing operations
related to a `User` and a `FacebookService`. We can tell the `UserService` what
its dependencies are via `Injectable`:

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
user_service = container.get(UserService)
```

Since `User` and `FacebookService` take no arguments, we don't even need to
pass them into the container:

```ruby
container = Injectable::Container.new
user_service = container.get(UserService)
```

Polymorphism is not supported since we don't have interfaces in Ruby. Setter
injection is also not supported.
