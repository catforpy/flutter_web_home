import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill/translations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../../core/cache/workbench_cache_service.dart';
import '../../../routes/app_router.dart';

/// 文章新增/编辑页面
/// 使用 flutter_quill 实现专业富文本编辑器
class ArticleEditPage extends StatefulWidget {
  final String? articleId;

  /// 是否显示完整的导航（一级导航栏+顶部标题栏）
  /// 当嵌入到 MerchantDashboard 中时，应设置为 false
  final bool showFullNavigation;

  /// 返回按钮回调（用于嵌入式模式）
  final VoidCallback? onBack;

  /// 导航历史回调（用于在导航栈中返回上一级）
  final VoidCallback? onBackToPrevious;

  const ArticleEditPage({
    super.key,
    this.articleId,
    this.showFullNavigation = true,
    this.onBack,
    this.onBackToPrevious,
  });

  @override
  State<ArticleEditPage> createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  // 展开的子菜单
  final Set<String> _expandedMenus = {'模块管理'};

  // Quill 编辑器控制器
  late QuillController _quillController;

  // 图片选择器
  final ImagePicker _imagePicker = ImagePicker();

  // 表单数据
  final TextEditingController _titleController = TextEditingController(text: '这里是标题！');
  final TextEditingController _summaryController = TextEditingController(text: '这里是文章简介');
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _viewsController = TextEditingController(text: '0');
  final TextEditingController _likesController = TextEditingController(text: '0');
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sortController = TextEditingController(text: '0');
  final TextEditingController _mediaLinkController = TextEditingController();

  // 下拉选择
  String _linkType = '公众号文章链接';
  String _selectedCategory = '无分类';
  String _isRecommended = '不推荐';
  String _isMemberOnly = '否';
  String _contentType = '富文本';
  String _linkMediaType = '视频';
  String _productStyle = '滑动';

  // 封面图片
  String? _coverImage;
  File? _coverImageFile;

  // 日期时间
  DateTime? _publishTime;

  // 推荐的商品列表
  final List<Map<String, dynamic>> _recommendedProducts = [];

  // 关联的文章列表
  final List<Map<String, dynamic>> _relatedArticles = [];

  // 缓存服务
  final WorkbenchCacheService _cacheService = WorkbenchCacheService();

  // 分类列表
  List<ArticleCategory> _categories = [];

  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initQuillEditor();
  }

  /// 加载分类列表
  Future<void> _loadCategories() async {
    try {
      final config = await _cacheService.getArticleManagementConfig();
      setState(() {
        _categories = config.categories;
      });
    } catch (e) {
      debugPrint('加载分类失败: $e');
    }
  }

  /// 初始化 Quill 编辑器
  void _initQuillEditor() {
    _quillController = QuillController.basic();
    // 设置默认内容
    final delta = Delta()..insert('请输入文章内容...\n');
    _quillController.document = Document.fromDelta(delta);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _linkController.dispose();
    _sourceController.dispose();
    _viewsController.dispose();
    _likesController.dispose();
    _priceController.dispose();
    _sortController.dispose();
    _mediaLinkController.dispose();
    _quillController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 根据 showFullNavigation 参数决定布局
    if (widget.showFullNavigation) {
      // 完整页面布局（包含一级导航栏和顶部标题栏）
      return Scaffold(
        backgroundColor: const Color(0xFFF5F6F7),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧一级导航栏（保持原有导航）
              _buildSidebar(),

              // 主内容区
              Expanded(
                child: Column(
                  children: [
                    // 顶部标题栏
                    _buildTopHeader(),

                    // 主内容区
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            // 1. 链接抓取工具栏
                            _buildLinkFetcherToolbar(),

                            const SizedBox(height: 16),

                            // 2. 左右分栏布局
                            _buildSplitPaneLayout(),
                          ],
                        ),
                      ),
                    ),

                    // 3. 底部固定操作栏
                    _buildFooterActions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 嵌入式布局（不包含一级导航栏和顶部标题栏，用于嵌入到 MerchantDashboard）
      return Material(
        color: const Color(0xFFF5F6F7),
        child: Column(
          children: [
            // 主内容区
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // 1. 链接抓取工具栏
                    _buildLinkFetcherToolbar(),

                    const SizedBox(height: 16),

                    // 2. 左右分栏布局
                    _buildSplitPaneLayout(),
                  ],
                ),
              ),
            ),

            // 3. 底部固定操作栏
            _buildFooterActions(),
          ],
        ),
      );
    }
  }

  /// 构建左侧导航栏
  Widget _buildSidebar() {
    return Container(
      width: 200,
      color: const Color(0xFF1F2329),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(Icons.store, '管理中心', isActive: false, hasSubmenu: false),
                _buildMenuItem(Icons.phone_android, '小程序管理', isActive: false, hasSubmenu: true,
                  submenu: ['开发设置', '审核管理', '菜单导航', '订阅消息', '跳转小程序', '开发者模式']),
                _buildMenuItem(Icons.settings, '配置管理', isActive: false, hasSubmenu: true,
                  submenu: ['支付配置', '分享海报设置', '客服设置', '短信设置', '音视频存储', '广告位配置']),
                _buildMenuItem(Icons.extension, '模块管理', isActive: true, hasSubmenu: true,
                  submenu: ['文章管理', '留言管理', '启动图管理', '活动页配置', '经典语录管理']),
                _buildMenuItem(Icons.image, '页面管理', isActive: false, hasSubmenu: true,
                  submenu: ['主页管理', '个人中心管理']),
              ],
            ),
          ),

          // 底部品牌标识
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFF1A9B8E)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '唐极课得',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFCCCCCC),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(IconData icon, String label, {bool isActive = false, bool hasSubmenu = false, List<String>? submenu}) {
    final isExpanded = _expandedMenus.contains(label);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (hasSubmenu) {
                  if (_expandedMenus.contains(label)) {
                    _expandedMenus.remove(label);
                  } else {
                    _expandedMenus.add(label);
                  }
                } else {
                  if (label == '管理中心') {
                    context.go(AppRouter.merchantDashboard);
                  }
                }
              });
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1A9B8E).withValues(alpha: 0.2) : Colors.transparent,
                border: isActive
                    ? const Border(
                        left: BorderSide(color: Color(0xFF1A9B8E), width: 3),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isActive ? const Color(0xFF1A9B8E) : const Color(0xFFCCCCCC),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: isActive ? const Color(0xFF1A9B8E) : const Color(0xFFCCCCCC),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (hasSubmenu)
                    Icon(
                      isExpanded ? Icons.expand_more : Icons.chevron_right,
                      size: 16,
                      color: const Color(0xFFCCCCCC),
                    ),
                ],
              ),
            ),
          ),
        ),

        // 子菜单列表
        if (hasSubmenu && isExpanded)
          Container(
            padding: const EdgeInsets.only(left: 46),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: submenu!.map((subItem) {
                final isSubActive = subItem == '文章管理';
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if (subItem == '文章管理') {
                        context.go(AppRouter.articleManagement);
                      }
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        subItem,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSubActive ? const Color(0xFF1A9B8E) : const Color(0xFF999999),
                          fontWeight: isSubActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  /// 构建顶部标题栏
  Widget _buildTopHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Text(
            '新增资讯',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2329),
            ),
          ),
          const Spacer(),
          // 返回列表按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                context.go(AppRouter.articleList);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '返回列表',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1. 链接抓取工具栏
  Widget _buildLinkFetcherToolbar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 来源类型
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _linkType,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 20),
                items: const [
                  DropdownMenuItem(value: '公众号文章链接', child: Text('公众号文章链接', style: TextStyle(fontSize: 14))),
                  DropdownMenuItem(value: '其他链接', child: Text('其他链接', style: TextStyle(fontSize: 14))),
                ],
                onChanged: (value) {
                  setState(() {
                    _linkType = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 链接输入框
          Expanded(
            child: TextField(
              controller: _linkController,
              decoration: InputDecoration(
                hintText: '请填写链接',
                hintStyle: const TextStyle(color: Color(0xFF999999)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 提取按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                debugPrint('提取页面内容');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('链接抓取功能开发中...')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF52C41A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '提取页面内容',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. 左右分栏布局
  Widget _buildSplitPaneLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：手机实时预览（35%宽度）
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35 - 100,
          child: _buildMobilePreview(),
        ),
        const SizedBox(width: 16),

        // 右侧：表单配置区
        Expanded(
          child: _buildFormConfiguration(),
        ),
      ],
    );
  }

  /// 左侧：手机实时预览
  Widget _buildMobilePreview() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // iPhone 外壳
          Container(
            width: 375,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF333333), width: 8),
            ),
            child: Column(
              children: [
                // 刘海/状态栏
                Container(
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 60),
                      const Text(
                        '12:00',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          const Text('4G', style: TextStyle(color: Colors.white, fontSize: 12)),
                          const SizedBox(width: 4),
                          const Icon(Icons.battery_full, color: Colors.white, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),

                // 导航栏
                Container(
                  height: 44,
                  color: Colors.black,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                        onPressed: () {},
                      ),
                      const Expanded(
                        child: Text(
                          '资讯详情',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // 内容区域
                Container(
                  height: 600,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 封面图
                        if (_coverImage != null || _coverImageFile != null)
                          SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: kIsWeb
                                ? Image.network(_coverImage!, fit: BoxFit.cover)
                                : Image.file(_coverImageFile!, fit: BoxFit.cover),
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 200,
                            color: const Color(0xFFEEEEEE),
                            child: const Icon(Icons.image, size: 50, color: Color(0xFFCCCCCC)),
                          ),

                        // 标题
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _titleController.text.isNotEmpty ? _titleController.text : '这里是标题！',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2329),
                            ),
                          ),
                        ),

                        // 简介
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _summaryController.text.isNotEmpty ? _summaryController.text : '这里将会显示内容',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // 底部 Home 条
                Container(
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 右侧：表单配置区
  Widget _buildFormConfiguration() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. 基础信息模块
          _buildBasicInfoModule(),

          const SizedBox(height: 24),

          // B. 营销与高级设置模块
          _buildMarketingModule(),

          const SizedBox(height: 24),

          // C. 富文本编辑器模块
          _buildRichTextEditorModule(),

          const SizedBox(height: 24),

          // D. 关联推荐模块
          _buildRelatedArticlesModule(),
        ],
      ),
    );
  }

  /// A. 基础信息模块
  Widget _buildBasicInfoModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '基础信息',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 16),

        // 文章标题
        _buildTextField('文章标题 *', '这里添加文章标题', _titleController, maxLines: 1),
        const SizedBox(height: 16),

        // 封面图 & 文章简介
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图上传（支持本地文件选择）
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '封面图片 *',
                    style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: _pickCoverImage,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _coverImage != null
                          ? Image.network(_coverImage!, fit: BoxFit.cover)
                          : _coverImageFile != null
                              ? Image.file(_coverImageFile!, fit: BoxFit.cover)
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate, size: 32, color: Color(0xFF999999)),
                                      SizedBox(height: 8),
                                      Text('点击上传封面', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        '尺寸: ',
                        style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                      ),
                      const Text(
                        '(750*420)',
                        style: TextStyle(fontSize: 12, color: Color(0xFFFF4D4F)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _pickCoverImage,
                        child: const Text(
                          '选择本地文件',
                          style: TextStyle(fontSize: 12, color: Color(0xFF1890FF), decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 文章简介
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '文章简介 *',
                    style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _summaryController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: '文章简介',
                      hintStyle: const TextStyle(color: Color(0xFF999999)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 文章类别 & 排序权重
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                '文章类别',
                ['无分类', ..._categories.map((c) => c.name)],
                _selectedCategory,
                (value) => setState(() => _selectedCategory = value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField('排序权重', '排序权重', _sortController),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 是否推荐 & 付费价格
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                '是否推荐',
                ['不推荐', '推荐'],
                _isRecommended,
                (value) => setState(() => _isRecommended = value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField('付费价格', '付费价格', _priceController),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 阅读量 & 点赞量
        Row(
          children: [
            Expanded(
              child: _buildNumberField('阅读量', '阅读量', _viewsController),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField('点赞量', '点赞量', _likesController),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 文章来源 & 时间
        Row(
          children: [
            Expanded(
              child: _buildTextField('文章来源', '文章来源', _sourceController),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateTimePicker(),
            ),
          ],
        ),
      ],
    );
  }

  /// B. 营销与高级设置模块
  Widget _buildMarketingModule() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '营销与高级设置',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
          ),
          const SizedBox(height: 16),

          // 推荐付费预约商品样式
          _buildRadioField(
            '推荐付费预约商品样式',
            ['滑动', '列表'],
            _productStyle,
            (value) => setState(() => _productStyle = value),
          ),
          const SizedBox(height: 16),

          // 推荐付费预约商品
          Row(
            children: [
              const Text(
                '推荐付费预约商品',
                style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('添加商品');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1890FF)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '添加',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1890FF)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _recommendedProducts.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFF4D4F)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '清空',
                      style: TextStyle(fontSize: 12, color: Color(0xFFFF4D4F)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _recommendedProducts.isEmpty
              ? GestureDetector(
                  onTap: () {
                    debugPrint('添加商品');
                  },
                  child: const Text(
                    '无推荐付费预约商品',
                    style: TextStyle(fontSize: 14, color: Color(0xFF1890FF)),
                  ),
                )
              : Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: _recommendedProducts.length,
                    itemBuilder: (context, index) {
                      final product = _recommendedProducts[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text('¥${product['price']}'),
                      );
                    },
                  ),
                ),

          const SizedBox(height: 16),

          // 是否会员查看
          _buildRadioField(
            '是否会员查看',
            ['是', '否'],
            _isMemberOnly,
            (value) => setState(() => _isMemberOnly = value),
          ),
          const SizedBox(height: 16),

          // 链接类型
          _buildRadioField(
            '链接类型',
            ['视频', '音频'],
            _linkMediaType,
            (value) => setState(() => _linkMediaType = value),
          ),
          const SizedBox(height: 8),

          // 音频/视频预览按钮
          Row(
            children: [
              const Text(
                '视频/音频链接',
                style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('预览音视频');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF52C41A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '音频/视频预览',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 视频/音频链接输入框
          TextField(
            controller: _mediaLinkController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '视频/音频链接',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            ' 仅支持七牛云，腾讯视频链接，或填写视频的源链接',
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              debugPrint('查看音视频上传教程');
            },
            child: const Text(
              '音视频上传教程可点此查看',
              style: TextStyle(fontSize: 12, color: Color(0xFFFF4D4F)),
            ),
          ),
        ],
      ),
    );
  }

  /// C. 富文本编辑器模块（使用 flutter_quill）
  Widget _buildRichTextEditorModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 详情内容显示类型
        _buildRadioField(
          '详情内容显示类型',
          ['富文本', '相册'],
          _contentType,
          (value) => setState(() => _contentType = value),
        ),
        const SizedBox(height: 8),
        const Text(
          ' (富文本展示详情可以上传图文，相册展示详情只能上传图片)',
          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
        const SizedBox(height: 16),

        const Text(
          '文章内容 *',
          style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 8),

        // Quill 富文本编辑器
        Container(
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // 工具栏
              QuillToolbar.simple(
                controller: _quillController,
                configurations: const QuillSimpleToolbarConfigurations(
                  showDirection: false,
                  showSearchButton: false,
                  showClearFormat: false,
                  showBackgroundColorButton: true,
                  showFontSize: true,
                  showFontFamily: false,
                  showHeaderStyle: true,
                  showListCheck: true,
                  showCodeBlock: true,
                  showIndent: true,
                  showLink: true,
                  showSuperscript: false,
                  showSubscript: false,
                  showQuote: true,
                  showStrikeThrough: true,
                  showInlineCode: true,
                ),
              ),

              // 编辑器主体
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: QuillEditor.basic(
                    controller: _quillController,
                    configurations: const QuillEditorConfigurations(
                      autoFocus: true,
                    ),
                  ),
                ),
              ),

              // 字数统计
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  border: Border(
                    top: BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '字数统计: ${_quillController.document.length - 1}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 14, color: Color(0xFF999999)),
                        const SizedBox(width: 4),
                        const Text(
                          '支持快捷键：Ctrl+B 加粗 | Ctrl+I 斜体 | Ctrl+U 下划线',
                          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 富文本功能说明
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6FFED),
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '富文本编辑器功能说明：',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
              ),
              SizedBox(height: 8),
              Text(
                '• 文本格式：标题（H1-H6）、加粗（Ctrl+B）、斜体（Ctrl+I）、下划线（Ctrl+U）、删除线',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              Text(
                '• 对齐方式：左对齐、居中、右对齐、两端对齐',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              Text(
                '• 列表：有序列表（1、2、3...）、无序列表（•）、待办清单',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              Text(
                '• 插入内容：图片、视频、链接',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              Text(
                '• 高级功能：代码块、引用、行内代码',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              Text(
                '• 颜色：文字颜色、背景颜色',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              Text(
                '• 快捷键：Ctrl+Z 撤销 | Ctrl+Y 重做',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),

        // 工具栏中文对照表
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7FF),
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '工具栏按钮说明（鼠标悬停查看英文，实际功能如下）：',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Text('🔤 撤销/重做', style: TextStyle(fontSize: 12)),
                  Text('📝 标题H1-H6', style: TextStyle(fontSize: 12)),
                  Text('𝐁 𝘐 𝐔 𝐒 加粗/斜体/下划线/删除线', style: TextStyle(fontSize: 12)),
                  Text('🎨 文字颜色/背景色', style: TextStyle(fontSize: 12)),
                  Text('🔗 列表（无序/有序/待办）', style: TextStyle(fontSize: 12)),
                  Text('⬅️➡️ 对齐方式', style: TextStyle(fontSize: 12)),
                  Text('↔️ 缩进', style: TextStyle(fontSize: 12)),
                  Text('🔗 链接', style: TextStyle(fontSize: 12)),
                  Text('🖼️ 图片', style: TextStyle(fontSize: 12)),
                  Text('💻 代码块', style: TextStyle(fontSize: 12)),
                  Text('💬 引用', style: TextStyle(fontSize: 12)),
                  Text('🔄 清除格式', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// D. 关联推荐模块
  Widget _buildRelatedArticlesModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '相关文章',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2329)),
            ),
            const SizedBox(width: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  debugPrint('添加相关文章');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF52C41A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '+ 添加相关文章',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _relatedArticles.isEmpty
            ? const Text(
                '暂无相关文章',
                style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
              )
            : Container(
                height: 100,
                child: ListView.builder(
                  itemCount: _relatedArticles.length,
                  itemBuilder: (context, index) {
                    final article = _relatedArticles[index];
                    return ListTile(
                      title: Text(article['title']),
                      subtitle: Text(article['category']),
                    );
                  },
                ),
              ),
      ],
    );
  }

  /// 3. 底部固定操作栏
  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBE6),
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 保存按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _saveArticle,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1890FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '保存',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 返回列表按钮
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // 优先使用导航历史回调（用于导航栈）
                if (widget.onBackToPrevious != null) {
                  widget.onBackToPrevious!();
                } else if (widget.onBack != null) {
                  // 其次使用返回回调
                  widget.onBack!();
                } else {
                  // 最后使用路由跳转
                  context.go(AppRouter.articleList);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1890FF)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '返回列表',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1890FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 辅助方法 ====================

  /// 选择封面图片
  Future<void> _pickCoverImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          setState(() {
            _coverImage = image.path;
            _coverImageFile = null;
          });
        } else {
          setState(() {
            _coverImageFile = File(image.path);
            _coverImage = null;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('封面图已选择'), backgroundColor: Color(0xFF52C41A)),
        );
      }
    } catch (e) {
      debugPrint('选择图片失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择图片失败: $e'), backgroundColor: Color(0xFFFF4D4F)),
      );
    }
  }

  /// 保存文章
  void _saveArticle() {
    // 验证必填字段
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入文章标题'), backgroundColor: Color(0xFFFF4D4F)),
      );
      return;
    }

    if (_coverImage == null && _coverImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请上传封面图片'), backgroundColor: Color(0xFFFF4D4F)),
      );
      return;
    }

    if (_summaryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入文章简介'), backgroundColor: Color(0xFFFF4D4F)),
      );
      return;
    }

    // 获取富文本内容
    final contentJson = _quillController.document.toDelta().toJson();
    if (contentJson.isEmpty || (contentJson.length == 1 && contentJson[0]['insert'] == '\n')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入文章内容'), backgroundColor: Color(0xFFFF4D4F)),
      );
      return;
    }

    // 保存成功
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功'), backgroundColor: Color(0xFF52C41A)),
    );

    debugPrint('文章内容 JSON: $contentJson');

    // 返回列表
    context.go(AppRouter.articleList);
  }

  /// 构建文本输入框
  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  /// 构建数字输入框
  Widget _buildNumberField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF999999)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  /// 构建下拉选择框
  Widget _buildDropdownField(String label, List<String> items, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D9D9)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 构建单选框组
  Widget _buildRadioField(String label, List<String> options, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((option) {
            return Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        onChanged(newValue);
                      }
                    },
                    activeColor: const Color(0xFF1890FF),
                  ),
                  Text(option, style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建日期时间选择器
  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '发布时间',
          style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _publishTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _publishTime != null
                  ? '${_publishTime!.year}-${_publishTime!.month.toString().padLeft(2, '0')}-${_publishTime!.day.toString().padLeft(2, '0')} ${_publishTime!.hour.toString().padLeft(2, '0')}:${_publishTime!.minute.toString().padLeft(2, '0')}'
                  : '选择时间',
              style: TextStyle(
                fontSize: 14,
                color: _publishTime != null ? const Color(0xFF1F2329) : const Color(0xFF999999),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          ' 新增文章时，不填则默认为保存时间；修改文章时，不填为不修改时间',
          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
        ),
      ],
    );
  }
}
