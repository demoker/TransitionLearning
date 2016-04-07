//
//  TabbarTransitionDelegate.m
//  TransitionLearning
//
//  Created by demoker on 16/4/7.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "TabbarTransitionDelegate.h"
#import "AAPLSlideTransitionInteractionController.h"
#import <objc/runtime.h>
#import "AAPLSlideTransitionAnimator.h"
@interface TabbarTransitionDelegate ()
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end
const char * AAPLSlideTabBarControllerDelegateAssociationKey = "AAPLSlideTabBarControllerDelegateAssociationKey";
@implementation TabbarTransitionDelegate

- (void)setMtabbarController:(UITabBarController *)mtabbarController{
    if(_mtabbarController != mtabbarController){
        objc_setAssociatedObject(_mtabbarController, AAPLSlideTabBarControllerDelegateAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [_mtabbarController.view removeGestureRecognizer:self.panGestureRecognizer];
        if (_mtabbarController.delegate == self) _mtabbarController.delegate = nil;
        
        
        _mtabbarController = mtabbarController;
        _mtabbarController.delegate = self;
        [_mtabbarController.view addGestureRecognizer:self.panGestureRecognizer];
        
        
        objc_setAssociatedObject(_mtabbarController, AAPLSlideTabBarControllerDelegateAssociationKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIPanGestureRecognizer *)panGestureRecognizer{
    if(!_panGestureRecognizer){
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    }
    return _panGestureRecognizer;
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)
        [self beginInteractiveTransitionIfPossible:pan];
}

- (void)beginInteractiveTransitionIfPossible:(UIPanGestureRecognizer *)pan{
    CGPoint translation = [pan translationInView:self.mtabbarController.view];
    if(translation.x>0 && self.mtabbarController.selectedIndex>0){
        self.mtabbarController.selectedIndex--;
    }else if (translation.x<0 && self.mtabbarController.selectedIndex + 1<self.mtabbarController.viewControllers.count){
        self.mtabbarController.selectedIndex++;
    }else{
        if(!CGPointEqualToPoint(translation, CGPointZero)){
            pan.enabled = NO;
            pan.enabled = YES;
        }
    }
    
    [self.mtabbarController.transitionCoordinator animateAlongsideTransition:NULL completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if([context isCancelled] && pan.state == UIGestureRecognizerStateChanged){
            [self beginInteractiveTransitionIfPossible:pan];
        }
    }];
}

#pragma mark - 
- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController     NS_AVAILABLE_IOS(7_0){
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return [[AAPLSlideTransitionInteractionController alloc] initWithGestureRecognizer:self.panGestureRecognizer];
    }else{
        return nil;
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    
    NSArray *viewControllers = tabBarController.viewControllers;
    
    if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
        // The incoming view controller succeeds the outgoing view controller,
        // slide towards the left.
        return [[AAPLSlideTransitionAnimator alloc] initWithTargetEdge:UIRectEdgeLeft];
    } else {
        // The incoming view controller precedes the outgoing view controller,
        // slide towards the right.
        return [[AAPLSlideTransitionAnimator alloc] initWithTargetEdge:UIRectEdgeRight];
    }
}

@end
