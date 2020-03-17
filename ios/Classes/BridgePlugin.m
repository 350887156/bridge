#import "BridgePlugin.h"
#import "GTMBase64+Extension.h"
#import "SAMKeychain.h"
#import <UMCommon/UMCommon.h>
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
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSNumber *version = @(appVersion.integerValue);
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
        [self handleUMeng:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (void)handleUMeng:(FlutterMethodCall*)call result:(FlutterResult)result {
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

@end
