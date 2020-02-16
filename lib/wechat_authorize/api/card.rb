# encoding: utf-8
# ===================
# 传入参数必须为 Symbol
# ===================
module WechatAuthorize
  # 考虑了一下由于 Client 本身会引入所有的API
  # 而 JsonHelper 不属于 API 部分
  # 所以还是把 JsonHelper 放在外层
  module CardJsonHelper
    MODULE_JSON_HELPER_NAME = 'CardJsonHelper(微信卡券接口助手)'
    class << self
      INVOKE_SKU_REQUIRED_FIELDS = %i(quantity)
      def sku(params)
        params = {
          quantity: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_SKU_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        params
      end

      INVOKE_DATEIINFO_REQUIRED_FIELDS = %i(type)
      def date_info(params)
        params = {
          type: '',
          begin_timestamp: nil,
          end_timestamp:   nil,
          fixed_term: nil,
          fixed_begin_term: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_DATEIINFO_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        params
      end

      INVOKE_BASEINFO_REQUIRED_FIELDS = %i(logo_url code_type brand_name title sub_title color notice description sku date_info)
      # 创建卡券base_info json
      def base_info(params)
        params = {
          # 必填参数
          logo_url: '',
          code_type: '',
          brand_name: '',
          title: '',
          sub_title: '',
          color: '',
          notice: '',
          description: '',
          sku: { quantity: nil },
          date_info: {
            type: '',
            begin_timestamp: nil,
            end_timestamp:  nil,
            fixed_term: nil,
            fixed_begin_term: nil
          },
          # 可选参数
          use_custom_code: nil,
          bind_openid: nil,
          service_phone: nil,
          location_id_list: nil,
          source: nil,
          custom_url_name: nil,
          custom_url: nil,
          custom_url_sub_title: nil,
          promotion_url_name: nil,
          promotion_url: nil,
          promotion_url_sub_title: nil,
          get_limit: nil,
          can_share: nil,
          can_give_friend: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_BASEINFO_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        params
      end
    end

    class MemberCard
      # 创建自定义会员信息类目json
      # 会员卡激活后显示。
      INVOKE_CUSTOMCELL_REQUIRED_FIELDS = %i(name_type tips url)
      def self.custom_cell(params)
        params = {
          name_type: '',
          tips: '',
          url: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_CUSTOMCELL_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        params
      end

      # 创建自定义会员信息类目json
      # 会员信息类目名称，取以下任一值：
      # name_type =
      # 等级	FIELD_NAME_TYPE_LEVEL
      # 印花	FIELD_NAME_TYPE_STAMP
      # 折扣	FIELD_NAME_TYPE_DISCOUNT
      # 成就	FIELD_NAME_TYPE_ACHIEVEMEN
      # 里程	FIELD_NAME_TYPE_MILEAGE
      # 优惠券	FIELD_NAME_TYPE_COUPON"
      INVOKE_CUSTONFIELD_REQUIRED_FIELDS = %i(name_type url)
      def self.custom_field(params)
        params = {
          name_type: '',
          url: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_CUSTONFIELD_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        params
      end

      INVOKE_BONUS_REQUIRED_FIELDS = %i(supply_bonus)
      def self.bonus(params)
        params = {
          supply_bonus: nil,
          bonus_url: nil,
          bonus_cleared: nil,
          bonus_rules: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_BONUS_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        params
      end

      INVOKE_BALANCE_REQUIRED_FIELDS = %i(supply_balance)
      def self.balance(params)
        {
          supply_balance: nil,
          balance_url: nil,
          balance_rules: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_BALANCE_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        params
      end

      INVOKE_MEMBERCARD_REQUIRED_FIELDS = %i(activate_url prerogative bonus balance)
      # 创建会员卡json
      def self.create(bash_info, params)
        params = {
          activate_url: '',
          prerogative: '',
          bonus: {
            supply_bonus: nil,
            bonus_url: nil,
            bonus_cleared: nil,
            bonus_rules: nil
          },
          balance: {
            supply_balance: nil,
            balance_url: nil,
            balance_rules: nil
          },
          custom_field: [],
          custom_cell:  []
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_MEMBERCARD_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'MEMBER_CARD',
            base_info: bash_info,
            activate_url: params[:activate_url],
            prerogative: params[:prerogative],
            supply_bonus: params[:bonus][:supply_bonus],
            bonus_url: params[:bonus][:bonus_url],
            bonus_cleared: params[:bonus][:bonus_cleared],
            bonus_rules: params[:bonus][:bonus_rules],
            supply_balance: params[:balance][:supply_balance],
            balance_url: params[:balance][:balance_url],
            balance_rules: params[:balance][:balance_rules],
            custom_field1: params[:custom_field[0]],
            custom_field2: params[:custom_field[1]],
            custom_field3: params[:custom_field[2]],
            custom_cell1: params[:custom_cell[0]]
          }
        }
      end
    end

    INVOKE_GROUPON_REQUIRED_FIELDS = %i(deal_detail)
    class Groupon
      # 创建团购券json
      def self.create(bash_info, params)
        params = {
          deal_detail: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_GROUPON_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'GROUPON',
            groupon: {
              base_info: bash_info
            },
            deal_detail: params[:deal_detail]
          }
        }
      end
    end

    INVOKE_CASH_REQUIRED_FIELDS = %i(least_cost reduce_cost)
    class Cash
      # 创建代金券json
      def self.create(bash_info, advanced_info, params)
        params = {
          least_cost: nil,
          reduce_cost: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_CASH_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'CASH',
            cash:{
              base_info: bash_info,
              advanced_info: advanced_info,
              least_cost: params[:least_cost],
              reduce_cost: params[:reduce_cost]
            }
          }
        }
      end

      def self.update(bash_info, params)
        params = {
          least_cost: nil,
          reduce_cost: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_CASH_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: '',
          cash:{
            base_info: bash_info,
            least_cost: params[:least_cost],
            reduce_cost: params[:reduce_cost]
          }
        }
      end
    end

    INVOKE_DISCOUNT_REQUIRED_FIELDS = %i(discount)
    class Discount
      # 创建折扣券json
      def self.create(bash_info, params)
        params = {
            discount: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_DISCOUNT_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'DISCOUNT',
            base_info: bash_info,
            discount: params[:discount]
          }
        }
      end
    end

    INVOKE_GIFT_REQUIRED_FIELDS = %i(gift)
    class Gift
      # 创建礼品券json
      def self.create(bash_info, params)
        params = {
            gift: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_GIFT_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'DISCOUNT',
            base_info: bash_info,
            gift: params[:gift]
          }
        }
      end
    end

    INVOKE_GENERALCOUPON_REQUIRED_FIELDS = %i(default_detail)
    class GeneralCoupon
      # 创建通用券json
      def self.create(bash_info, params)
        params = {
            default_detail: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_GENERALCOUPON_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'GENERAL_COUPON',
            base_info: bash_info,
            default_detail: params[:default_detail]
          }
        }
      end
    end

    INVOKE_MEETINGTICKET_REQUIRED_FIELDS = %i(meeting_detail)
    class MeetingTicket
      # 创建会议门票json
      def self.create(bash_info, params)
        params = {
            meeting_detail: '',
            map_url: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_MEETINGTICKET_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'MEETING_TICKET',
            base_info: bash_info,
            meeting_detail: params[:meeting_detail],
            map_url: params[:map_url]
          }
        }
      end
    end

    INVOKE_SCENICTICKET_REQUIRED_FIELDS = %i(ticket_class guide_url)
    class ScenicTicket
      # 创建景区门票json
      def self.create(bash_info, params)
        params = {
            ticket_class: '',
            guide_url: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_SCENICTICKET_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'SCENIC_TICKET',
            base_info: bash_info,
            ticket_class: params[:ticket_class],
            guide_url: params[:guide_url]
          }
        }
      end
    end

    INVOKE_BOARDPASS_REQUIRED_FIELDS = %i(from to flight air_model departure_time landing_time)
    class BoardingPass
      # 创建飞机票json
      def self.create(bash_info, params)
        params = {
          from: '',
          to: '',
          flight: '',
          gate: nil,
          check_in_url: nil,
          air_model: '',
          departure_time: '',
          landing_time: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_BOARDPASS_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
      {
        card: {
          card_type: 'BOARDING_PASS',
          base_info: bash_info,
          detail: params[:detail]
        }
      }
      end
    end

    INVOKE_MOVIETICKET_REQUIRED_FIELDS = %i(tickedetailt_class)
    class MovieTicket
      # 创建电影票json
      def self.create(bash_info, params)
        params = {
          tickedetailt_class: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_MOVIETICKET_REQUIRED_FIELDS, MODULE_JSON_HELPER_NAME)
        {
          card: {
            card_type: 'MOVIE_TICKET',
            base_info: bash_info,
            detail: params[:detail]
          }
        }
      end
    end
  end

  module Api
    MODULE_API_CARD_NAME = 'Card API(微信卡券接口)'
    module Card
      def card_ext(card_id='', code=nil, openid=nil)
        timestamp = Time.now.to_i
        nonce_str = SecureRandom.hex(16)
        apiticket = get_apiticket
        sort_params = [ apiticket, timestamp.to_s, card_id.to_s, code.to_s, openid.to_s, nonce_str ].sort.join
        signature = Digest::SHA1.hexdigest(sort_params)
        {
          code: code,
          openid: openid,
          timestamp: timestamp,
          nonce_str: nonce_str,
          signature: signature
        }
      end

      # 预览接口
      # https://api.weixin.qq.com/cgi-bin/message/mass/preview?access_token=ACCESS_TOKEN
      # touser = option { openid: openid, wxname: wxname }
      def card_send_preview(card_id='', towxname='', toopenid='')
        url = "/message/mass/preview"
        wxcard_body = {
          card_id: card_id,
          card_ext: card_ext
        }
        post_body = {
          msgtype: 'wxcard',
          touser: toopenid,
          towxname: towxname
        }.merge(wxcard_body)
        http_post(url, post_body)
      end

      # 获取卡券配色方案列表
      # https://api.weixin.qq.com/card/getcolors?access_token=TOKEN
      def card_colors
        url = "#{card_base_url}/getcolors"
        http_get(url, {} ,'api')
      end


      # 统计卡券数据 - 拉取会员卡数据接口
      # https://api.weixin.qq.com/datacube/getcardmembercardinfo?access_token=ACCESS_TOKEN
      def card_datacube_info_member_card(begin_date=0, end_date=0, cond_source=1)
        begin_date = datacube_datetime_format begin_date
        end_date = datacube_datetime_format end_date
        url = "#{datacube_base_url}/getcardmembercardinfo"
        post_body = {
          begin_date: begin_date,
          end_date: end_date,
          cond_source: cond_source
        }
        http_post(url, post_body, {}, 'api')
      end

      # 获取免费券数据接口
      # https://api.weixin.qq.com/datacube/getcardcardinfo?access_token=ACCESS_TOKEN
      def card_datacube_info(begin_date=0, end_date=0, cond_source=1, card_id=nil)
        begin_date = datacube_datetime_format begin_date
        end_date = datacube_datetime_format end_date
        url = "#{datacube_base_url}/getcardcardinfo"
        post_body = {
          begin_date: begin_date,
          end_date: end_date,
          cond_source: cond_source,
          card_id: card_id
        }
        http_post(url, post_body, {}, 'api')
      end

      # 拉取卡券概况数据接口
      # https://api.weixin.qq.com/datacube/getcardbizuininfo?access_token=ACCESS_TOKEN
      def card_datacube(begin_date=0, end_date=0, cond_source=1)
        begin_date = datacube_datetime_format begin_date
        end_date = datacube_datetime_format end_date
        url = "#{datacube_base_url}/getcardbizuininfo"
        post_body = {
          begin_date: begin_date,
          end_date: end_date,
          cond_source: cond_source
        }
        http_post(url, post_body, {}, 'api')
      end

      # 设置测试白名单
      # https://api.weixin.qq.com/card/testwhitelist/set?access_token=TOKEN
      def card_testwhitelist(wxusername=[], openid=[])
        url = "#{card_base_url}/testwhitelist/set"
        post_body = {
          openid: openid[0, 9], # 微信接口限制10个白名单用户，多余的抛弃
          username: wxusername[0,9] # 微信接口限制10个白名单用户，多余的抛弃
        }
        http_post(url, post_body, {}, 'api')
      end

      # 获取图文消息卡券HTML代码接口
      # https://api.weixin.qq.com/card/mpnews/gethtml?access_token=TOKEN
      def card_mpnews_html(card_id=nil)
        url = "#{card_base_url}/mpnews/gethtml"
        post_body = {
          card_id: card_id
        }
        http_post(url, post_body, {}, 'api')
      end

      # 核查code接口
      # http://api.weixin.qq.com/card/code/checkcode?access_token=ACCESS_TOKEN
      def card_code_check(card_id='', codelist=[])
        url = "#{card_base_url}/code/checkcode"
        post_body = {
          card_id: card_id,
          code: codelist
        }
        http_post(url, post_body, {}, 'api')
      end

      # 导入code接口
      # http://api.weixin.qq.com/card/code/deposit?access_token=ACCESS_TOKEN
      # codelist = ['11111', '22222', '33333']
      def card_code_deposit(card_id='', codelist=[])
        url = "#{card_base_url}/code/deposit"
        post_body = {
          card_id: card_id,
          code: codelist
        }
        http_post(url, post_body, {}, 'api')
      end

      # 创建货架接口
      # https://api.weixin.qq.com/card/landingpage/create?access_token=$TOKEN
      #
      # 场景值 scene
      # SCENE_NEAR_BY 附近
      # SCENE_SCAN	扫一扫
      # SCENE_SHAKE_TV	摇电视
      # SCENE_WIFI 微信wifi
      # SCENE_IBEACON	iBeacon
      # SCENE_PAY	微信支付
      # SCENE_MENU	自定义菜单
      # SCENE_MONENTS_AD 朋友圈广告
      # SCENE_QRCODE	二维码
      # SCENE_ARTICLE	公众号文章
      # SCENE_H5	h5页面
      # SCENE_SHAKE_CARD 摇礼券
      # SCENE_BIZ_AD	公众号广告
      # SCENE_IVR	自动回复
      # SCENE_SMS	短信
      # SCENE_MEMBER_CARD_ANNOUNCEMENT 会员卡公告
      # SCENE_CARD_CUSTOM_CELL	卡券自定义cell
      # SCENE_CARD_MSG_URL 卡券消息运营位
      #
      def card_landingpage_create(banner='', title='', can_share=false, scene='', cardlist=[{cardid: '', thumb_url: ''}])
        url = "#{card_base_url}/landingpage/create"
        post_body = {
          banner: banner,
          title: title,
          can_share: can_share,
          scene: scene,
          cardlist: cardlist
        }
        http_post(url, post_body, {}, 'api')
      end

      # 创建二维码接口
      # https://api.weixin.qq.com/card/qrcode/create?access_token=TOKEN
      def card_qrcode_create(card_id='', code=nil, openid=nil,
                             expire_seconds=nil,   is_unique_code=nil, outer_id=nil)
        url = "#{card_base_url}/qrcode/create"
        card_body = {
          card_id: card_id,
          code: code,
          openid: openid,
          is_unique_code: is_unique_code,
          outer_id: outer_id
        }
        post_body = {
          action_name: 'QR_CARD',
          expire_seconds: expire_seconds,
          action_info: {card: card_body}
        }
        http_post(url, post_body, {}, 'api')
      end

      # Code解码接口
      # https://api.weixin.qq.com/card/code/decrypt?access_token=TOKEN
      def card_code_decrypt(encrypt_code='')
        url = "#{card_base_url}/code/decrypt"
        post_body = {
          encrypt_code: encrypt_code
        }
        http_post(url, post_body, {}, 'api')
      end

      # 核销Code接口
      # https://api.weixin.qq.com/card/code/consume?access_token=TOKEN
      def card_code_consume(card_id=nil, code='')
        url = "#{card_base_url}/code/consume"
        post_body = {
          card_id: card_id,
          code: code
        }
        http_post(url, post_body, {}, 'api')
      end


      # 设置卡券失效接口
      # https://api.weixin.qq.com/card/code/unavailable?access_token=TOKEN
      def card_code_unavailable(card_id=nil, code='')
        url = "#{card_base_url}/code/unavailable"
        post_body = {
          card_id: card_id,
          code: code
        }
        http_post(url, post_body, {}, 'api')
      end

      # 删除卡券接口
      # https://api.weixin.qq.com/card/delete?access_token=TOKEN
      def card_delete(card_id='')
        url = "#{card_base_url}/delete"
        post_body = {
          card_id: card_id
        }
        http_post(url, post_body, {}, 'api')
      end


      # 更改Code接口
      # https://api.weixin.qq.com/card/code/update?access_token=TOKEN
      def card_code_update(card_id=nil, code='', new_code='')
        url = "#{card_base_url}/code/update"
        post_body = {
          card_id: card_id,
          code: code,
          new_code: new_code
        }
        http_post(url, post_body, {}, 'api')
      end

      # 修改库存接口
      # https://api.weixin.qq.com/card/modifystock?access_token=TOKEN
      def card_modify_stock(card_id='', increase_stock_value=nil, reduce_stock_value=nil)
        url = "#{card_base_url}/modifystock"
        post_body = {
          card_id: card_id,
          increase_stock_value: increase_stock_value,
          reduce_stock_value: reduce_stock_value
        }
        http_post(url, post_body, {}, 'api')
      end

      # 更改卡券信息接口
      # https://api.weixin.qq.com/card/update?access_token=TOKEN
      def card_update(card_id='', card_type='', card)
        card = card[:card] if card.has_key?(:card)
        post_body = {
          card_id: card_id,
          "#{card_type}": card
        }
        endpoint = 'api'
        endpoint = 'plain' if card.is_a?(String) # 第三方开发者自定义json
        url = "#{card_base_url}/update"
        http_post(url, post_body, {}, endpoint)
      end

      # 批量查询卡列表
      # https://api.weixin.qq.com/card/batchget?access_token=TOKEN
      # offset => 查询卡列表的起始偏移量，从0开始，即offset: 5是指从从列表里的第六个开始读取。
      # count => 需要查询的卡片的数量（数量最大50）。
      # status_list => 支持开发者拉出指定状态的卡券列表，例：仅拉出通过审核的卡券。
      #
      # 卡券状态
      # CARD_STATUS_NOT_VERIFY    待审核
      # CARD_STATUS_VERIFY_FALL   审核失败
      # CARD_STATUS_VERIFY_OK     通过审核
      # CARD_STATUS_USER_DELETE   卡券被用户删除
      # CARD_STATUS_USER_DISPATCH 在公众平台投放过的卡券
      def cards(offset=0, count=50, status_list=['CARD_STATUS_USER_DISPATCH'])
        url = "#{card_base_url}/batchget"
        post_body = {
          offset: offset,
          count: count,
          status_list: status_list
        }
        http_post(url, post_body, {}, 'api')
      end

      # 查看卡券详情
      # https://api.weixin.qq.com/card/get?access_token=TOKEN
      def card(card_id='')
        url = "#{card_base_url}/get"
        post_body = {
          card_id: card_id
        }
        http_post(url, post_body, {}, 'api')
      end

      # 获取用户已领取卡券接口
      # https://api.weixin.qq.com/card/user/getcardlist?access_token=TOKEN
      def user_cards(openid='', card_id=nil)
        url = "#{card_base_url}/user/getcardlist"
        post_body = {
          openid: openid,
          card_id: card_id
        }
        http_post(url, post_body, {}, 'api')
      end


      # 查询Code
      # https://api.weixin.qq.com/card/code/get?access_token=TOKEN
      def card_code(card_id=nil, code='')
        url = "#{card_base_url}/code/get"
        post_body = {
          code: code,
          card_id: card_id
        }
        http_post(url, post_body, {}, 'api')
      end

      INVOKE_MEMBERCARD_ACTIVATE_REQUIRED_FIELDS = %i(membership_number code)
      # 激活/绑定会员卡
      # https://api.weixin.qq.com/card/membercard/activate?access_token=TOKEN
      def card_member_card_activate(params)
        params = {
          membership_number: '',
          code: '',
          activate_begin_time: nil,
          activate_end_time: nil,
          init_bonus: nil,
          init_balance: nil,
          init_custom_field_value1: nil,
          init_custom_field_value2: nil,
          init_custom_field_value3: nil,
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_MEMBERCARD_ACTIVATE_REQUIRED_FIELDS, MODULE_API_CARD_NAME)
        url = "#{card_base_url}/membercard/activate"
        http_post(url, params, {}, 'api')
      end

      INVOKE_MEMBERCARD_UPDATE_REQUIRED_FIELDS = %i(code card_id)
      # 更新会员信息
      # https://api.weixin.qq.com/card/membercard/updateuser?access_token=TOKEN
      def card_member_card_update_user(params)
        invoke_required_fields = INVOKE_MEMBERCARD_UPDATE_REQUIRED_FIELDS
        invoke_required_fields << :bonus if params[:add_bonus].nil?
        invoke_required_fields << :balance if params[:add_balance].nil?
        params = {
          code: '',
          card_id: '',
          add_bonus: nil,
          bonus: nil,
          record_bonus: '',
          add_balance: nil,
          balance: nil,
          record_balance: '',
          custom_field_value1: '',
          custom_field_value2: '',
          custom_field_value3: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, invoke_required_fields, MODULE_API_CARD_NAME)
        url = "#{card_base_url}/membercard/updateuser"
        http_post(url, params, {}, 'api')
      end

      INVOKE_MEETINGTICKET_UPDATE_REQUIRED_FIELDS = %i(code zone entrance seat_number)
      # 更新会议门票
      # https://api.weixin.qq.com/card/meetingticket/updateuser?access_token=TOKEN
      def card_meeting_ticket_update_user(params)
        params = {
          code: '',
          card_id: nil,
          begin_time: nil,
          end_time: nil,
          zone: '',
          entrance: '',
          seat_number: ''
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_MEETINGTICKET_UPDATE_REQUIRED_FIELDS, MODULE_API_CARD_NAME)
        url = "#{card_base_url}/meetingticket/updateuser"
        http_post(url, params, {}, 'api')
      end

      INVOKE_MOVIETICKET_UPDATE_REQUIRED_FIELDS = %i(show_time duration code card_id ticket_class)
      # 更新电影票
      # https://api.weixin.qq.com/card/movieticket/updateuser?access_token=TOKEN
      def card_moive_ticket_update_user(params)
        params = {
          code: '',
          card_id: '',
          ticket_class: '',
          screening_room: nil,
          seat_number: nil,
          show_time: nil,
          duration: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_MOVIETICKET_UPDATE_REQUIRED_FIELDS, MODULE_API_CARD_NAME)
        url = "#{card_base_url}/movieticket/updateuser"
        http_post(url, params, {}, 'api')
      end

      INVOKE_BOARDPASS_UPDATE_REQUIRED_FIELDS = %i(code passenger_name etkt_bnr)
      # 更新飞机票信息
      # https://api.weixin.qq.com/card/boardingpass/checkin?access_token=TOKEN
      def card_boarding_pass_checkin(params)
        params = {
          code: '',
          card_id: nil,
          passenger_name: '',
          class: '',
          seat: nil,
          etkt_bnr: nil,
          qrcode_data: nil,
          is_cancel: nil
        }.merge(params)
        WechatAuthorize.check_required_options(params, INVOKE_BOARDPASS_UPDATE_REQUIRED_FIELDS, MODULE_API_CARD_NAME)
        url = "#{card_base_url}/boardingpass/checkin"
        http_post(url, params, {}, 'api')
      end

      # 微信卡券创建接口
      # https://api.weixin.qq.com/card/create?access_token=ACCESS_TOKEN
      def card_create(card)
        endpoint = 'api'
        endpoint = 'plain' if card.is_a?(String) # 第三方开发者自定义json
        url = "#{card_base_url}/create"
        http_post(url, card, {}, endpoint)
      end

      private
      def datacube_base_url
        "/datacube"
      end

      def card_base_url
        "/card"
      end

      def datacube_datetime_format(param)
        param = Time.at(param) if param.is_a?(Integer)
        param = param.strftime("%Y-%m-%d") if param.is_a?(Time)
        param
      end

    end
  end
end
