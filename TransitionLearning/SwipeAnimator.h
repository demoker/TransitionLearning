//
//  SwipeAnimator.h
//  TransitionLearning
//
//  Created by demoker on 16/4/7.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SwipeAnimator : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge;
@property (assign, nonatomic) UIRectEdge edge;
@end
