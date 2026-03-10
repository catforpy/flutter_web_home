import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/cache/workbench_cache_service.dart';
import '../../../routes/app_router.dart';
import 'comment_list_content.dart';

/// 文章列表内容组件（可复用的纯内容组件，不包含导航栏）
class ArticleListContent extends StatefulWidget {
  /// 新增文章回调
  final VoidCallback? onAddArticle;

  /// 编辑文章回调
  final Function(String articleId)? onEditArticle;

  const ArticleListContent({
    super.key,
    this.onAddArticle,
    this.onEditArticle,
  });

  @override
  State<ArticleListContent> createState() => _ArticleListContentState();
}

class _ArticleListContentState extends State<ArticleListContent> {
  // 搜索筛选条件
  String _searchKeyword = '';
  String _selectedCategory = '全部分类';
  String _sortOrder = '最近更新';
  DateTime? _startDate;
  DateTime? _endDate;

  // 文章列表数据
  final List<Map<String, dynamic>> _articles = [
    {
      'id': '1',
      'title': '论抖音视频对生活的影响',
      'source': '后台添加',
      'category': '老师介绍',
      'views': 123,
      'sort': 1,
      'updateTime': DateTime(2026, 3, 8, 14, 30),
      'isRecommended': false,
    },
    {
      'id': '2',
      'title': '如何高效学习编程',
      'source': '后台添加',
      'category': '部门简介',
      'views': 256,
      'sort': 2,
      'updateTime': DateTime(2026, 3, 7, 9, 15),
      'isRecommended': true,
    },
    {
      'id': '3',
      'title': '2024年行业发展趋势分析',
      'source': '后台添加',
      'category': '最新资讯',
      'views': 89,
      'sort': 3,
      'updateTime': DateTime(2026, 3, 6, 16, 45),
      'isRecommended': false,
    },
    {
      'id': '4',
      'title': 'Flutter 开发实战指南',
      'source': '后台添加',
      'category': '最新资讯',
      'views': 345,
      'sort': 4,
      'updateTime': DateTime(2026, 3, 5, 11, 20),
      'isRecommended': true,
    },
    {
      'id': '5',
      'title': 'Web 前端架构设计思路',
      'source': '后台添加',
      'category': '部门简介',
      'views': 167,
      'sort': 5,
      'updateTime': DateTime(2026, 3, 4, 8, 50),
      'isRecommended': false,
    },
  ];

  // 全选状态
  bool _isAllSelected = false;
  final Set<String> _selectedIds = {};

  // 缓存服务
  final WorkbenchCacheService _cacheService = WorkbenchCacheService();

  // 分类列表
  List<ArticleCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 1. 提示栏
            _buildAlertBar(),

            const SizedBox(height: 16),

            // 2. 搜索筛选栏
            _buildSearchFilterBar(),

            const SizedBox(height: 16),

            // 3. 统计看板
            _buildStatisticsDashboard(),

            const SizedBox(height: 16),

            // 4. 数据表格
            _buildDataTable(),

            const SizedBox(height: 16),

            // 5. 批量操作栏
            _buildBatchActionBar(),
          ],
        ),
      ),
    );
  }

  /// 1. 提示栏
  Widget _buildAlertBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FFED),
        border: Border.all(color: const Color(0xFFFFF7D9)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFFFA940)),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: '注：新增资讯时记得选择'),
                TextSpan(
                  text: '『文章类别』',
                  style: const TextStyle(
                    color: Color(0xFFFF4D4F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '。当不选择『文章类别』时该条资讯则在手机端资讯列表不显示'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. 搜索筛选栏
  Widget _buildSearchFilterBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          // 标题搜索 + 分类筛选 + 排序 + 日期范围 + 查询 + 新增
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题搜索
              Expanded(
                flex: 3,
                child: _buildSearchField(
                  '标题',
                  '请输入标题',
                  _searchKeywordController,
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),

              // 分类筛选
              SizedBox(
                width: 180,
                child: _buildDropdownField(
                  '文章类别',
                  ['全部分类', '部门简介', '老师介绍', '最新资讯'],
                  _selectedCategory,
                  (value) => setState(() => _selectedCategory = value),
                ),
              ),
              const SizedBox(width: 12),

              // 排序方式
              SizedBox(
                width: 150,
                child: _buildDropdownField(
                  '排序方式',
                  ['最近更新', '阅读量从高到低', '阅读量从低到高'],
                  _sortOrder,
                  (value) => setState(() => _sortOrder = value),
                ),
              ),
              const SizedBox(width: 12),

              // 时间范围
              _buildDateRangePicker(),
              const SizedBox(width: 12),

              // 查询按钮
              _buildQueryButton(),
              const SizedBox(width: 12),

              // 新增按钮
              _buildAddButton(),
            ],
          ),
        ],
      ),
    );
  }

  final TextEditingController _searchKeywordController = TextEditingController();

  /// 构建搜索输入框
  Widget _buildSearchField(String label, String hint, TextEditingController controller, {Function(String)? onChanged}) {
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
          onChanged: onChanged,
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

  /// 构建日期范围选择器
  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '时间范围',
          style: TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() {
                _startDate = picked.start;
                _endDate = picked.end;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9D)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Color(0xFF999999)),
                const SizedBox(width: 8),
                Text(
                  _startDate != null && _endDate != null
                      ? '${_startDate!.month}/${_startDate!.day} - ${_endDate!.month}/${_endDate!.day}'
                      : '选择时间',
                  style: TextStyle(
                    fontSize: 14,
                    color: _startDate != null && _endDate != null ? const Color(0xFF1F2329) : const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建查询按钮
  Widget _buildQueryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' ', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              debugPrint('查询文章列表');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1890FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '查询',
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
    );
  }

  /// 构建新增按钮
  Widget _buildAddButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(' ', style: TextStyle(fontSize: 14, color: Color(0xFF1F2329))),
        const SizedBox(height: 4),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // 优先使用回调（用于嵌入模式）
              if (widget.onAddArticle != null) {
                widget.onAddArticle!();
              } else {
                // 否则使用路由跳转
                context.push(AppRouter.articleEdit);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1890FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '新增',
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
    );
  }

  /// 3. 统计看板
  Widget _buildStatisticsDashboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          Expanded(child: _buildStatItem('13', '总文章数', const Color(0xFFFF6B35))),
          Container(width: 1, height: 60, color: const Color(0xFFE5E5E5)),
          Expanded(child: _buildStatItem('165', '总阅读量', const Color(0xFFFF6B35))),
          Container(width: 1, height: 60, color: const Color(0xFFE5E5E5)),
          Expanded(child: _buildStatItem('6', '总评论数', const Color(0xFF1890FF))),
          Container(width: 1, height: 60, color: const Color(0xFFE5E5E5)),
          Expanded(child: _buildStatItem('1', '总点赞数', const Color(0xFFFF6B35))),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  /// 4. 数据表格
  Widget _buildDataTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 表头
          _buildTableHeader(),

          // 表格内容
          ...List.generate(_articles.length, (index) {
            return _buildTableRow(_articles[index], index);
          }),
        ],
      ),
    );
  }

  /// 构建表头
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E5E5)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(value: false, onChanged: null),
          ),
          Expanded(flex: 3, child: Text('标题', style: _getTableHeaderStyle())),
          Expanded(flex: 2, child: Text('来源', style: _getTableHeaderStyle())),
          Expanded(flex: 2, child: Text('分类', style: _getTableHeaderStyle())),
          Expanded(flex: 1, child: Center(child: Text('阅读量', style: _getTableHeaderStyle()))),
          Expanded(flex: 2, child: Text('操作', style: _getTableHeaderStyle())),
        ],
      ),
    );
  }

  /// 构建表格行
  Widget _buildTableRow(Map<String, dynamic> article, int index) {
    final isSelected = _selectedIds.contains(article['id']);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF6FFED) : (index % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA)),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        children: [
          // 复选框
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedIds.add(article['id']);
                  } else {
                    _selectedIds.remove(article['id']);
                  }
                  _updateSelectAllState();
                });
              },
            ),
          ),

          // 标题
          Expanded(
            flex: 3,
            child: Text(
              article['title'],
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
            ),
          ),

          // 来源
          Expanded(
            flex: 2,
            child: Text(
              article['source'],
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ),

          // 分类
          Expanded(
            flex: 2,
            child: Text(
              article['category'],
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ),

          // 阅读量
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '${article['views']}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),
          ),

          // 操作
          Expanded(
            flex: 2,
            child: Wrap(
              spacing: 8,
              children: [
                _buildActionLink('编辑', const Color(0xFF1890FF), () {
                  // 优先使用回调（用于嵌入模式）
                  if (widget.onEditArticle != null) {
                    widget.onEditArticle!(article['id']);
                  } else {
                    // 否则使用路由跳转
                    context.push('${AppRouter.articleEdit}?articleId=${article['id']}');
                  }
                }),
                _buildActionLink('评论', const Color(0xFF1890FF), () {
                  _showCommentDialog(article['id'], article['title']);
                }),
                _buildActionLink('删除', const Color(0xFFFF4D4F), () {
                  debugPrint('删除: ${article['id']}');
                }),
                _buildActionLink('页面路径', const Color(0xFF999999), () {
                  debugPrint('页面路径: ${article['id']}');
                }),
                if (article['isRecommended'])
                  _buildActionLink('取消推荐', const Color(0xFF999999), () {
                      debugPrint('取消推荐: ${article['id']}');
                    })
                else
                  _buildActionLink('设置推荐', const Color(0xFF1890FF), () {
                      debugPrint('设置推荐: ${article['id']}');
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作链接
  Widget _buildActionLink(String text, Color color, VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  TextStyle _getTableHeaderStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1F2329),
    );
  }

  /// 5. 批量操作栏
  Widget _buildBatchActionBar() {
    if (_selectedIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7FF),
        border: Border.all(color: const Color(0xFF1890FF)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            '已选择 ${_selectedIds.length} 项',
            style: const TextStyle(fontSize: 14, color: Color(0xFF1F2329)),
          ),
          const SizedBox(width: 24),
          _buildBatchActionButton('批量修改分类', null, () {
            debugPrint('批量修改分类');
          }),
          const SizedBox(width: 12),
          _buildBatchActionButton('批量修改阅读量', null, () {
            debugPrint('批量修改阅读量');
          }),
          const SizedBox(width: 12),
          _buildBatchActionButton('批量删除', const Color(0xFFFF4D4F), () {
            debugPrint('批量删除');
          }),
        ],
      ),
    );
  }

  /// 构建批量操作按钮
  Widget _buildBatchActionButton(String text, [Color? color, VoidCallback? onPressed]) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color ?? const Color(0xFF1890FF)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color ?? const Color(0xFF1890FF),
            ),
          ),
        ),
      ),
    );
  }

  /// 更新全选状态
  void _updateSelectAllState() {
    setState(() {
      _isAllSelected = _selectedIds.length == _articles.length;
    });
  }

  /// 显示评论对话框
  void _showCommentDialog(String articleId, String articleTitle) {
    showDialog(
      context: context,
      barrierDismissible: false, // 点击遮罩不关闭
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 全屏显示
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 标题栏
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '文章评论',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2329),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            articleTitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.close, size: 24, color: Color(0xFF999999)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // 评论列表内容
                Expanded(
                  child: CommentListContent(
                    articleId: articleId,
                    articleTitle: articleTitle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
