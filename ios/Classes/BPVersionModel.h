//
//  BPVersionModel.h
//  AFNetworking
//
//  Created by sclea on 2020/3/28.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface BPVersionModel : NSObject
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSInteger versionCode;
@property (nonatomic, copy) NSString *apkUrl;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *platform;
@end

NS_ASSUME_NONNULL_END
