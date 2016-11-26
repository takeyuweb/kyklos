# Kyklos

AWS Lambda + Amazon CloudWatch Events meets Ruby

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
run `kyklos -c config/schedule.rb` --function_adapter=shoryuken --function_adapter_args=queue_name
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

#### A

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takeyuweb/kyklos. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

