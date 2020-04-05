//
//  BPUpdateDialogContainer.m
//  Runner
//
//  Created by sclea on 2020/4/4.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "BPUpdateDialogContainer.h"
#import <Masonry/Masonry.h>
@interface BPUpdateDialogContainer ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *cancelButton;
@end
@implementation BPUpdateDialogContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.size.offset(35);
    }];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-10);
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"发现新版本";
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.9);
    }];
    UIButton *actionButton = [[UIButton alloc] init];
    [actionButton addTarget:self action:@selector(didClickActionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setImage:[UIImage imageNamed:@"update_btn"] forState:UIControlStateNormal];
    [self addSubview:actionButton];
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).offset(20);
        make.right.equalTo(imageView).offset(-20);
        make.bottom.equalTo(imageView).offset(-20);
        make.height.offset(44);
    }];
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(actionButton).offset(20);
        make.right.equalTo(actionButton).offset(-20);
        make.bottom.equalTo(actionButton.mas_top).offset(-10);
    }];
    
}
- (void)setShowCancelButton:(BOOL)showCancelButton
{
    _showCancelButton = showCancelButton;
    self.cancelButton.hidden = !showCancelButton;
}
- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    self.textView.text = desc;
}
- (void)didClickCancelButtonAction
{
    if ([self.delegate respondsToSelector:@selector(updateDialogContainerDidClickCancel:)]) {
        [self.delegate updateDialogContainerDidClickCancel:self];
    }
}
- (void)didClickActionButtonAction
{
    UIApplication *application = [UIApplication sharedApplication];
    if (!self.downloadURL.length) return;
    NSURL *url = [NSURL URLWithString:self.downloadURL];
    if (@available(iOS 10.0, *)) {
        [application openURL:url options:@{} completionHandler:nil];
    } else {
        [application openURL:url];
    }
}
- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton addTarget:self action:@selector(didClickCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.textColor = [UIColor darkGrayColor];
    }
    return _textView;
}
@end
