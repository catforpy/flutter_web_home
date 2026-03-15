import 'package:dio/dio.dart';
import '../../domain/models/mini_program_registration.dart';
import '../../domain/models/mini_program_verification.dart';

/// 微信小程序API服务
/// 包含注册、认证相关接口
class MiniProgramApiService {
  final Dio _dio;

  MiniProgramApiService(this._dio);

  factory MiniProgramApiService.create() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    return MiniProgramApiService(dio);
  }

  // ==================== 注册小程序相关接口 ====================

  /// 检测小程序名称是否可用
  Future<ApiResponse<NameCheckResult>> checkMiniProgramName(
    String name, {
    String? appId,
  }) async {
    try {
      final response = await _dio.get(
        '/weixin/mini-program/check-name',
        queryParameters: {
          'name': name,
          if (appId != null) 'appId': appId,
        },
      );
      return ApiResponse<NameCheckResult>.fromJson(response.data);
    } catch (e) {
      return ApiResponse<NameCheckResult>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  /// 快速注册小程序
  Future<ApiResponse<RegisterResult>> registerMiniProgram(
    MiniProgramRegistration registration,
  ) async {
    try {
      final response = await _dio.post(
        '/weixin/mini-program/register',
        data: registration.toJson(),
      );
      return ApiResponse<RegisterResult>.fromJson(response.data);
    } catch (e) {
      return ApiResponse<RegisterResult>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  /// 查询注册任务状态
  Future<ApiResponse<RegistrationTaskStatus>> getRegistrationTaskStatus(
    String taskId,
  ) async {
    try {
      final response = await _dio.get(
        '/weixin/mini-program/register/task',
        queryParameters: {'taskId': taskId},
      );
      return ApiResponse<RegistrationTaskStatus>.fromJson(response.data);
    } catch (e) {
      return ApiResponse<RegistrationTaskStatus>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  /// 重新发送法人授权消息
  Future<ApiResponse<void>> resendAuthorizationMessage(
    Map<String, dynamic> data,
  ) async {
    try {
      await _dio.post(
        '/weixin/mini-program/resend-auth',
        data: data,
      );
      return const ApiResponse<void>(errcode: 0, errmsg: 'success');
    } catch (e) {
      return ApiResponse<void>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  // ==================== 认证小程序相关接口 ====================

  /// 上传认证材料
  ///
  /// 上传营业执照、银行账户等认证材料，返回临时文件ID
  Future<ApiResponse<String>> uploadVerificationMaterial(
    String filePath,
    MaterialType type,
  ) async {
    try {
      // TODO: 实现文件上传逻辑
      // 这里应该调用文件上传接口
      await Future.delayed(const Duration(seconds: 1));
      return const ApiResponse<String>(
        errcode: 0,
        errmsg: 'success',
        data: 'file_url_placeholder',
      );
    } catch (e) {
      return ApiResponse<String>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  /// 代小程序认证
  Future<ApiResponse<VerificationResult>> verifyMiniProgram(
    MiniProgramVerification verification,
  ) async {
    try {
      final response = await _dio.post(
        '/weixin/mini-program/verify',
        data: verification.toJson(),
      );
      return ApiResponse<VerificationResult>.fromJson(response.data);
    } catch (e) {
      return ApiResponse<VerificationResult>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  /// 查询认证订单状态
  Future<ApiResponse<VerificationOrderStatus>> getVerificationOrderStatus(
    String orderId,
  ) async {
    try {
      final response = await _dio.get(
        '/weixin/mini-program/verify/order',
        queryParameters: {'orderId': orderId},
      );
      return ApiResponse<VerificationOrderStatus>.fromJson(response.data);
    } catch (e) {
      return ApiResponse<VerificationOrderStatus>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  /// 打回重填
  Future<ApiResponse<void>> resubmitVerification(
    Map<String, dynamic> data,
  ) async {
    try {
      await _dio.post(
        '/weixin/mini-program/verify/resubmit',
        data: data,
      );
      return const ApiResponse<void>(errcode: 0, errmsg: 'success');
    } catch (e) {
      return ApiResponse<void>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }

  /// 获取认证到期时间
  Future<ApiResponse<DateTime>> getVerificationExpiry(
    String appId,
  ) async {
    try {
      final response = await _dio.get(
        '/weixin/mini-program/verify/expiry',
        queryParameters: {'appId': appId},
      );
      return ApiResponse<DateTime>.fromJson(response.data);
    } catch (e) {
      return ApiResponse<DateTime>(
        errcode: -1,
        errmsg: e.toString(),
      );
    }
  }
}

// ==================== 响应模型 ====================

/// API响应包装类
class ApiResponse<T> {
  /// 错误码（0表示成功）
  final int errcode;

  /// 错误信息
  final String errmsg;

  /// 响应数据
  final T? data;

  const ApiResponse({
    required this.errcode,
    required this.errmsg,
    this.data,
  });

  /// 是否成功
  bool get isSuccess => errcode == 0;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      errcode: json['errcode'] as int? ?? -1,
      errmsg: json['errmsg'] as String? ?? 'Unknown error',
      data: json['data'],
    );
  }
}

/// 注册结果
class RegisterResult {
  /// 任务ID
  final String taskId;

  /// 小程序APPID（如果注册成功）
  final String? appId;

  /// 授权验证URL（用于生成二维码）
  final String? authUrl;

  const RegisterResult({
    required this.taskId,
    this.appId,
    this.authUrl,
  });
}

/// 注册任务状态
class RegistrationTaskStatus {
  /// 任务ID
  final String taskId;

  /// 任务状态
  final RegistrationStatus status;

  /// 小程序APPID
  final String? appId;

  /// 原始ID
  final String? originalId;

  /// 错误信息
  final String? errorMessage;

  /// 进度（0-100）
  final int progress;

  const RegistrationTaskStatus({
    required this.taskId,
    required this.status,
    this.appId,
    this.originalId,
    this.errorMessage,
    required this.progress,
  });
}

/// 认证结果
class VerificationResult {
  /// 认证订单号
  final String orderId;

  /// 授权验证URL（用于生成二维码）
  final String? authUrl;

  /// 支付URL（如果需要支付）
  final String? paymentUrl;

  const VerificationResult({
    required this.orderId,
    this.authUrl,
    this.paymentUrl,
  });
}

/// 认证订单状态
class VerificationOrderStatus {
  /// 订单号
  final String orderId;

  /// 订单状态
  final VerificationStatus status;

  /// 认证到期时间
  final DateTime? expiryDate;

  /// 驳回原因（如果被驳回）
  final String? rejectReason;

  /// 缺失材料列表（如果被打回）
  final List<String>? missingMaterials;

  /// 进度（0-100）
  final int progress;

  const VerificationOrderStatus({
    required this.orderId,
    required this.status,
    this.expiryDate,
    this.rejectReason,
    this.missingMaterials,
    required this.progress,
  });
}

/// 文件上传辅助类（简化版）
class FileUploadHelper {
  /// 上传文件
  static Future<String> uploadFile(String filePath, MaterialType type) async {
    // TODO: 实现文件上传逻辑
    return 'file_url_placeholder';
  }
}
