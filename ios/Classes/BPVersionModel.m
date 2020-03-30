//
//  BPVersionModel.m
//  AFNetworking
//
//  Created by sclea on 2020/3/28.
//

#import "BPVersionModel.h"
#import <MJExtension/MJExtension.h>
@implementation BPVersionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description"};
}
@end
