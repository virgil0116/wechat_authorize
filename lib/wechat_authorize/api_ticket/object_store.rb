module WechatAuthorize
  module ApiTicket
    class ObjectStore < Store

      def apiticket_expired?
        # 如果当前token过期时间小于现在的时间，则重新获取一次
        client.apiticket_expired_at <= Time.now.to_i
      end

      def apiticket
        super
        client.apiticket
      end

      def refresh_apiticket
        super
      end

    end
  end
end
