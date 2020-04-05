//
//  BPUpdateDialog.h
//  bridge
//
//  Created by sclea on 2020/4/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPUpdateDialog : UIViewController
@property (nonatomic, assign) BOOL showCancelButton;
@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *desc;
+ (void)showDialogWithDesc:(NSString *)desc
          showCancelButton:(BOOL)showCancelButton
               downloadURL:(NSString *)downloadURL;
@end

NS_ASSUME_NONNULL_END
