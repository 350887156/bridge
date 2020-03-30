#import "BridgePlugin.h"
#import "GTMBase64+Extension.h"
#import "SAMKeychain.h"
#import <UMCommon/UMCommon.h>
#import "BPNetworkManager.h"
#import "BPVersionModel.h"
#import <MJExtension/MJExtension.h>

@interface BridgePlugin()
@property (nonatomic, assign) FlutterResult saveImageResult;
@end
@implementation BridgePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bridge"
            binaryMessenger:[registrar messenger]];
  BridgePlugin* instance = [[BridgePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getVersionCode" isEqualToString:call.method]) {
        NSNumber *version = @([self _getVersion]);
        result(version);
    } else if ([@"getVersionName" isEqualToString:call.method]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        result(appVersion);
    } else if ([@"encrypt" isEqualToString:call.method]) {
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
        result(udid);
        
    } else if ([@"isSimulator" isEqualToString:call.method]) {
        
        BOOL isSimulator = TARGET_IPHONE_SIMULATOR == 1;
        result(@(isSimulator));
        
    } else if ([call.method hasPrefix:@"UMConfigure"]) {
        [self _handleUMeng:call result:result];
    } else if ([@"checkUpdate" isEqualToString:call.method]) {
        NSDictionary *parameter = call.arguments[@"parameter"];
        NSString *url = call.arguments[@"url"];
        NSLog(@"请求");
        [BPNetworkManager postWithUrl:url parameter:parameter complationBlock:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
            NSLog(@"响应%@",response);
            if (error) {
                result(@(NO));
            } else {
                NSDictionary *data = response[@"data"];
                BPVersionModel *model = [BPVersionModel mj_objectWithKeyValues:data];
                if ([model isKindOfClass:[BPVersionModel class]]) {
                    [self _showUpdateAlertController:model result:result];
                } else {
                    result(@(NO));
                }
            }
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (self.saveImageResult) {
        self.saveImageResult(@(error == nil));
    }
}
- (void)_showUpdateAlertController:(BPVersionModel *)model result:(FlutterResult)result {
    NSInteger version = [self _getVersion];
    if (model.versionCode >= version) {
        result(@(NO));
        return;
    }
    UIApplication *application = [UIApplication sharedApplication];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到新版本,立即前往更新" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:model.apkUrl];
        if (![url isKindOfClass:[NSURL class]]) {
            result(@(NO));
            return;
        }
        if (![application canOpenURL:url]) {
            result(@(NO));
            return;
        }
        if (@available(iOS 10.0, *)) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
        result(@(YES));
    }];
    [alert addAction:action];
    [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)_handleUMeng:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"UMConfigure.init" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"iOSAppKey"];
        [UMConfigure initWithAppkey:appKey channel:@"App Store"];
    } else if ([@"UMConfigure.log" isEqualToString:call.method]) {
        [UMConfigure setLogEnabled:YES];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
    
}
- (NSInteger)_getVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return appVersion.integerValue;
}
@end
