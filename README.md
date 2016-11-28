# Kyklos

You can use the Amazon CloudWatch Events to schedule jobs on Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kyklos'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install kyklos
```

## Usage

### 1. Write your config/schedule.rb

```sh
$ vi config/schedule.rb
```

#### Example schedule.rb file

```ruby
cron '0/10 * * * ? *' do
  Entry.publish_all
  Entry.unpublish_all
end

rate '10 minutes' do
  Temporary.destroy_all
end

rate '1 day', as: :recontraction do
  Subscription.recontract_all
end

rate '1 day', as: :journalize_events do
  Event.journalize
end
```

### 2. Deploy

```sh
 bundle exec ruby bin/kyklos -c config/schedule.rb --adapter shoryuken --adapter_args=https://sqs.ap-northeast-1.amazonaws.com/accountid/queue_name
```

#### AWS認証情報について

##### 環境変数として渡す

```sh
$ AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx \
> AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
> AWS_REGION=ap-northeast-1 \
> kyklos -c config/schedule.rb
```

##### `aws configure`を使う

```sh
$ aws configure
AWS Access Key ID [None]: xxxxxxxxxxxxxxxxxxxx
AWS Secret Access Key [None]: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Default region name [None]: ap-northeast-1
Default output format [None]: json
$ ls ~/.aws
config  credentials
$ kyklos -c config/schedule.rb
```

### 3. Shoryuken

#### 設定

```sh
$ vi kyklos_worker.rb
```
```ruby
require 'kyklos'
Kyklos::Adapters::ShoryukenAdapter::Worker.config_path = 'config/schedule.rb'
Shoryuken.register_worker 'queue_name', Kyklos::Adapters::ShoryukenAdapter::Worker
```

```sh
$ vi shoryuken.yml
```
```yaml
concurrency: 25
delay: 25
queues:
     - [queue_name, 1]
```

#### ワーカーを開始

```sh
$ bundle exec shoryuken -r ./kyklos_worker.rb -C shoryuken.yml
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takeyuweb/kyklos. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

