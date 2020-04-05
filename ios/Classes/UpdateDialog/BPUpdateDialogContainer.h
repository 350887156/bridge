//
//  BPUpdateDialogContainer.h
//  Runner
//
//  Created by sclea on 2020/4/4.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BPUpdateDialogContainer;
@protocol BPUpdateDialogContainerDelegate <NSObject>
- (void)updateDialogContainerDidClickCancel:(BPUpdateDialogContainer *_Nullable)view;
@end
NS_ASSUME_NONNULL_BEGIN

@interface BPUpdateDialogContainer : UIView

@property(nonatomic, weak) id <BPUpdateDialogContainerDelegate>delegate;
@property (nonatomic, assign) BOOL showCancelButton;
@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *desc;
@end

NS_ASSUME_NONNULL_END
