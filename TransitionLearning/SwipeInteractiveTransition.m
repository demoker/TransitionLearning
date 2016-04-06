//
//  SwipeInteractiveTransition.m
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "SwipeInteractiveTransition.h"

@interface SwipeInteractiveTransition ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (retain, nonatomic) UIScreenEdgePanGestureRecognizer * gesture;
@property (assign, nonatomic) UIRectEdge edge;
@property (nonatomic, readwrite) CGPoint initialLocationInContainerView;
@property (nonatomic, readwrite) CGPoint initialTranslationInContainerView;
@end

@implementation SwipeInteractiveTransition
- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan edge:(UIRectEdge)edge{
    if(self = [super init]){
        _gesture = pan;
        _edge = edge;
        [_gesture addTarget:self action:@selector(update:)];
    }
    return self;
}

- (void)dealloc{
    [self.gesture removeTarget:self action:@selector(update:)];
}

- (CGFloat)percentForGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    UIView * container = [self.transitionContext containerView];
    
    CGPoint point = [gesture locationInView:container];
    
    CGFloat width = CGRectGetWidth(container.bounds);
    CGFloat height = CGRectGetHeight(container.bounds);
    
    if(self.edge == UIRectEdgeRight){
        return (width - point.x)/width;
    }else if (self.edge == UIRectEdgeLeft){
        return point.x/width;
    }else{
        return 0;
    }
}

- (void)update:(UIScreenEdgePanGestureRecognizer *)pan{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:[self percentForGesture:self.gesture]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if([self percentForGesture:self.gesture]>=0.5){
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
        }
            break;
            
        default:
            [self cancelInteractiveTransition];
            break;
    }
}

#pragma mark - 
- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    self.initialLocationInContainerView = [self.gesture locationInView:transitionContext.containerView];
    self.initialTranslationInContainerView = [self.gesture locationInView:transitionContext.containerView];
}


@end
