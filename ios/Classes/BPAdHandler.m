//
//  BPAdHandler.m
//  bridge
//
//  Created by sclea on 2020/3/30.
//

#import "BPAdHandler.h"
//#import <GDTMobSDK/GDTSplashAd.h>
//#import <GDTMobSDK/GDTRewardVideoAd.h>
@interface BPAdHandler ()
//<
//GDTRewardedVideoAdDelegate,
//GDTSplashAdDelegate
//>
//@property (nonatomic, strong) FlutterMethodChannel *channel;
//@property (nonatomic, strong) GDTSplashAd *splashAd;
//@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
//@property (nonatomic, copy) FlutterResult rewardVideoAdResult;
//@property (nonatomic, copy) FlutterResult splashAdResult;
@end
@implementation BPAdHandler
- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)flutterMethodChannel
{
    if (self = [super init]) {
//        self.channel = flutterMethodChannel;
    }
    return self;
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    /*
    NSString *appId = call.arguments[@"appId"];
    NSString *placementId = call.arguments[@"placementId"];
    if (!appId.length || !placementId.length) return;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([call.method hasSuffix:@".aplashAd"]) {
        self.splashAd = [[GDTSplashAd alloc] initWithAppId:appId placementId:placementId];
        self.splashAd.delegate = self;
        self.splashAdResult = result;
        [self.splashAd loadAdAndShowInWindow:window];
        
    } else if([call.method hasSuffix:@".preloadSplash"]) {
        
        [GDTSplashAd preloadSplashOrderWithAppId:appId placementId:placementId];
        result(@(YES));
        
    } else if ([call.method hasSuffix:@".rewardVideoAd"]) {
        self.rewardVideoAdResult = result;
        self.rewardVideoAd = nil;
        self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:appId placementId:placementId];
        self.rewardVideoAd.delegate = self;
        [self.rewardVideoAd loadAd];
    } else {
        result(FlutterMethodNotImplemented);
    }
     */
}

//#pragma mark - GDTRewardedVideoAdDelegate
//- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
//{
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.rewardVideoAd showAdFromRootViewController:rootViewController];
//}
//
//
///**
// 视频广告播放达到激励条件回调
//
// @param rewardedVideoAd GDTRewardVideoAd 实例
// */
//- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
//{
//    if (self.rewardVideoAdResult) {
//        self.rewardVideoAdResult(@(YES));
//    }
//    self.rewardVideoAd = nil;
//}
///**
// 视频广告各种错误信息回调
//
// @param rewardedVideoAd GDTRewardVideoAd 实例
// @param error 具体错误信息
// */
//- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
//{
//    if (self.rewardVideoAdResult) {
//        self.rewardVideoAdResult(@(NO));
//    }
//    self.rewardVideoAd = nil;
//}
//
//
//#pragma mark - GDTSplashAdDelegate
///**
// *  开屏广告展示失败
// */
//- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
//{
//    if (self.splashAdResult) {
//        self.splashAdResult(@(NO));
//    }
//}
///**
// *  开屏广告关闭回调
// */
//- (void)splashAdClosed:(GDTSplashAd *)splashAd
//{
//    if (self.splashAdResult) {
//        self.splashAdResult(@(YES));
//    }
//}
///**
// *  点击以后全屏广告页将要关闭
// */
//- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
//{
//    if (self.splashAdResult) {
//        self.splashAdResult(@(YES));
//    }
//}


@end
