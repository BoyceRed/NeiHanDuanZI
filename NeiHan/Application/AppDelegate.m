//
//  AppDelegate.m
//  NeiHan
//
//  Created by Charles on 16/8/30.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "AppDelegate.h"
#import "NHLaunchAdvertiseMentView.h"
#import "NHMainTabbarViewController.h"
#import "NHLaunchAdvertiseMentRequest.h"
#import "NHLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UMSocialSnsService.h"
#import <UMSocialData.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "YYWebImageManager.h"
#import "YYDiskCache.h"
#import "YYMemoryCache.h"
#import "NHNeiHanShareManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    
    [[NHNeiHanShareManager sharedManager] registerAllPlatForms];
    [AMapServices sharedServices].apiKey = @"ed78efbeface6d3dc1a04a6cd0f82f75";
    [[NHLocationManager sharedManager] startSerialLocation];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    NHMainTabbarViewController *tabbar = [[NHMainTabbarViewController alloc] init];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
    //    NHLaunchAdvertiseMentRequest *request = [NHLaunchAdvertiseMentRequest nh_request];
    //    request.nh_url = @"http://lf.snssdk.com/service/12/app_ad/?iid=5316804410&os_version=9.3.4&os_api=18&app_name=joke_essay&channel=App%20Store&device_platform=iphone&idfa=832E262C-31D7-488A-8856-69600FAABE36&live_sdk_version=120&vid=4A4CBB9E-ADC3-426B-B562-9FC8173FDA52&openudid=cbb1d9e8770b26c39fac806b79bf263a50da6666&device_type=iPhone%206%20Plus&version_code=5.5.0&ac=WIFI&screen_width=1242&device_id=10752255605&aid=7&access=WIFI&app_name=joke_essay&carrier=%E4%B8%AD%E5%9B%BD%E8%81%94%E9%80%9A&channel=App%20Store&device_id=10752255605&device_platform=iphone&device_type=iPhone%206%20Plus&display_density=1242x2208&mcc_mnc=01&openudid=cbb1d9e8770b26c39fac806b79bf263a50da6666&os_version=9.3.4&version_code=5.5.0";
    //    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
    //        if (success) {
    //
    //            NSDictionary *dict = [[response objectForKey:@"splash"] firstObject];
    //            NSString *downloadurl = [dict objectForKey:@"download_url"];
    //            NSDictionary *imgInfo = [dict objectForKey:@"image_info"];
    //            NSArray *urllist = [imgInfo objectForKey:@"url_list"];
    //            NSDictionary *urldict = urllist.firstObject;
    //            NSString *url = [urldict objectForKey:@"url"];
    //            [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"ad_url"];
    //            [[NSUserDefaults standardUserDefaults] setObject:downloadurl forKey:@"downloadurl"];
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    //        }
    //    }];
    //
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ad_url"]) {
    //         NHLaunchAdvertiseMentView *view = [[NHLaunchAdvertiseMentView alloc] initWithFrame:self.window.bounds];
    //        [self.window addSubview:view];
    //        view.imgUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"ad_url"];
    //        view.tag = 1;
    //        WeakSelf(weakSelf);
    //        [view setUpLaunchAdvertiseMentViewCancelHandle:^{
    //            UIView *view1 = (UIView *)[weakSelf.window viewWithTag:1];
    //            [view1 removeFromSuperview];
    //        }];
    //        [view setUpLaunchAdvertiseMentViewDownloadHandle:^{
    //
    //        }];
    //
    //        [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:3.0];
    //    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return  [UMSocialSnsService handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[[YYWebImageManager sharedManager] cache].diskCache removeAllObjects];
    [[[YYWebImageManager sharedManager] cache].memoryCache removeAllObjects];
}

@end
