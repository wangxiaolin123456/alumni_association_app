# 校友会 APP

一个 Flutter 客户端承载会员与商家/店员两类移动端工作台。管理员使用独立 Web 后台，不进入移动端业务首页。

## 核心业务约束

- 登录后根据服务端角色加载独立首页、底部导航和权限。
- 会员二维码是身份识别与核销码，不是支付码。
- 实际付款方在会员端填写消费金额，商家核对收款后确认核销。
- 商品/服务用于展示与线下引流，一期不提供购物车和线上支付。

## 工程结构

```text
lib/
  app/                  # 应用启动、路由、主题
  core/                 # 配置、网络、存储、通用组件
  features/
    auth/               # 登录、角色与会话
    home/               # 角色工作台与公共首页组件
    member/             # 会员专属能力
    merchant/           # 商家/店员专属能力
    activity/           # 活动
    opportunity/        # 商机
    profile/            # 我的与设置
```

每个复杂业务 feature 后续按 `data / domain / presentation` 分层；简单展示模块不强制制造空层。

## 环境配置

通过 `dart-define` 注入环境，禁止在业务代码里硬编码服务地址：

```bash
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=https://dev-api.example.com
```

## 主要依赖

- `get`：GetxController 状态、角色会话与 GetxService 依赖注入
- `go_router`：路由与角色守卫
- `dio`：HTTP 客户端
- `flutter_secure_storage` / `shared_preferences`：Token 与本地偏好
- `mobile_scanner` / `qr_flutter`：商家扫码与会员二维码
- `image_picker` / `permission_handler`：认证、入驻和资料上传
- `cached_network_image`：图片缓存
- `connectivity_plus`：网络状态
- `url_launcher`：电话、地图导航和外部协议
