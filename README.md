简书地址：http://www.jianshu.com/users/3930920b505b/latest_articles

花了两周闲余时间模仿了一下今日头条旗下的iOS端app内涵段子，相信大家对于这个app并不陌生，如果喜欢的话请给个star，也希望大家能够积极提出建议和见解，共同进步。

##主要实现的功能如下：
#### 首页 : 包括点赞、踩、分享、收藏，复制链接，视频的播放，上拉下拉，评论列表，关注列表
#####首页
![精选首页.jpeg](http://upload-images.jianshu.io/upload_images/939127-943a3634a77afe9b.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![确认删除.jpeg](http://upload-images.jianshu.io/upload_images/939127-46c677a9543e14fd.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![
![发布.jpeg](http://upload-images.jianshu.io/upload_images/939127-d3e23a8cb176b243.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
](http://upload-images.jianshu.io/upload_images/939127-626a0d9dd077ff7e.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 发现：轮播，热吧列表，推荐的关注用户列表，订阅列表，搜索，附近的人，附近的人的筛选，利用贝塞尔曲线自定义pageControl
#####发现
![发现.jpeg](http://upload-images.jianshu.io/upload_images/939127-2ea854e0fb6e9b8d.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![订阅.jpeg](http://upload-images.jianshu.io/upload_images/939127-ad5347d4bfd74af6.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 审核：举报，喜欢和不喜欢，手动左滑刷新，利用贝塞尔曲线和CAShaperLayer加载视图动画
#####审核
![审核.jpeg](http://upload-images.jianshu.io/upload_images/939127-f388459f5aa5ed70.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 发布：选择热吧，发布图片文字
##### 搜索、发布
![搜索.jpeg](http://upload-images.jianshu.io/upload_images/939127-44b28984456420c4.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![搜索结果.jpeg](http://upload-images.jianshu.io/upload_images/939127-79ce50ea582d0f80.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![推荐关注.jpeg](http://upload-images.jianshu.io/upload_images/939127-cfefe46478f8a380.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![消息.jpeg](http://upload-images.jianshu.io/upload_images/939127-a2bc5fbee2694445.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 用户：用户信息写死在本地，模仿登录逻辑
#####用户
![个人.jpeg](http://upload-images.jianshu.io/upload_images/939127-e5633ad9e53919c0.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


####代码展示
```请求基类，在网络请求工具类上一层封装，传递属性，然后获取所有成员变量的值，即为请求参数
@protocol NHBaseRequestReponseDelegate <NSObject>
@required
/** 如果不用block返回数据的话，这个方法必须实现*/
- (void)requestSuccessReponse:(BOOL)success response:(id)response message:(NSString *)message;
@end

typedef void(^NHAPIDicCompletion)(id response, BOOL success, NSString *message);
@interface NHBaseRequest : NSObject

@property (nonatomic, weak) id <NHBaseRequestReponseDelegate> nh_delegate;
/** 链接*/
@property (nonatomic, copy) NSString *nh_url;
/** 默认GET*/
@property (nonatomic, assign) BOOL nh_isPost;
/** 图片数组*/
@property (nonatomic, strong) NSArray <UIImage *>*nh_imageArray;

/** 构造方法*/
+ (instancetype)nh_request;
+ (instancetype)nh_requestWithUrl:(NSString *)nh_url;
+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost;
+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost delegate:(id <NHBaseRequestReponseDelegate>)nh_delegate;

/** 开始请求，如果设置了代理，不需要block回调*/
- (void)nh_sendRequest;
/** 开始请求，没有设置代理，或者设置了代理，需要block回调，block回调优先级高于代理*/
- (void)nh_sendRequestWithCompletion:(NHAPIDicCompletion)completion;

@end
```

```
首页最复杂的cell
@class NHBaseImageView;

typedef NS_ENUM(NSUInteger, NHHomeTableViewCellItemType) {
    /** 点赞*/
    NHHomeTableViewCellItemTypeLike = 1,
    /** 踩*/
    NHHomeTableViewCellItemTypeDontLike,
    /** 评论*/
    NHHomeTableViewCellItemTypeComment,
    /** 分享*/
    NHHomeTableViewCellItemTypeShare
};

@class NHHomeTableViewCellFrame , NHHomeTableViewCell, NHDiscoverSearchCommonCellFrame, NHNeiHanUserInfoModel;
@protocol NHHomeTableViewCellDelegate <NSObject>

/** 分类*/
- (void)homeTableViewCellDidClickCategory:(NHHomeTableViewCell *)cell;
/** 个人中心*/
- (void)homeTableViewCell:(NHHomeTableViewCell *)cell gotoPersonalCenterWithUserInfo:(NHNeiHanUserInfoModel *)userInfoModel;
/** 点击底部item*/
- (void)homeTableViewCell:(NHHomeTableViewCell *)cell didClickItemWithType:(NHHomeTableViewCellItemType)itemType;
/** 点击浏览大图*/
- (void)homeTableViewCell:(NHHomeTableViewCell *)cell didClickImageView:(UIImageView *)imageView currentIndex:(NSInteger)currentIndex urls:(NSArray <NSURL *>*)urls;
/** 播放视频*/
- (void)homeTableViewCell:(NHHomeTableViewCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(NHBaseImageView *)baseImageView;

@optional
/** 点击关注*/
- (void)homeTableViewCellDidClickAttention:(NHHomeTableViewCell *)cell;
/** 删除*/
- (void)homeTableViewCellDidClickClose:(NHHomeTableViewCell *)cell;
@end
@interface NHHomeTableViewCell : NHBaseTableViewCell

/** 代理*/
@property (nonatomic, weak) id <NHHomeTableViewCellDelegate> delegate;
/** 首页cellFrame模型*/
@property (nonatomic, strong) NHHomeTableViewCellFrame *cellFrame;
/** 搜索cellFrame模型*/
@property (nonatomic, strong) NHDiscoverSearchCommonCellFrame *searchCellFrame;
/** 用来判断是否有删除按钮*/
@property (nonatomic, assign) BOOL isFromHomeController;
```
```
审核，利用贝塞尔完成一些展示上的效果
- (void)setLeftScale:(CGFloat)leftScale {
    _leftScale = leftScale;
    NSInteger leftDelta = leftScale * 100;
    self.leftL.text = [NSString stringWithFormat:@"%ld%%", leftDelta];
    
    CGFloat height = 10;
    UIRectCorner corner = UIRectCornerAllCorners;
    if (leftScale == 1.0) {
        corner = UIRectCornerAllCorners;
    } else {
        corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    }
    
    UIBezierPath *bezierPath0 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, self.height / 2.0 - height / 2.0, 0, height) byRoundingCorners:corner cornerRadii:CGSizeMake(5.f, 5.f)];
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, self.height / 2.0 - height / 2.0, self.width * self.leftScale, height) byRoundingCorners:corner cornerRadii:CGSizeMake(5.f, 5.f)];
    
    CGFloat duration = 0.8;
    [self performSelector:@selector(showLeftAndRightLabel) withObject:nil afterDelay:duration];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    animation.fromValue = (__bridge id _Nullable)(bezierPath0.CGPath);
    animation.toValue = (__bridge id _Nullable)(bezierPath1.CGPath);
    [self.leftLayer addAnimation:animation forKey:@""];
}
```
```
首页滑动穿透效果
// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_fillColor set];
    
    CGRect newRect = rect;
    newRect.size.width = rect.size.width * self.progress;
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
}
```
####附上自定义的一些类，项目中有自定义的ActionSheet，AlertView，SegmentControl，pageControl等， 
```
贴上几段封装的关于tableView的一些代码
typedef NS_ENUM(NSInteger, NHBaseTableViewRowAnimation) {
    Fade = UITableViewRowAnimationFade,
    Right = UITableViewRowAnimationRight,           // slide in from right (or out to right)
    Left = UITableViewRowAnimationLeft,
    Top = UITableViewRowAnimationTop,
    Bottom = UITableViewRowAnimationBottom,
    None = UITableViewRowAnimationNone,            // available in iOS 3.0
    Middle = UITableViewRowAnimationMiddle,          // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
    Automatic = 100  // available in iOS 5.0.  chooses an appropriate animation style for you
};
@class NHBaseTableViewCell;
@interface NHBaseTableView : UITableView
- (void)nh_updateWithUpdateBlock:(void(^)(NHBaseTableView *tableView ))updateBlock;
- (UITableViewCell *)nh_cellAtIndexPath:(NSIndexPath *)indexPath;

/** 注册普通的UITableViewCell*/
- (void)nh_registerCellClass:(Class)cellClass identifier:(NSString *)identifier;

/** 注册一个从xib中加载的UITableViewCell*/
- (void)nh_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier;

/** 注册一个普通的UITableViewHeaderFooterView*/
- (void)nh_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier;

/** 注册一个从xib中加载的UITableViewHeaderFooterView*/
- (void)nh_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier;

#pragma mark - 只对已经存在的cell进行刷新，没有类似于系统的 如果行不存在，默认insert操作
/** 刷新单行、动画默认*/
- (void)nh_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 刷新单行、动画默认*/
- (void)nh_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(NHBaseTableViewRowAnimation)animation;

/** 刷新多行、动画默认*/
- (void)nh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 刷新多行、动画默认*/
- (void)nh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(NHBaseTableViewRowAnimation)animation;

/** 刷新某个section、动画默认*/
- (void)nh_reloadSingleSection:(NSInteger)section;

/** 刷新某个section、动画自定义*/
- (void)nh_reloadSingleSection:(NSInteger)section animation:(NHBaseTableViewRowAnimation)animation;

/** 刷新多个section、动画默认*/
- (void)nh_reloadSections:(NSArray <NSNumber *>*)sections;

/** 刷新多个section、动画自定义*/
- (void)nh_reloadSections:(NSArray <NSNumber *>*)sections animation:(NHBaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 删除单行、动画默认*/
- (void)nh_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 删除单行、动画自定义*/
- (void)nh_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(NHBaseTableViewRowAnimation)animation;

/** 删除多行、动画默认*/
- (void)nh_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 删除多行、动画自定义*/
- (void)nh_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(NHBaseTableViewRowAnimation)animation;

/** 删除某个section、动画默认*/
- (void)nh_deleteSingleSection:(NSInteger)section;
```

####[简单易用的tableViewControllerGithub地址：https://github.com/Charlesyaoxin/CustomTableViewController](https://github.com/Charlesyaoxin/CustomTableViewController)
###分析和总结
- 这个项目做得时间比较仓促，前后用了不到两周的时间。
- 不知道仔细看的朋友有没有意识到，这是用纯代码写的，并不是自己不习惯用nib或者sb，是因为一直以来想用纯代码写一个项目。
- 下一阶段的方向大概是swift项目了，现在在着手一个swift小项目，前段时间写的，大概75%完成度了，也会在未来开源出来
- 最后，希望大家能够提出良好的建议和见解，如果想交朋友的可以加我qq3297391688，共同进步，成为一名真正的‘老司机’

附： 
####[高仿内涵段子Github地址：https://github.com/Charlesyaoxin/NeiHanDuanZI](https://github.com/Charlesyaoxin/NeiHanDuanZI)
