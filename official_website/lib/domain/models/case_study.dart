/// 案例研究模型
/// 用于展示企业成功案例
class CaseStudy {
  /// 案例标题
  final String title;

  /// 所属行业
  final String industry;

  /// 案例图片URL
  final String imageUrl;

  /// 案例描述
  final String description;

  /// 客户公司名称
  final String companyName;

  /// 案例标签（可选）
  final List<String>? tags;

  /// 案例链接（可选）
  final String? linkUrl;

  CaseStudy({
    required this.title,
    required this.industry,
    required this.imageUrl,
    required this.description,
    required this.companyName,
    this.tags,
    this.linkUrl,
  });

  /// 创建案例的便捷方法
  static CaseStudy create({
    required String title,
    required String industry,
    required String imageUrl,
    required String description,
    required String companyName,
    List<String>? tags,
    String? linkUrl,
  }) {
    return CaseStudy(
      title: title,
      industry: industry,
      imageUrl: imageUrl,
      description: description,
      companyName: companyName,
      tags: tags,
      linkUrl: linkUrl,
    );
  }
}
