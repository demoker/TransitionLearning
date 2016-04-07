//
//  DKNavcontrollerAnimator.m
//  TransitionLearning
//
//  Created by demoker on 16/4/7.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "DKNavcontrollerAnimator.h"

@implementation DKNavcontrollerAnimator
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
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
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toController];
    
    fromView.frame = fromFrame;
    toView.frame = toFrame;
    
    [containerView addSubview:toView];
    
    UIImage * fromSnapshot;
    __block UIImage * toSnapshot;
    
    BOOL isPush = [toController.navigationController.viewControllers indexOfObject:toController]>[toController.navigationController.viewControllers indexOfObject:fromController];
    
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
    [fromView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
    fromSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
        [toView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
        toSnapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    UIView * transitionContainer = [UIView new];
    transitionContainer.frame = containerView.bounds;
    transitionContainer.opaque = YES;
    transitionContainer.backgroundColor = [UIColor blackColor];
    [containerView addSubview:transitionContainer];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/900.0;
    transitionContainer.layer.sublayerTransform = t;
    //计算一个cell的大小
    CGFloat sliceSize = round(CGRectGetWidth(transitionContainer.frame)/10.0);
    NSUInteger hz_Number = ceil(CGRectGetWidth(transitionContainer.frame)/sliceSize);
    NSUInteger vi_Number = ceil(CGRectGetHeight(transitionContainer.frame)/sliceSize);
    //根据push和pop设置向量
    CGVector transformVector ;
    if(isPush){
        transformVector = CGVectorMake(CGRectGetMaxX(transitionContainer.bounds) - CGRectGetMinX(transitionContainer.bounds), CGRectGetMaxY(transitionContainer.bounds) - CGRectGetMinY(transitionContainer.bounds));
    }else{
        transformVector = CGVectorMake(CGRectGetMinX(transitionContainer.bounds)-CGRectGetMaxX(transitionContainer.bounds), CGRectGetMinY(transitionContainer.bounds) - CGRectGetMaxY(transitionContainer.bounds));
    }
    //计算转换的长度
    CGFloat transitionVectorLength = sqrt(transformVector.dx * transformVector.dx + transformVector.dy * transformVector.dy);
    //计算每单元的向量
    CGVector transfromUnitVector = CGVectorMake(transformVector.dx/transitionVectorLength, transformVector.dy/transitionVectorLength);
    
    for(NSUInteger y = 0;y < vi_Number; y++){
        for(NSUInteger x = 0;x < hz_Number; x++){
            CALayer * fromcontentLayer = [CALayer layer];
            fromcontentLayer.frame = CGRectMake(x * sliceSize * -1, y * sliceSize * -1, containerView.bounds.size.width, containerView.bounds.size.height);
            fromcontentLayer.rasterizationScale = fromSnapshot.scale;
            fromcontentLayer.contents = (__bridge id)fromSnapshot.CGImage;
            
            CALayer * tocontentLayer = [CALayer layer];
            tocontentLayer.frame = CGRectMake(x * sliceSize * -1, y * sliceSize * -1, containerView.bounds.size.width, containerView.bounds.size.height);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL wereActionDisabled = [CATransaction disableActions];
                [CATransaction setDisableActions:YES];
                
                tocontentLayer.rasterizationScale = toSnapshot.scale;
                tocontentLayer.contents = (__bridge id)toSnapshot.CGImage;
                
                [CATransaction setDisableActions:wereActionDisabled];
            });
            
            
            UIView * toCheckboardSquareView = [UIView new];
            toCheckboardSquareView.frame = CGRectMake(x*sliceSize, y*sliceSize, sliceSize, sliceSize);
            toCheckboardSquareView.opaque = NO;
            toCheckboardSquareView.layer.masksToBounds = YES;
            toCheckboardSquareView.layer.doubleSided = NO;
            toCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            [toCheckboardSquareView.layer addSublayer:tocontentLayer];
            
            UIView * fromCheckboardSquareView = [UIView new];
            fromCheckboardSquareView.frame = CGRectMake(x*sliceSize, y*sliceSize, sliceSize, sliceSize);
            fromCheckboardSquareView.opaque = NO;
            fromCheckboardSquareView.layer.masksToBounds = YES;
            fromCheckboardSquareView.layer.doubleSided = NO;
            fromCheckboardSquareView.layer.transform = CATransform3DIdentity;
            [fromCheckboardSquareView.layer addSublayer:fromcontentLayer];
            
            [transitionContainer addSubview:toCheckboardSquareView];
            [transitionContainer addSubview:fromCheckboardSquareView];
            
        }
    }
    
    const CGFloat transitionSpacing = 160.f;
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    // Used to track how many slices have animations which are still in flight.
    __block NSUInteger sliceAnimationsPending = 0;
    
    for (NSUInteger y = 0 ; y < vi_Number; y++)
    {
        for (NSUInteger x = 0; x < hz_Number; x++)
        {
            UIView *toCheckboardSquareView = transitionContainer.subviews[y * hz_Number * 2 + (x * 2)];
            UIView *fromCheckboardSquareView = transitionContainer.subviews[y * hz_Number * 2 + (x * 2 + 1)];
            
            CGVector sliceOriginVector;
            if (isPush) {
                // Define a vector from the origin of transitionContainer to the
                // top left corner of the slice.
                sliceOriginVector = CGVectorMake(CGRectGetMinX(fromCheckboardSquareView.frame) - CGRectGetMinX(transitionContainer.bounds),
                                                 CGRectGetMinY(fromCheckboardSquareView.frame) - CGRectGetMinY(transitionContainer.bounds));
            } else {
                // Define a vector from the bottom right corner of
                // transitionContainer to the bottom right corner of the slice.
                sliceOriginVector = CGVectorMake(CGRectGetMaxX(fromCheckboardSquareView.frame) - CGRectGetMaxX(transitionContainer.bounds),
                                                 CGRectGetMaxY(fromCheckboardSquareView.frame) - CGRectGetMaxY(transitionContainer.bounds));
            }
            /** 下面开始没有思考*/
            // Project sliceOriginVector onto transitionVector.
            CGFloat dot = sliceOriginVector.dx * transformVector.dx + sliceOriginVector.dy * transformVector.dy;
            CGVector projection = CGVectorMake(transfromUnitVector.dx * dot/transitionVectorLength,
                                               transfromUnitVector.dy * dot/transitionVectorLength);
            
            // Compute the length of the projection.
            CGFloat projectionLength = sqrtf( projection.dx * projection.dx + projection.dy * projection.dy );
            
            NSTimeInterval startTime = projectionLength/(transitionVectorLength + transitionSpacing) * transitionDuration;
            NSTimeInterval duration = ( (projectionLength + transitionSpacing)/(transitionVectorLength + transitionSpacing) * transitionDuration ) - startTime;
            
            sliceAnimationsPending++;
            
            [UIView animateWithDuration:duration delay:startTime options:0 animations:^{
                toCheckboardSquareView.layer.transform = CATransform3DIdentity;
                fromCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            } completion:^(BOOL finished) {
                // Finish the transition once the final animation completes.
                if (--sliceAnimationsPending == 0) {
                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    
                    [transitionContainer removeFromSuperview];
                    
                    // When we complete, tell the transition context
                    // passing along the BOOL that indicates whether the transition
                    // finished or not.
                    [transitionContext completeTransition:!wasCancelled];
                }
            }];
        }
    }
    
}
@end
