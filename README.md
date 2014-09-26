[![Gem Version](https://badge.fury.io/rb/cctv.png)](http://badge.fury.io/rb/cctv)
# CCTV

__An ultra-performant, DynamoDB-backed activity tracker__

CCTV is a simple activity tracker designed for high throughput activity monitoring applications. It persists activity information to DynamoDB, the infinitely scalable, highly performant NoSQL database service offered by Amazon Web Services (AWS).

## Data Model
CCTV uses an Actor-Activity-Target data model. Each type of activity is persisted to a separate table within DynamoDB. The "Actor" is a string that uniquely identifies the resource performing the activity. The "Target" is a string that uniquely identifies the recipient or affected resource of the activity. A current UTC epoch timestamp is included with each activity for temporal filtering.

DynamoDB is schemaless database, which means you can also store any additional information you would like within each activity record.

### Example Data Model
We want to keeps tabs on website pageviews within our online store.

Bob is a user logged into our application viewing the product page "/store/products/organic-goji-berries". We could record the following pageview activity.

Within table "**store-pageviews**":

- **Actor: Bob**
- **Target: /store/products/organic-goji-berries**
- **Timestamp: 1411702475**
- Customer Status: VIP
- Referred By: AdWords
- Browser: Chrome

## DynamoDB Setup
You have to do things...which I will describe here later.

## Example
```ruby
require 'cctv'

pageview_tracker = Cctv::Tracker.new(
  'my-app-pageviews',
  access_key_id:     'your-aws-access-key-id',
  secret_access_key: 'your-aws-secret-access-key',
  region:            'your-aws-region'
)

pageview_tracker.record_activity('bob', '/store')

pageview_tracker.view_activity('/store', Date.beginning_of_month..Date.today)
```

## Installation
You know the drill. Add the gem to your Gemfile:

```ruby
gem 'cctv'
```

Or install via the command line:

```sh
gem install cctv
```
