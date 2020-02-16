# encoding: utf-8
module WechatAuthorize
  module ApiTicket
    class Store

      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def self.init_with(client)
        if WechatAuthorize.weixin_redis.nil?
          ObjectStore.new(client)
        else
          RedisStore.new(client)
        end
      end

      def apiticket_expired?
        raise NotImplementedError, "Subclasses must implement a apiticket_expired? method"
      end

      def refresh_apiticket
        set_apiticket
      end

      def apiticket
        refresh_apiticket if apiticket_expired?
      end

      def set_apiticket
        result = client.http_get("/ticket/getticket", {type: 'wx_card'}).result
        client.apiticket = result["ticket"]
        client.apiticket_expired_at = result["expires_in"] + Time.now.to_i
      end

    end
  end
end
