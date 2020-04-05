//
//  BPUpdateDialog.m
//  bridge
//
//  Created by sclea on 2020/4/4.
//

#import "BPUpdateDialog.h"
#import "BPTransitionAnimation.h"
#import "BPUpdateDialogContainer.h"
#import <pop/POP.h>
#import <Masonry/Masonry.h>
@interface BPUpdateDialog ()
<
UIViewControllerTransitioningDelegate,
BPUpdateDialogContainerDelegate
>
@property (nonatomic, strong) BPUpdateDialogContainer *containerView;
@end
@implementation BPUpdateDialog

+ (void)showDialogWithDesc:(NSString *)desc
              showCancelButton:(BOOL)showCancelButton
               downloadURL:(NSString *)downloadURL
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    BPUpdateDialog *dialog = [[BPUpdateDialog alloc] init];
    dialog.showCancelButton = showCancelButton;
    dialog.desc = desc;
    dialog.downloadURL = downloadURL;
    [rootVC presentViewController:dialog animated:YES completion:nil];
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [BPTransitionAnimation new];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(1.2);
        make.centerY.equalTo(self.view).offset(- self.view.frame.size.height);
    }];
    [self.view layoutIfNeeded];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showContainerView:YES complation:nil];
}
- (void)showContainerView:(BOOL)show complation:(void(^)(void))complation
{
    self.containerView.alpha = 1;
    POPSpringAnimation *sp = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    sp.springBounciness = 12;
    
    if (show)
    {
        sp.toValue = @(self.view.center);
    }
    else
    {
        sp.springSpeed = 0.1;
        sp = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sp.toValue = @(CGSizeMake(0, 0));
    }
    [self.containerView pop_addAnimation:sp forKey:nil];
    sp.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (complation)
        {
            complation();
        }
    };
}
#pragma mark - BPUpdateDialogContainerDelegate
- (void)updateDialogContainerDidClickCancel:(BPUpdateDialogContainer *)view
{
    __weak __typeof__(self) weakSelf = self;
    [self showContainerView:NO complation:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [BPTransitionAnimation new];
}
- (BPUpdateDialogContainer *)containerView
{
    if (!_containerView) {
        _containerView = [[BPUpdateDialogContainer alloc] init];
        _containerView.alpha = 0;
        _containerView.delegate = self;
        _containerView.downloadURL = self.downloadURL;
        _containerView.showCancelButton = self.showCancelButton;
        _containerView.desc = self.desc;
    }
    return _containerView;
}
- (void)dealloc{
    
}
@end
