//
//  SimplePresentedAnimator.m
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "SimplePresentedAnimator.h"

@implementation SimplePresentedAnimator
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * containerView = [transitionContext containerView];
    
    UIView * fromView;
    UIView * toView;
    if([transitionContext respondsToSelector:@selector(viewForKey:)]){
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        fromView = from.view;
        toView = to.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:from];
    toView.frame = [transitionContext finalFrameForViewController:to];
    
    fromView.alpha = 1.0;
    toView.alpha = 0.0;
    
    [containerView addSubview:toView];
    
    NSTimeInterval interval = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:interval animations:^{
        fromView.alpha = 0.0;
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        BOOL cancel = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancel];
    }];
}
@end
