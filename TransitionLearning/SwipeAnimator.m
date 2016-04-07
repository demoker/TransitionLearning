//
//  SwipeAnimator.m
//  TransitionLearning
//
//  Created by demoker on 16/4/7.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "SwipeAnimator.h"

@implementation SwipeAnimator
- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge{
    if(self = [super init]){
        _edge = targetEdge;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 2.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController * fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * containerView = [transitionContext containerView];
    
    UIView * fromView;
    UIView * toView;
    if([transitionContext respondsToSelector:@selector(viewForKey:)]){
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        fromView = fromController.view;
        toView = toController.view;
    }
    
    BOOL isPresent = (toController.presentingViewController == fromController);
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toController];
    
    CGVector offset;
    if(self.edge == UIRectEdgeRight){
        offset = CGVectorMake(-1, 0);
    }else if (self.edge == UIRectEdgeLeft){
        offset = CGVectorMake(1, 0);
    }else if (self.edge == UIRectEdgeTop){
        offset = CGVectorMake(0.f, 1.f);
    }else if (self.edge == UIRectEdgeBottom){
        offset = CGVectorMake(0.f, -1.f);
    }
    
    //设置动画之前的frame
    if (isPresent) {
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width * offset.dx * -1,
                                    toFrame.size.height * offset.dy * -1);
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
    }

    if (isPresent)
        [containerView addSubview:toView];
    else{
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    NSTimeInterval interval = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:interval animations:^{
        //设置动画之后的frame
        if(isPresent){
            toView.frame = toFrame;
        }else{
            fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width*offset.dx, fromFrame.size.height*offset.dy);
        }
    } completion:^(BOOL finished) {
        BOOL iscancel = [transitionContext transitionWasCancelled];
                if(iscancel){
                    [toView removeFromSuperview];
                }
        [transitionContext completeTransition:!iscancel];
    }];

}
@end
