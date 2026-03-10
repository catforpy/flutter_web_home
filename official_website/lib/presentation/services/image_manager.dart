import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 图片数据模型
class GalleryImage {
  final String id;
  final String name;
  final String url; // base64 或网络URL
  final String groupId;
  final DateTime uploadTime;

  GalleryImage({
    required this.id,
    required this.name,
    required this.url,
    this.groupId = '',
    DateTime? uploadTime,
  }) : uploadTime = uploadTime ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'groupId': groupId,
      'uploadTime': uploadTime.toIso8601String(),
    };
  }

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      groupId: json['groupId'] ?? '',
      uploadTime: DateTime.parse(json['uploadTime']),
    );
  }
}

/// 图片分组数据模型
class ImageGroup {
  final String id;
  final String name;
  final int sortOrder; // 排序权重
  final DateTime createTime;

  ImageGroup({
    required this.id,
    required this.name,
    required this.sortOrder,
    DateTime? createTime,
  }) : createTime = createTime ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sortOrder': sortOrder,
      'createTime': createTime.toIso8601String(),
    };
  }

  factory ImageGroup.fromJson(Map<String, dynamic> json) {
    return ImageGroup(
      id: json['id'],
      name: json['name'],
      sortOrder: json['sortOrder'],
      createTime: DateTime.parse(json['createTime']),
    );
  }
}

/// 图片管理服务（单例）
class ImageManager {
  static final ImageManager _instance = ImageManager._internal();
  factory ImageManager() => _instance;
  ImageManager._internal();

  final List<GalleryImage> _images = [];
  final List<ImageGroup> _groups = [
    ImageGroup(id: 'all', name: '全部图片', sortOrder: 0),
    ImageGroup(id: 'public', name: '公共图片', sortOrder: 1),
  ];

  List<GalleryImage> get images => List.unmodifiable(_images);
  List<ImageGroup> get groups => List.unmodifiable(_groups);

  /// 添加图片
  void addImage(GalleryImage image) {
    _images.add(image);
    _saveData();
  }

  /// 删除图片
  void deleteImage(String imageId) {
    _images.removeWhere((img) => img.id == imageId);
    _saveData();
  }

  /// 更新图片
  void updateImage(GalleryImage image) {
    final index = _images.indexWhere((img) => img.id == image.id);
    if (index != -1) {
      _images[index] = image;
      _saveData();
    }
  }

  /// 添加分组
  void addGroup(ImageGroup group) {
    _groups.add(group);
    // 按排序权重排序
    _groups.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    _saveData();
  }

  /// 删除分组
  void deleteGroup(String groupId) {
    if (groupId == 'all' || groupId == 'public') return; // 不允许删除默认分组
    _groups.removeWhere((g) => g.id == groupId);
    _saveData();
  }

  /// 根据分组ID获取图片
  List<GalleryImage> getImagesByGroup(String groupId) {
    if (groupId == 'all') {
      return _images;
    }
    return _images.where((img) => img.groupId == groupId).toList();
  }

  /// 保存数据到本地存储
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // 保存图片
    final imagesJson = jsonEncode(_images.map((img) => img.toJson()).toList());
    await prefs.setString('gallery_images', imagesJson);

    // 保存分组
    final groupsJson = jsonEncode(_groups.map((g) => g.toJson()).toList());
    await prefs.setString('image_groups', groupsJson);
  }

  /// 从本地存储加载数据
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // 加载图片
    final imagesJson = prefs.getString('gallery_images');
    if (imagesJson != null) {
      final List<dynamic> decoded = jsonDecode(imagesJson);
      _images.clear();
      _images.addAll(decoded.map((json) => GalleryImage.fromJson(json)));
    }

    // 加载分组
    final groupsJson = prefs.getString('image_groups');
    if (groupsJson != null) {
      final List<dynamic> decoded = jsonDecode(groupsJson);
      _groups.clear();
      _groups.addAll(decoded.map((json) => ImageGroup.fromJson(json)));
      // 按排序权重排序
      _groups.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }
  }

  /// 初始化（应用启动时调用）
  Future<void> initialize() async {
    await _loadData();
  }

  /// 搜索图片
  List<GalleryImage> searchImages(String keyword) {
    if (keyword.isEmpty) return _images;
    return _images.where((img) =>
      img.name.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }
}
