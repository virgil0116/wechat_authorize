# encoding: utf-8
require "monitor"
require "redis"
require 'digest/md5'
module WechatAuthorize

  class Client

    include MonitorMixin

    include Api::Poi
    include Api::Card

    include Api::User
    include Api::Menu
    include Api::Custom
    include Api::Groups
    include Api::Qrcode
    include Api::Media
    include Api::Mass
    include Api::Oauth
    include Api::Template

    attr_accessor :app_id, :app_secret, :expired_at # Time.now + expires_in
    attr_accessor :access_token, :redis_key, :custom_access_token
    attr_accessor :jsticket, :jsticket_expired_at, :jsticket_redis_key
    attr_accessor :apiticket, :apiticket_expired_at, :apiticket_redis_key

    # options: redis_key, custom_access_token
    def initialize(app_id, app_secret, options={})
      @app_id = app_id
      @app_secret = app_secret
      @jsticket_expired_at = @expired_at = Time.now.to_i
      @redis_key = security_redis_key(options[:redis_key] || "weixin_#{app_id}")
      @jsticket_redis_key = security_redis_key("js_sdk_#{app_id}")

      @apiticket_expired_at = @expired_at = Time.now.to_i

      @custom_access_token = options[:custom_access_token]
      super() # Monitor#initialize
    end

    # return token
    def get_access_token
      return custom_access_token if !custom_access_token.nil?
      synchronize{ token_store.access_token }
    end

    # 检查appid和app_secret是否有效。
    def is_valid?
      return true if !custom_access_token.nil?
      token_store.valid?
    end

    def token_store
      Token::Store.init_with(self)
    end

    def jsticket_store
      JsTicket::Store.init_with(self)
    end

    def get_jsticket
      jsticket_store.jsticket
    end

    def apiticket_store
      ApiTicket::Store.init_with(self)
    end

    def get_apiticket
      apiticket_store.apiticket
    end

    # 获取js sdk 签名包
    def get_jssign_package(url)
      timestamp = Time.now.to_i
      noncestr = SecureRandom.hex(16)
      str = "jsapi_ticket=#{get_jsticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}";
      signature = Digest::SHA1.hexdigest(str)
      {
          "appId"     => app_id,    "nonceStr"  => noncestr,
          "timestamp" => timestamp, "url"       => url,
          "signature" => signature, "rawString" => str
      }
    end

    # 暴露出：http_get,http_post两个方法，方便第三方开发者扩展未开发的微信API。
    def http_get(url, url_params={}, endpoint="plain")
      url_params = url_params.merge(access_token_param)
      WechatAuthorize.http_get_without_token(url, url_params, endpoint)
    end

    def http_post(url, post_body={}, url_params={}, endpoint="plain")
      url_params = access_token_param.merge(url_params)
      WechatAuthorize.http_post_without_token(url, post_body, url_params, endpoint)
    end

    private

    def access_token_param
      {access_token: get_access_token}
    end

    def security_redis_key(key)
      Digest::MD5.hexdigest(key.to_s).upcase
    end

  end
end
