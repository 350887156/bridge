//
//  BPAdHandler.h
//  bridge
//
//  Created by sclea on 2020/3/30.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface BPAdHandler : NSObject
- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)flutterMethodChannel;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
