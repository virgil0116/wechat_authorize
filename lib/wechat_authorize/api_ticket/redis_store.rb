module WechatAuthorize
  module ApiTicket
    class RedisStore < Store
      APITICKET = "apiticket"
      EXPIRED_AT = "expired_at"

      def apiticket_expired?
        weixin_redis.hvals(client.apiticket_redis_key).empty?
      end

      def refresh_apiticket
        super
        weixin_redis.hmset(
            client.apiticket_redis_key,
            APITICKET,
            client.apiticket,
            EXPIRED_AT,
            client.apiticket_expired_at
        )
        weixin_redis.expireat(
            client.apiticket_redis_key,
            client.apiticket_expired_at.to_i
        )
      end

      def apiticket
        super
        client.apiticket = weixin_redis.hget(client.apiticket_redis_key, APITICKET)
        client.apiticket_expired_at = weixin_redis.hget(
            client.apiticket_redis_key,
            EXPIRED_AT
        )
        client.apiticket
      end

      def weixin_redis
        WechatAuthorize.weixin_redis
      end
    end
  end
end
