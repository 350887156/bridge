//
//  BPTransitionAnimation.m
//  AFNetworking
//
//  Created by sclea on 2020/4/4.
//

#import "BPTransitionAnimation.h"

@implementation BPTransitionAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (toVC.isBeingPresented) {
        [self transitionAnimationPush:transitionContext];
    } else {
        [self transitionAnimationPop:transitionContext];
    }
}
- (void)transitionAnimationPush:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    toVC.view.frame = [UIScreen mainScreen].bounds;
    toVC.view.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
- (void)transitionAnimationPop:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    fromVC.view.frame = [UIScreen mainScreen].bounds;
    fromVC.view.alpha = 1;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end
