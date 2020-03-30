//
//  BPNetworkManager.h
//  AFNetworking
//
//  Created by sclea on 2020/3/27.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^BPNetworkManagerComplationBlock)(NSDictionary * _Nullable response,NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface BPNetworkManager : NSObject
+ (void)postWithUrl:(NSString *)url
          parameter:(NSDictionary *)parameter
       complationBlock:(BPNetworkManagerComplationBlock)complationBlock;
@end

NS_ASSUME_NONNULL_END
