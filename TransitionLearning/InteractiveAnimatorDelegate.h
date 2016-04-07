//
//  InteractiveAnimator.h
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<UIKit/UIKit.h>
@interface InteractiveAnimatorDelegate : NSObject<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureRecognizer;

@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end
