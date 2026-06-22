# 项目基础架构

## 产品边界

移动端由同一个 Flutter APP 承载会员与商家/店员。登录后必须由服务端返回的角色、账号状态和审核状态决定首页及权限。管理员使用独立 Web 后台，移动端仅展示无权限引导。

核心核销流程：

```text
会员浏览商家/优惠/商品服务
  -> 到店后展示动态会员二维码
  -> 商家扫码识别会员和可用优惠
  -> 付款方填写并确认消费金额
  -> 商家核对收款并确认核销
  -> 会员、商家、后台分别查看归属范围内的数据
```

二维码是身份识别和核销凭证，不承担线上支付能力。

## 代码组织

项目采用 feature-first，并在复杂 feature 内按职责分层：

```text
feature/
  data/          # DTO、远程/本地数据源、Repository 实现
  domain/        # 实体、Repository 协议、业务规则
  presentation/  # 页面、组件、状态控制器
```

- `app`：应用级启动、主题和路由，不能放具体业务逻辑。
- `core`：无业务归属的基础能力，如网络、存储、错误模型和通用组件。
- `features/auth`：Token、账号状态、角色权限、登录与第三方授权。
- `features/member`：认证、会员卡、二维码、消费入单与本人消费记录。
- `features/merchant`：入驻、门店、优惠、商品服务、扫码与本店统计。
- `features/activity`、`features/opportunity`：活动和商机独立演进。

跨 feature 调用通过 domain 协议或应用级路由完成，页面之间不直接读取彼此的数据实现。

## 路由与权限

路由守卫至少校验：

1. 是否登录及 Token 是否有效。
2. 当前账号角色是否允许访问目标路由。
3. 会员认证、商家审核、管理员权限等业务状态。
4. 数据是否属于本人或本店。

客户端权限只控制体验，服务端接口必须重复执行角色和数据归属校验。

## 插件基线

| 能力 | 插件 | 使用原则 |
| --- | --- | --- |
| 状态与依赖注入 | `get` | 页面逻辑使用 GetxController，基础能力使用 GetxService |
| 路由与守卫 | `go_router` | 集中声明应用级路由和角色重定向 |
| HTTP | `dio` | 统一配置超时、Token、刷新、错误转换和日志 |
| 安全存储 | `flutter_secure_storage` | 只保存 Token、刷新 Token 等敏感数据 |
| 偏好设置 | `shared_preferences` | 保存语言、引导状态和非敏感偏好 |
| 网络状态 | `connectivity_plus` | 只用于体验提示，真实请求仍处理网络异常 |
| 扫码/二维码 | `mobile_scanner`、`qr_flutter` | 二维码内容使用后端签发的短时 Token |
| 图片与权限 | `image_picker`、`permission_handler` | 认证、入驻、商品服务图片统一上传 |
| 图片缓存 | `cached_network_image` | 列表和详情图片统一占位及错误态 |
| 外部能力 | `url_launcher` | 电话、地图、协议和客服链接 |

LINE/微信登录等平台 SDK 在开放平台账号、回调 Scheme 和服务端 OAuth 流程确定后接入；认证逻辑应封装在 `features/auth/data`，避免页面绑定具体 SDK。

## 环境与发布

- 使用 `APP_ENV` 和 `API_BASE_URL` 的 `dart-define` 区分开发、测试与生产环境。
- 正式发布前替换 Android `applicationId`、iOS Bundle ID、签名和应用图标。
- API 日志不得输出 Token、手机号、证件或金额明细。
- 动态二维码、入单和核销接口需要幂等键、防重放与完整审计日志。
