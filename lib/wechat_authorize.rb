require "rest-client"
require "json"

require "wechat_authorize/config"
require "wechat_authorize/handler"
require "wechat_authorize/api"
require "wechat_authorize/version"
require "wechat_authorize/client"

module WechatAuthorize
  class Error < StandardError; end
  #
  # token store
  module Token
    autoload(:Store,       "wechat_authorize/token/store")
    autoload(:ObjectStore, "wechat_authorize/token/object_store")
    autoload(:RedisStore,  "wechat_authorize/token/redis_store")
  end

  OK_MSG  = "ok".freeze
  OK_CODE = 0.freeze
  GRANT_TYPE = "client_credential".freeze
  # 用于标记endpoint可以直接使用url作为完整请求API
  CUSTOM_ENDPOINT = "custom_endpoint".freeze




  class << self

    def http_get_without_token(url, url_params={}, endpoint="plain")
      get_api_url = endpoint_url(endpoint, url)
      load_json(resource(get_api_url).get(params: url_params))
    end

    def http_post_without_token(url, post_body={}, url_params={}, endpoint="plain")
      post_api_url = endpoint_url(endpoint, url)
      # to json if invoke "plain"
      if endpoint == "plain" || endpoint == "api" || endpoint == CUSTOM_ENDPOINT
        post_body = JSON.dump(post_body)
      end
      load_json(resource(post_api_url).post(post_body, params: url_params))
    end

    def resource(url)
      RestClient::Resource.new(url, rest_client_options)
    end

    # return hash
    def load_json(string)
      result_hash = JSON.parse(string.force_encoding("UTF-8").gsub(/[\u0011-\u001F]/, ""))
      code   = result_hash.delete("errcode")
      en_msg = result_hash.delete("errmsg")
      puts "==============================================#{result_hash}"
      ResultHandler.new(code, en_msg, result_hash)
    end

    def endpoint_url(endpoint, url)
      # 此处为了应对第三方开发者如果自助对接接口时，URL不规范的情况下，可以直接使用URL当为endpoint
      return url if endpoint == CUSTOM_ENDPOINT
      send("#{endpoint}_endpoint") + url
    end

    def plain_endpoint
      "#{api_endpoint}/cgi-bin"
    end

    def api_endpoint
      "https://api.weixin.qq.com"
    end

    def file_endpoint
      "http://file.api.weixin.qq.com/cgi-bin"
    end

    def mp_endpoint(url)
      "https://mp.weixin.qq.com/cgi-bin#{url}"
    end

    def open_endpoint(url)
      "https://open.weixin.qq.com#{url}"
    end

    def check_required_options(options, names, module_name='Weixin Authorize')
      missinglsit = []
      names.each do |name|
        missinglsit << name if options.nil? || !options.has_key?(name) || options[name].nil? || (!options[name].is_a?(Integer) && options[name].empty?)
      end
    end

    def calculate_expire(expires_in)
      Time.now.to_i + expires_in.to_i - key_expired.to_i
    end

  end
end
