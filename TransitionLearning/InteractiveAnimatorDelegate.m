//
//  InteractiveAnimator.m
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "InteractiveAnimatorDelegate.h"
#import "SwipeInteractiveTransition.h"
#import "SwipeAnimator.h"

@implementation InteractiveAnimatorDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    SwipeAnimator * animator = [[SwipeAnimator alloc]init];
    animator.edge = self.targetEdge;
    return animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    SwipeAnimator * animator = [[SwipeAnimator alloc]init];
    animator.edge = self.targetEdge;
    return animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    if(self.gestureRecognizer){
        return [[SwipeInteractiveTransition alloc]initWithGestureRecognizer:self.gestureRecognizer edge:self.targetEdge];
    }else{
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if(self.gestureRecognizer){
        return [[SwipeInteractiveTransition alloc]initWithGestureRecognizer:self.gestureRecognizer edge:self.targetEdge];
    }else{
        return nil;
    }
}
@end
