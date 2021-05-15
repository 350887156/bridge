#import "BridgePlugin.h"
#import "GTMBase64+Extension.h"
#import "SAMKeychain.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <sys/utsname.h>
#import <ATAuthSDK/ATAuthSDK.h>
#import <YTXOperators/YTXOperators.h>
#import "AliAuthPluginUtil.h"
#import "AliAuthCustomUIUtil.h"
static NSTimeInterval const kTimerOut = 5000;
static NSString * const kAliAuthPluginBasicMessageChannelKey = @"com.lajiaoyang.ali_auth.BasicMessageChannel";
@interface BridgePlugin()
@property (nonatomic, assign) FlutterResult saveImageResult;
@property (nonatomic, strong) NSDictionary *deviceInfo;
@property (nonatomic, strong) FlutterBasicMessageChannel *channel;
@end
@implementation BridgePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bridge"
            binaryMessenger:[registrar messenger]];
  BridgePlugin* instance = [[BridgePlugin alloc] initWithBinaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
}
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
{
    self = [super init];
    if (self) {
        self.channel = [FlutterBasicMessageChannel messageChannelWithName:kAliAuthPluginBasicMessageChannelKey binaryMessenger:messenger];
    }
    return self;
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    __weak typeof(self) weakSelf = self;
    if ([@"encrypt" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        NSString *target = call.arguments[@"target"];
        if ([target isKindOfClass:[NSString class]] && target.length && [key isKindOfClass:[NSString class]] && key.length) {
            result([GTMBase64 encryptWithText:target forKey:key]);
        }
    } else if ([@"decrypt" isEqualToString:call.method]) {
        NSString *key = call.arguments[@"key"];
        NSString *target = call.arguments[@"target"];
        if ([target isKindOfClass:[NSString class]] && target.length && [key isKindOfClass:[NSString class]] && key.length) {
            result([GTMBase64 decryptWithText:target forKey:key]);
        }
    } else if ([@"getUDID" isEqualToString:call.method]) {
        NSString *udid = [self _getUDID];
        if (udid.length) {
            result(udid);
        }
        
    } else if ([@"isSimulator" isEqualToString:call.method]) {
        
        BOOL isSimulator = TARGET_IPHONE_SIMULATOR == 1;
        result(@(isSimulator));
        
    } else if ([call.method hasPrefix:@"UMConfigure"]) {
        [self _handleUMeng:call result:result];
    } else if ([@"init_ali_auth" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"appKey"];
        [[TXCommonHandler sharedInstance] setAuthSDKInfo:appKey complete:^(NSDictionary * _Nonnull resultDic) {
            result(resultDic);
        }];
    } else if ([@"pre" isEqualToString:call.method]) {
        [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:kTimerOut complete:^(NSDictionary * _Nonnull resultDic) {
            result(resultDic);
        }];
    } else if ([@"login" isEqualToString:call.method]) {
        UIViewController *controller = [AliAuthPluginUtil findCurrentViewController];
        TXCustomModel *model = [AliAuthCustomUIUtil handle:call.arguments];
        [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:kTimerOut controller:controller model:model complete:^(NSDictionary * _Nonnull resultDic) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.channel sendMessage:resultDic];
        }];
    } else if ([@"debugLogin" isEqualToString:call.method]) {
        UIViewController *controller = [AliAuthPluginUtil findCurrentViewController];
        TXCustomModel *model = [AliAuthCustomUIUtil handle:call.arguments];
        [[TXCommonHandler sharedInstance] debugLoginUIWithController:controller model:model complete:^(NSDictionary * _Nonnull resultDic) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.channel sendMessage:resultDic];
        }];
    } else if ([@"checkEnvAvailable" isEqualToString:call.method]) {
        
        [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
            result(resultDic);
        }];
    } else if ([@"accelerateVerify" isEqualToString:call.method]) {
        [[TXCommonHandler sharedInstance] accelerateVerifyWithTimeout:kTimerOut complete:^(NSDictionary * _Nonnull resultDic) {
            result(resultDic);
        }];
        
    } else if ([@"checkDeviceCellularDataEnable" isEqualToString:call.method]) {
        BOOL enable = [TXCommonUtils checkDeviceCellularDataEnable];
        result(@(enable));
    } else if ([@"simSupportedIsOK" isEqualToString:call.method]) {
        BOOL sim = [TXCommonUtils simSupportedIsOK];
        result(@(sim));
    } else if ([@"cancelLogin" isEqualToString:call.method]){
        [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        result(@(YES));
    } else if ([@"getCurrentCarrierName" isEqualToString:call.method]) {
        NSString *name = [TXCommonUtils getCurrentCarrierName];
        result(name);
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (self.saveImageResult) {
        self.saveImageResult(@(error == nil));
    }
}
- (void)_handleUMeng:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"UMConfigure.init" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"iOSAppKey"];
        [UMConfigure initWithAppkey:appKey channel:@"App Store"];
    } else if ([@"UMConfigure.log" isEqualToString:call.method]) {
        [UMConfigure setLogEnabled:YES];
    } else if ([@"UMConfigure.onPageStart" isEqualToString:call.method]) {
        NSString *pageName = call.arguments[@"pageName"];
        [MobClick beginLogPageView:pageName];
    } else if ([@"UMConfigure.onPageEnd" isEqualToString:call.method]) {
        NSString *pageName = call.arguments[@"pageName"];
        [MobClick endLogPageView:pageName];
    } else if ([@"UMConfigure.pageManual" isEqualToString:call.method]) {
        [MobClick setAutoPageEnabled:NO];
    } else {
        result(FlutterMethodNotImplemented);
    }
    
}
- (NSString *)_getUDID {
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    NSString *udid = [SAMKeychain passwordForService:bundleIdentifier account:bundleIdentifier];
    if (!udid.length) {
        udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.account = bundleIdentifier;
        query.password = udid;
        query.service = bundleIdentifier;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:nil];
    }
    return udid;
}

@end
