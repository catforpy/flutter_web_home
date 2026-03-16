/// 云存储提供商类型
enum CloudProvider {
  aliyun,   // 阿里云OSS
  tencent,  // 腾讯云COS
  qiniu,    // 七牛云
}

/// 云存储配置
class CloudStorageConfig {
  final String id;                    // 配置ID
  final CloudProvider provider;       // 服务商类型
  final String roleName;             // RAM角色名（阿里云）
  final String accessKeyId;          // AccessKey ID
  final String accessKeySecret;      // AccessKey Secret（不存储明文）
  final String? bucketName;          // 默认bucket名称
  final String? region;              // 区域
  final DateTime createdAt;

  CloudStorageConfig({
    required this.id,
    required this.provider,
    required this.roleName,
    required this.accessKeyId,
    required this.accessKeySecret,
    this.bucketName,
    this.region,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider.name,
      'roleName': roleName,
      'accessKeyId': accessKeyId,
      'accessKeySecret': accessKeySecret,
      'bucketName': bucketName,
      'region': region,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CloudStorageConfig.fromJson(Map<String, dynamic> json) {
    return CloudStorageConfig(
      id: json['id'],
      provider: CloudProvider.values.firstWhere(
        (e) => e.name == json['provider'],
        orElse: () => CloudProvider.aliyun,
      ),
      roleName: json['roleName'],
      accessKeyId: json['accessKeyId'],
      accessKeySecret: json['accessKeySecret'],
      bucketName: json['bucketName'],
      region: json['region'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  /// 获取服务商显示名称
  String get providerName {
    switch (provider) {
      case CloudProvider.aliyun:
        return '阿里云 OSS';
      case CloudProvider.tencent:
        return '腾讯云 COS';
      case CloudProvider.qiniu:
        return '七牛云';
    }
  }
}

/// Bucket信息
class BucketInfo {
  final String name;         // bucket名称
  final String? region;      // 区域
  final DateTime createdAt;

  BucketInfo({
    required this.name,
    this.region,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// 文件夹信息
class FolderInfo {
  final String name;         // 文件夹名称
  final String path;         // 完整路径
  final DateTime createdAt;

  FolderInfo({
    required this.name,
    required this.path,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
