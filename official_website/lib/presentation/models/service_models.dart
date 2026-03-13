/// 行业分类数据模型
class IndustryCategory {
  final String id;
  final String name;
  final String icon;
  final List<String> subCategories;

  const IndustryCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.subCategories,
  });
}

/// 服务卡片数据模型
class ServiceCard {
  final String id;
  final String title;
  final String coverImage;
  final List<String> tags;
  final String providerName;
  final String providerAvatar;
  final double price;
  final String priceUnit;
  final int minOrder;
  final String category;

  const ServiceCard({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.tags,
    required this.providerName,
    required this.providerAvatar,
    required this.price,
    required this.priceUnit,
    required this.minOrder,
    required this.category,
  });
}
