//
//  BPNetworkManager.m
//  AFNetworking
//
//  Created by sclea on 2020/3/27.
//

#import "BPNetworkManager.h"

@interface BPNetworkManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end
@implementation BPNetworkManager
static BPNetworkManager *_instance;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.sessionManager = [AFHTTPSessionManager manager];
        _instance.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return _instance;
}
+ (void)postWithUrl:(NSString *)url
          parameter:(NSDictionary *)parameter
    complationBlock:(BPNetworkManagerComplationBlock)complationBlock
{
    [[BPNetworkManager sharedManager].sessionManager POST:url parameters:parameter headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complationBlock) {
            complationBlock(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complationBlock) {
            complationBlock(nil,error);
        }
    }];

}
@end
