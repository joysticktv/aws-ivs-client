require "awscr-signer"
require "habitat"
require "http/client"

module AWS::IVS
  VERSION = "0.1.0"

  class Client
    Habitat.create do
      setting aws_access_key_id : String, example: "L1/3aqp"
      setting aws_secret_access_key : String, example: "ABC123"
      setting aws_region : String, example: "us-east-1"
    end

    def self.client(&)
      client = HTTP::Client.new("ivs.#{Client.settings.aws_region}.amazonaws.com", tls: true)

      client.before_request do |request|
        request.headers["Content-Type"] = "application/json"

        signer = Awscr::Signer::Signers::V4.new("ivs", Client.settings.aws_region, Client.settings.aws_access_key_id, Client.settings.aws_secret_access_key)
        signer.sign(request)
      end

      yield client
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_ListChannels.html
    def list_channels(name : String) : JSON::Any
      self.class.client do |client|
        body = client.post("/ListChannels", body: {
          "filterByName" => name,
        }.to_json).body

        JSON.parse(body)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_ListStreamKeys.html
    def list_stream_keys(channel_arn : String) : JSON::Any
      self.class.client do |client|
        body = client.post("/ListStreamKeys", body: {
          "channelArn" => channel_arn,
        }.to_json).body

        JSON.parse(body)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_GetChannel.html
    def get_channel(channel_arn : String) : JSON::Any
      self.class.client do |client|
        body = client.post("/GetChannel", body: {
          "arn" => channel_arn,
        }.to_json).body

        JSON.parse(body)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_GetStreamKey.html
    def get_stream_key(channel_arn : String) : JSON::Any
      self.class.client do |client|
        body = client.post("/GetStreamKey", body: {
          "arn" => channel_arn,
        }.to_json).body

        JSON.parse(body)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_GetStream.html
    def get_stream(channel_arn : String) : JSON::Any
      self.class.client do |client|
        body = client.post("/GetStream", body: {
          "channelArn" => channel_arn,
        }.to_json).body

        JSON.parse(body)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_CreateChannel.html
    def create_channel(name : String, tags : Hash(String, String) = {} of String => String) : JSON::Any
      self.class.client do |client|
        body = client.post("/CreateChannel", body: {
          "authorized"  => false,
          "name"        => name,
          "latencyMode" => "LOW",
          "type"        => "STANDARD",
          "tags"        => tags,
        }.to_json).body

        JSON.parse(body)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_CreateStreamKey.html
    def create_stream_key(channel_arn : String, tags : Hash(String, String) = {} of String => String) : JSON::Any
      self.class.client do |client|
        body = client.post("/CreateStreamKey", body: {
          "channelArn" => channel_arn,
          "tags"       => tags,
        }.to_json).body

        JSON.parse(body)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_DeleteStreamKey.html
    def delete_stream_key(stream_key_arn : String) : Nil
      self.class.client do |client|
        client.post("/DeleteStreamKey", body: {
          "arn" => stream_key_arn,
        }.to_json)
      end
    end

    # https://docs.aws.amazon.com/ivs/latest/APIReference/API_StopStream.html
    def stop_stream(channel_arn : String) : Nil
      self.class.client do |client|
        client.post("/StopStream", body: {
          "channelArn" => channel_arn,
        }.to_json)
      end
    end
  end
end
