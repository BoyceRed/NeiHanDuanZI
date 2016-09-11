//
//  NHDynamicDetailViewController.m
//  NeiHan
//
//  Created by Charles on 16/9/3.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "NHDynamicDetailViewController.h"
#import "NHDynamicDetailRequest.h"
#import "NHHomeServiceDataModel.h"
#import "NHDynamicDetailCommentCellFrame.h"
#import "NHHomeTableViewCell.h"
#import "NHHomeTableViewCellFrame.h"
#import "NHDynamicDetailCommentTableViewCell.h"
#import "NHDynamicDetailReportViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "NHBaseNavigationViewController.h"
#import "NHDiscoverSearchCommonCellFrame.h"
#import "NHDiscoverTopicViewController.h"
#import "NHPersonalCenterViewController.h"
#import "NHHomeNeiHanShareView.h"
#import "NHPersonalCenterViewController.h"
#import "NHNeiHanShareManager.h"
#import "NHHomeAttentionListSectionHeaderView.h"

@interface NHDynamicDetailViewController () <NHHomeTableViewCellDelegate, NHDynamicDetailCommentTableViewCellDelegate>
@property (nonatomic, strong) NHHomeTableViewCellFrame *cellFrame;
@property (nonatomic, strong) NHDiscoverSearchCommonCellFrame *searchCellFrame;
@property (nonatomic, strong) NSMutableArray *commentCellFrameArray;
@property (nonatomic, strong) NSMutableArray *topCommentCellFrameArray;
@property (nonatomic, strong) NSMutableArray *topDataArray;
@end

@implementation NHDynamicDetailViewController

#pragma mark - 构造
- (instancetype)initWithSearchCellFrame:(NHDiscoverSearchCommonCellFrame *)searchCellFrame {
    if (self = [super init]) {
        self.searchCellFrame = searchCellFrame;
    }
    return self;
}

- (instancetype)initWithCellFrame:(NHHomeTableViewCellFrame *)cellFrame {
    if (self = [super init]) {
        self.cellFrame = cellFrame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setUpItems];
    
    // 设置子视图
    [self setUpViews];
    
    // 请求数据
    [self loadData];
}

// 请求数据
- (void)loadData {
    
    // 加载动态内容
    if (self.cellFrame) {
        NHHomeTableViewCellFrame *cellFrame = [[NHHomeTableViewCellFrame alloc] init];
        [cellFrame setModel:self.cellFrame.model isDetail:YES];
        self.cellFrame = cellFrame;
        [self nh_reloadData];
    } else if (self.searchCellFrame) {
        // 将seachcellframe里面的group组装为element然后封装为tableviewcellframe
        NHHomeTableViewCellFrame *cellFrame = [[NHHomeTableViewCellFrame alloc] init];
        NHHomeServiceDataElement *element =[[NHHomeServiceDataElement alloc] init];
        element.group = self.searchCellFrame.group;
        [cellFrame setModel:element isDetail:YES];
        self.cellFrame = cellFrame;
        [self nh_reloadData];
    }
    
    // 评论
    NHDynamicDetailRequest *request = [NHDynamicDetailRequest nh_request];
    request.nh_url = kNHHomeDynamicCommentListAPI;
    if (self.cellFrame) {
        request.group_id = self.cellFrame.model.group.ID;
    } else {
        request.group_id = self.searchCellFrame.group.ID;
    }
    request.sort = @"hot";
    request.offset = 0;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)response;
                // 最近评论
                if ([dict.allKeys containsObject:@"recent_comments"]) {
                    self.dataArray = [NHHomeServiceDataElementComment modelArrayWithDictArray:response[@"recent_comments"]]; for (NHHomeServiceDataElementComment *comment in self.dataArray) {
                        NHDynamicDetailCommentCellFrame *cellFrame = [[NHDynamicDetailCommentCellFrame alloc] init];
                        cellFrame.commentModel = comment;
                        [self.commentCellFrameArray addObject:cellFrame];
                    }
                }
                // 热门评论
                if ([dict.allKeys containsObject:@"top_comments"]) {
                    self.topDataArray = [NHHomeServiceDataElementComment modelArrayWithDictArray:response[@"top_comments"]];
                    for (NHHomeServiceDataElementComment *comment in self.topDataArray) {
                        NHDynamicDetailCommentCellFrame *cellFrame = [[NHDynamicDetailCommentCellFrame alloc] init];
                        cellFrame.commentModel = comment;
                        [self.topCommentCellFrameArray addObject:cellFrame];
                    }
                }
            }
           
            [self nh_reloadData];
        }
    }];
  

}
- (void)requestActionWithActionname:(NSString *)actionname {
    
    NHHomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    // 指针不变，只需要更换值
    if ([actionname isEqualToString:@"digg"]) {
        if (self.cellFrame.model.group.user_digg) {
            return ;
        }
        self.cellFrame.model.group.user_digg = 1;
        self.cellFrame.model.group.digg_count += 1;
        [cell didDigg];
        
    } else if ([actionname isEqualToString:@"bury"]) {
        if (self.cellFrame.model.group.user_bury) {
            return ;
        }
        self.cellFrame.model.group.user_bury = 1;
        self.cellFrame.model.group.bury_count += 1;
        [cell didBury];
    } else if ([actionname isEqualToString:@"repin"]) { // 收藏
        self.cellFrame.model.group.user_repin = 1;
    } else if ([actionname isEqualToString:@"unrepin"]) { // 取消收藏
        self.cellFrame.model.group.user_repin = 0;
        
    }
}

// 设置导航栏
- (void)setUpItems {

    // 标题
    self.navItemTitle = @"详情";
    
    // 举报
    WeakSelf(weakSelf);
    [self nh_setUpNavRightItemTitle:@"举报" handle:^(NSString *rightItemTitle) {
        NHDynamicDetailReportViewController *report = [[NHDynamicDetailReportViewController alloc] init];
        NHBaseNavigationViewController *nav = [[NHBaseNavigationViewController alloc] initWithRootViewController:report];
        [weakSelf presentVc:nav];
    }];
}

// 设置子视图
- (void)setUpViews {
    self.needCellSepLine = YES;
    self.sepLineColor = kSeperatorColor;
}

#pragma mark - UITableViewDelegate
- (NSInteger)nh_numberOfSections {
    if (self.topDataArray.count) {
        return 3;
    }
    return 2;
}

- (NSInteger)nh_numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (self.topDataArray.count) {
        if (section == 1) {
            return self.topDataArray.count;
        } else if (section == 2) {
            return self.dataArray.count;
        }
    } else {
        if (section == 1) {
            return self.dataArray.count;
        }
    }
    return 0;
}

- (NHBaseTableViewCell *)nh_cellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        // 1. 创建cell
        NHHomeTableViewCell *cell = [NHHomeTableViewCell cellWithTableView:self.tableView];
        
        // 2. 设置数据
        [cell setCellFrame:self.cellFrame isDetail:YES];
        cell.delegate = self;
        
        // 3. 返回cell
        return cell;
    }
    
    // 三个section
    NHDynamicDetailCommentTableViewCell *cell = [NHDynamicDetailCommentTableViewCell cellWithTableView:self.tableView];
    cell.delegate = self;
    if (self.topDataArray.count) {
        if (indexPath.section == 1) {
            cell.cellFrame = self.topCommentCellFrameArray[indexPath.row];
        } else {
            cell.cellFrame = self.commentCellFrameArray[indexPath.row];
        }
    } else {
        if (indexPath.section == 1) {
            cell.cellFrame = self.commentCellFrameArray[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)nh_cellheightAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.cellFrame.cellHeight;
    }
    if (self.topDataArray.count) {
        if (indexPath.section == 1) {
            NHDynamicDetailCommentCellFrame *cellFrame = self.topCommentCellFrameArray[indexPath.row];
            return cellFrame.cellHeight;
        } else if (indexPath.section == 2) {
            NHDynamicDetailCommentCellFrame *cellFrame = self.commentCellFrameArray[indexPath.row];
            return cellFrame.cellHeight;
        }
    } else {
        if (indexPath.section == 1) {
            NHDynamicDetailCommentCellFrame *cellFrame = self.commentCellFrameArray[indexPath.row];
            return cellFrame.cellHeight;
        }
    }
    return 0;
}

- (CGFloat)nh_sectionHeaderHeightAtSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 40;
}

- (UIView *)nh_headerAtSection:(NSInteger)section {
    
    if (section == 0) {
        return [UIView new];
    }
    NHHomeAttentionListSectionHeaderView *headerView = [NHHomeAttentionListSectionHeaderView headerFooterViewWithTableView:self.tableView];
    headerView.tipL.backgroundColor = kWhiteColor;
    headerView.textColor = kCommonHighLightRedColor;
    if (self.topDataArray.count) {
        if (section == 1) {
            headerView.tipText = @"热门评论";
        } else if (section == 2) {
            headerView.tipText = @"新鲜评论";
        }
    } else {
        if (section == 1) {
            headerView.tipText = @"新鲜评论";
        }
    }
    return headerView;
}

#pragma mark - NHHomeTableViewCellDelegate
- (void)homeTableViewCellDidClickCategory:(NHHomeTableViewCell *)cell {
    NHHomeServiceDataElement *element = self.cellFrame.model;
    NHDiscoverTopicViewController *controller = [[NHDiscoverTopicViewController alloc] initWithCatogoryId:element.group.ID];
    [self pushVc:controller];
}

- (void)homeTableViewCell:(NHHomeTableViewCell *)cell didClickImageView:(UIImageView *)imageView currentIndex:(NSInteger)currentIndex urls:(NSArray<NSURL *> *)urls {
    
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photoArray = [NSMutableArray new];
    for (NSURL *imageURL in urls) {
        MJPhoto *photo = ({
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = imageURL;
            photo.srcImageView = imageView;
            photo;
        });
        [photoArray addObject:photo];
    }
    photoBrowser.photos = photoArray;
    photoBrowser.currentPhotoIndex = currentIndex;
    [photoBrowser show];
}

- (void)homeTableViewCell:(NHHomeTableViewCell *)cell didClickItemWithType:(NHHomeTableViewCellItemType)itemType {
    
    WeakSelf(weakSelf);
    switch (itemType) {
        case NHHomeTableViewCellItemTypeLike: {
            [self requestActionWithActionname:@"digg"];
        } break;
            
        case NHHomeTableViewCellItemTypeDontLike: {
            
            [self requestActionWithActionname:@"bury"];
        } break;
            
        case NHHomeTableViewCellItemTypeComment:
            
            break;
            
        case NHHomeTableViewCellItemTypeShare: {
            NHHomeNeiHanShareView *share = [NHHomeNeiHanShareView shareViewWithType:NHHomeNeiHanShareViewTypeShowCopyAndCollect hasRepinFlag:self.cellFrame.model.group.user_repin];
            [share showInView:self.view];
            [share setUpItemClickHandle:^(NHHomeNeiHanShareView *shareView, NSString *title, NSInteger index, NHNeiHanShareType shareType) {
                [[NHNeiHanShareManager sharedManager] shareWithSharedType:shareType image:nil url:@"www.baidu.com" content:@"不错" controller:weakSelf];
            }];
            WeakSelf(weakSelf);
            [share setUpBottomItemClickHandle:^(NHHomeNeiHanShareView *shareView, NSString *title, NSInteger index) {
                
                switch (index) {
                    case 0: {
                        NSString *shareUrl = weakSelf.cellFrame.model.group.share_url;
                        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                        pasteboard.string = shareUrl;
                        [MBProgressHUD showSuccess:@"已复制" toView:self.view];
                    } break;
                        
                    case 1: {
                        [weakSelf requestActionWithActionname:weakSelf.cellFrame.model.group.user_repin ? @"unrepin" : @"repin"];
                    } break;
                        
                    case 2: {
                        NHDynamicDetailReportViewController *controller = [[NHDynamicDetailReportViewController alloc] init];
                        NHBaseNavigationViewController *nav = [[NHBaseNavigationViewController alloc] initWithRootViewController:controller];
                        [weakSelf presentVc:nav];
                    } break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)homeTableViewCell:(NHHomeTableViewCell *)cell gotoPersonalCenterWithUserInfo:(NHNeiHanUserInfoModel *)userInfoModel {
    NHPersonalCenterViewController *controller = [[NHPersonalCenterViewController alloc] initWithUserInfoModel:userInfoModel];
    [self pushVc:controller];
}

#pragma mark - NHDynamicDetailCommentTableViewCellDelegate
- (void)commentTableViewCell:(NHDynamicDetailCommentTableViewCell *)commentCell didClickUserNameWithCommentModel:(NHHomeServiceDataElementComment *)comment {
    NHPersonalCenterViewController *personalCenter = [[NHPersonalCenterViewController alloc] initWithUserId:comment.user_id];
    [self pushVc:personalCenter];
}

- (NSMutableArray *)commentCellFrameArray {
    if (!_commentCellFrameArray) {
        _commentCellFrameArray = [NSMutableArray new];
    }
    return _commentCellFrameArray;
}

- (NSMutableArray *)topDataArray {
    if (!_topDataArray) {
        _topDataArray = [NSMutableArray new];
    }
    return _topDataArray;
}

- (NSMutableArray *)topCommentCellFrameArray {
    if (!_topCommentCellFrameArray) {
        _topCommentCellFrameArray = [NSMutableArray new];
    }
    return _topCommentCellFrameArray;
}
@end
