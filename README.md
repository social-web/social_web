# SocialWeb

1. [Setup](#setup)

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
