require "bundler/setup"
require "wechat_authorize"
require "redis"
require "redis-namespace"


# If you want test, change your weixin test profile
ENV["APPID"]="wx986f04063d341d04"
ENV["APPSECRET"]="1a941cd88cb4579ba98ec06b6813af03"
ENV["OPENID"]="o9k6BuB0kydAcPTc7sPxppB1GQqA"
ENV["TEMPLATE_ID"]="-8ooXrOK3VD3HuSS8--nH154PO9Lw2E7T-RV1uTaGLc"

# Comment to test for ClientStorage
redis = Redis.new(host: "127.0.0.1", port: "6379", db: 15)

namespace = "wechat_test:wechat_authorize"

# cleanup keys in the current namespace when restart server everytime.
exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

redis_with_ns = Redis::Namespace.new("#{namespace}", :redis => redis)

WechatAuthorize.configure do |config|
  config.redis = redis_with_ns
  # config.key_expired = 200
  config.rest_client_options = {timeout: 10, open_timeout: 10, verify_ssl: true}
end

$client = WechatAuthorize::Client.new(ENV["APPID"], ENV["APPSECRET"])

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
