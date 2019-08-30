# SocialWeb

:warning: Development is in the **alpha** phase. Changes large and small are
expected. Feedback is very welcome.

Tools and apps for participating in the [Social Web](https://www.w3.org/2005/Incubator/socialweb/XGR-socialweb-20101206/).

SocialWeb provides routing and persistance for handling 
[ActivityPub](https://www.w3.org/TR/2018/REC-activitypub-20180123/)-compliant
requests. You can mount SocialWeb as middleware to federate an existing Rack app.

* [Setup](#setup)

## Setup

### 1. Install

```ruby
gem install 'social_web'
```

### 2. Mount

#### Rails

```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount SocialWeb, at: '/'
end
```

#### Any Rack app

##### As middleware

```ruby
# config.ru

use SocialWeb
run MyApp
```

##### As an app
```ruby
# config.ru

run SocialWeb
```

### 3. Migrate

SocialWeb uses [Sequel](https://github.com/jeremyevans/sequel/) as a database
toolkit, which supports PostgreSQL, MySQL, and other databases.

```ruby
SocialWeb.configure do |config|
  config.database_url = 'postgresq://example.com/my_db'
end
```

```ruby
rake social_web:db:migrate
```

### 4. Configure

```ruby
SocialWeb.configure do |config|
  config.database_url = 'sqlite://example.sqlite3'
  config.domain = 'example.com'
  config.public_key = ENV['PUBLIC_KEY']
  config.private_key = ENV['PRIVATE_KEY']
  config.webfinger_resource = {
    'subject': 'acct:me@example.com',
      'links': [
        {
          'rel': 'self',
          'type': 'application/activity+json',
          'href': 'https://example.com'
        }
      ]
    }
end
```
