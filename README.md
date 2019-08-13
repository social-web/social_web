# SocialWeb

A suite of apps and tools for participating in the Social Web. You can [mount](#setup)
SocialWeb to federate an existing app.

* [**ActivityPub**](https://github.com/social-web/activity_pub): Endpoints for the [ActivityPub](https://activitypub.rocks/) protocol
* [**ActivityStreams**](https://github.com/social-web/activity_streams): Models for [ActivityStreams](https://www.w3.org/TR/activitystreams-core/) objects
* [**Webmention**](https://github.com/social-web/webmention): Endpoint for the [Webmentions](https://webmention.net/) protocol
* [**WellKnown**](https://github.com/social-web/well_known): Endpoints for [Well-Known URIs](https://tools.ietf.org/html/rfc5785)

## Table of Contents

* [Setup](#setup)
  * [Install](#1-install)
  * [Configure](#2-configure)
  * [Mount](#3-mount)
    * [Rails](#rails)
    * [Roda](#roda)
    * [Any rack app](#any-rack-app)

## Setup

Given an existing app compatible with [Rack](https://rack.github.io/):

### 1. Install

```ruby
# Gemfile

source 'https://rubygems.org'

gem 'social_web'
```

### 2. Configure

```ruby
SocialWeb.configure do |config|
    config.webfinger_resource = {}
end
```

### 3. Mount

#### Rails

```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount SocialWeb, at: '/'
end
```

#### Roda

```ruby

require 'social_web'

class MyApp < Roda
  use SocialWeb
end
```

#### Any Rack app

```ruby
# config.ru

use SocialWeb::Routes
run MyApp
```

## Configuration

```ruby
SocialWeb.configure do |config|
  config.activity_pub = true
  config.activity_streams = true
  config.webmention = false
  config.well_known.webfinger_resource = {
      subject: 'acct:beep@boop.com',
      ...
    }
end
```

Check the docs for the relevant library's configuration.

| Namespace          | Configuration
| ------------------ |---------------------------------------------------------------------
| `activity_pub`     | [docs](https://github.com/social-web/activity_pub#configuration)
| `activity_streams` | [docs](https://github.com/social-web/activity_streams#configuration)
| `webmention`       | [docs](https://github.com/social-web/webmention#configuration)
| `well_known`       | [docs](https://github.com/social-web/well_known#configuration)

## Hooks

SocialWeb is extensible via hooks. Register a hook with a callable object to
react to events handled by SocialWeb.

```ruby
SocialWeb::Hooks.register('activity_pub.inbox.after_post') do |activity, response|
  MyApp::ProcessActivity.perform_later(activity) if response.ok?
end
```

### Available hooks

| Name                             | Arguments
| -------------------------------- |---------------
| activity_pub.inbox.before_post   | `Rack::Request`
| activity_pub.inbox.after_post    | `ActivityStreams::Object`, `Rack::Response`
| well_known.webfinger.before_get  | `Rack::Request`
| well_known.webfinger.after_get   | `Rack::Response`
