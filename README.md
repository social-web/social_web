# SocialWeb

A suite of apps and tools for participating in the Social Web. You can [mount](#setup)
SocialWeb to an existing app, then [hook](#hooks) into the request-response 
cycle to translate your domain-specific data models (your posts, links, videos,
etc. ) into a format accessible to the [federated web](https://fediverse.party/).

* [**ActivityPub**](https://github.com/social-web/social_web/tree/master/activity_pub): Endpoints for the [ActivityPub](https://activitypub.rocks/) protocol
* [**ActivityStreams**](https://github.com/social-web/social_web/tree/master/activity_streams): Models for [ActivityStreams](https://www.w3.org/TR/activitystreams-core/) objects
* [**Webmention**](https://github.com/social-web/social_web/tree/master/webmention): Endpoint for the [Webmentions](https://webmention.net/) protocol
* [**WellKnown**](https://github.com/social-web/social_web/tree/master/well_known): Endpoints for [Well-Known URIs](https://tools.ietf.org/html/rfc5785)

## Table of Contents

* [Setup](#setup)
  * [Install](#1-install)
  * [Configure](#2-configure)
  * [Rack up](#3-rack-up)
    * [Rails](#rails)
    * [Roda](#roda)
    * [Any rack app](#any-rack-app)
* [Configuration](#configuration)
* [Hooks](#hooks)

## Setup

Given an existing app compatible with [Rack](https://rack.github.io/):

### 1. Install

```ruby
# Gemfile

source 'https://rubygems.org'

gem 'social_web'
```

### 2. Configure

See [Configuration](#configuration) for more.

```ruby
SocialWeb.configure do |config|
    config.webfinger_resource = {}
    ...
end
```

### 3. Rack up

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



## Hooks

SocialWeb is extensible via hooks. Register a hook with a callable object to
react to events handled by SocialWeb.

A hook yields an `event` object, with parameters accessible via square brackets.

Some hooks expect a specific data structure to be returned. For example, the
`activity_pub.inbox.get.before` expects an array of Activity Streams-compatible
objects to 

```ruby
SocialWeb.add_hook('activity_pub.inbox.post.after') do |event|
  activity = event[:activity]
  response = event[:response]
  request = event[:request] 
  MyApp::ProcessActivity.perform_later(activity) if response.ok?
end
```

### Available hooks

| Name                             | Event paramaters                                                                            | Expected return value
| -------------------------------- | ------------------------------------------------------------------------------------------- | --------------------------------------------
| activity_pub.inbox.get.before    | **`request`:** `Rack::Request`                                                                                          | Array of `ActivityStreams::Object`s or JSON
| activity_pub.inbox.get.after     | **`response:`** `Rack::Response` <br/> **`request`:** `Rack::Request`                                                   | *n/a*
| activity_pub.inbox.post.before   | **`request`:** `Rack::Request`                                                                                          | *n/a*
| activity_pub.inbox.post.after    | **`activity`:** `ActivityStreams::Object` <br/> **`response`:** `Rack::Response` <br/> **`request`:** `Rack::Request`   | *n/a*
| well_known.webfinger.get.before  | **`request`:** `Rack::Request`                                                                                          | *n/a*
| well_known.webfinger.get.after   | **`response`:** `Rack::Response` <br/> **`request`:** `Rack::Request`                                                   | *n/a*
