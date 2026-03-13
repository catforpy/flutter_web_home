import 'package:official_website/domain/entities/page_component.dart';
import 'package:official_website/domain/entities/components/carousel_component.dart';
import 'package:official_website/domain/entities/components/search_component.dart';
import 'package:official_website/domain/entities/components/category_nav_component.dart';
import 'package:official_website/domain/entities/components/notice_component.dart';
import 'package:official_website/domain/entities/components/title_component.dart';

/// 页面组件模拟数据源
///
/// 所有假数据都集中在这里管理，方便后续替换为真实 API
class PageComponentMockDatasource {
  /// 获取默认页面组件列表
  static List<PageComponent> getDefaultComponents() {
    return [
      _buildDefaultSearch(),
      _buildDefaultCategoryNav(),
      _buildDefaultCarousel(),
      _buildDefaultNotice(),
      _buildDefaultTitle(),
    ];
  }

  /// 获取可用组件列表（用于组件面板）
  static List<ComponentType> getAvailableComponents() {
    return ComponentType.values.where((type) => type != ComponentType.unknown).toList();
  }

  /// 构建默认搜索组件
  static SearchComponent _buildDefaultSearch() {
    return SearchComponent(
      id: 'search_001',
      config: const SearchConfig(
        placeholder: '请输入搜索内容',
      ),
      style: SearchStyle.defaultStyle,
    );
  }

  /// 构建默认分类导航组件
  static CategoryNavComponent _buildDefaultCategoryNav() {
    return CategoryNavComponent(
      id: 'category_nav_001',
      items: _getMockCategoryNavItems(),
      style: CategoryNavStyle.defaultStyle,
    );
  }

  /// 构建默认轮播组件
  static CarouselComponent _buildDefaultCarousel() {
    return CarouselComponent(
      id: 'carousel_001',
      images: _getMockCarouselImages(),
      style: CarouselStyle.defaultStyle,
    );
  }

  /// 构建默认公告组件
  static NoticeComponent _buildDefaultNotice() {
    return NoticeComponent(
      id: 'notice_001',
      items: _getMockNoticeItems(),
      config: NoticeConfig.defaultConfig,
      style: NoticeStyle.defaultStyle,
    );
  }

  /// 构建默认标题组件
  static TitleComponent _buildDefaultTitle() {
    return TitleComponent(
      id: 'title_001',
      text: '热门课程',
      style: TitleStyle.defaultStyle,
    );
  }

  // ==================== 模拟数据 ====================

  static List<CarouselImage> _getMockCarouselImages() {
    return [
      const CarouselImage(
        url: 'https://via.placeholder.com/800x400?text=Banner+1',
        linkType: '无链接',
        linkTarget: '',
      ),
      const CarouselImage(
        url: 'https://via.placeholder.com/800x400?text=Banner+2',
        linkType: '无链接',
        linkTarget: '',
      ),
      const CarouselImage(
        url: 'https://via.placeholder.com/800x400?text=Banner+3',
        linkType: '无链接',
        linkTarget: '',
      ),
    ];
  }

  static List<CategoryNavItem> _getMockCategoryNavItems() {
    return List.generate(8, (index) {
      return CategoryNavItem(
        imageUrl: 'https://via.placeholder.com/100',
        title: '分类${index + 1}',
        linkType: '无链接',
        linkTarget: '',
      );
    });
  }

  static List<NoticeItem> _getMockNoticeItems() {
    return [
      const NoticeItem(
        content: '欢迎使用页面编辑器！',
        linkUrl: null,
      ),
      const NoticeItem(
        content: '新功能上线通知',
        linkUrl: null,
      ),
    ];
  }
}
