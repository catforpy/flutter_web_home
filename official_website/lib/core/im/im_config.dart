/// 腾讯云 IM 配置
class IMConfig {
  /// SDKAppID - 腾讯云 IM 应用 ID
  ///
  /// ⚠️ 重要: 所有平台（Flutter Web、UniApp、小程序）必须使用相同的 SDKAppID
  /// 请在腾讯云控制台获取: https://console.cloud.tencent.com/im
  static const int sdkAppId = 0; // TODO: 替换为你的 SDKAppID

  /// API 基础地址（用于获取 userSig）
  ///
  /// 你的后端服务需要提供生成 userSig 的接口
  static const String apiBaseUrl = 'https://your-api.com/api';

  /// 获取 UserSig 的 API 端点
  static const String getUserSigEndpoint = '/im/getUserSig';

  /// 测试用的 UserSig（仅开发环境使用）
  ///
  /// ⚠️ 生产环境必须从服务端获取 userSig，不能在前端生成！
  static const Map<String, String> mockUserSigs = {
    // 从腾讯云控制台生成测试 UserSig:
    // 1. 登录 https://console.cloud.tencent.com/im
    // 2. 选择应用 -> 开发辅助工具 -> UserSig 生成&校验
    // 3. 输入 userID，生成测试 userSig
    // 4. 将生成的 userSig 填入下方
    'user_001': '', // TODO: 填入 user_001 的测试 UserSig
    'user_002': '', // TODO: 填入 user_002 的测试 UserSig
  };

  /// 当前用户 ID（用于测试）
  ///
  /// ⚠️ 注意: 多端互通时，所有端必须使用相同的 userID
  /// 例如: Flutter Web 用 "user_001"，UniApp 也用 "user_001"
  static const String currentUserId = 'user_001';

  /// 获取测试 UserSig
  static String? getTestUserSig(String userId) {
    return mockUserSigs[userId];
  }
}
