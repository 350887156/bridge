//
//  GTMBase64+Extension.h
//  Movies
//
//  Created by 李少川 on 2019/10/30.
//  Copyright © 2019 Movies. All rights reserved.
//


#import <GTMBase64/GTMBase64.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTMBase64 (Extension)
+ (NSString *)decryptWithText:(NSString *)sText  forKey:(NSString*) key;
+ (NSString *)encryptWithText:(NSString *)sText forKey:(NSString*) key;
@end

NS_ASSUME_NONNULL_END
