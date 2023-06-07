# AWS IVS Client

This is a Crystal client for interacting with AWS [Interactive Video Service](https://aws.amazon.com/ivs/).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     aws-ivs-client:
       github: joysticktv/aws-ivs-client
   ```

2. Run `shards install`

## Usage

```crystal
require "aws-ivs-client"

AWS::IVS::Client.configure do |settings|
  settings.aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
  settings.aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
  settings.aws_region = ENV["AWS_REGION"]
end

client = AWS::IVS::Client.new

response = client.create_channel("mystreamname")
# This is the stream key used to go live!
response["streamKey"]["value"].as_s
```

## Development

* write code
* write spec
* `crystal tool format spec/ src/`
* `./bin/ameba`
* `crystal spec`
* repeat


## Contributing

1. Fork it (<https://github.com/joysticktv/aws-ivs-client/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [JoystickTV](https://github.com/joysticktv) - creator and maintainer
