//
//  InteractiveAnimator.m
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "InteractiveAnimator.h"
#import "SwipeInteractiveTransition.h"

@implementation InteractiveAnimator
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return [[SwipeInteractiveTransition alloc]initWithGestureRecognizer:self.gestureRecognizer edge:self.targetEdge];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return [[SwipeInteractiveTransition alloc]initWithGestureRecognizer:self.gestureRecognizer edge:self.targetEdge];
}
@end
