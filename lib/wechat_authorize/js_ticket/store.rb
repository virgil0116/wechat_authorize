# encoding: utf-8
module WechatAuthorize
  module JsTicket
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

      def jsticket_expired?
        raise NotImplementedError, "Subclasses must implement a jsticket_expired? method"
      end

      def refresh_jsticket
        set_jsticket
      end

      def jsticket
        refresh_jsticket if jsticket_expired?
      end

      def set_jsticket
        result = client.http_get("/ticket/getticket", {type: 1}).result
        client.jsticket = result["ticket"]
        client.jsticket_expired_at = WechatAuthorize.calculate_expire(result["expires_in"])
      end

    end
  end
end
