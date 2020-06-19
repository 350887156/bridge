#import "BridgePlugin.h"
#import "GTMBase64+Extension.h"
#import "SAMKeychain.h"
//#import <UMCommon/UMCommon.h>
#import <sys/utsname.h>
@interface BridgePlugin()
@property (nonatomic, assign) FlutterResult saveImageResult;
@property (nonatomic, strong) NSDictionary *deviceInfo;
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
    }
    else {
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
//        NSString *appKey = call.arguments[@"iOSAppKey"];
//        [UMConfigure initWithAppkey:appKey channel:@"App Store"];
    } else if ([@"UMConfigure.log" isEqualToString:call.method]) {
//        [UMConfigure setLogEnabled:YES];
    }
    else {
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
