//
//  ThirdViewController.m
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "ThirdViewController.h"
#import "SecondViewController.h"
#import "InteractiveAnimatorDelegate.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScreenEdgePanGestureRecognizer  * pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
}

- (void)swipe:(UIScreenEdgePanGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        InteractiveAnimatorDelegate * animator = self.transitioningDelegate;
        animator.gestureRecognizer = gesture;
        animator.targetEdge = UIRectEdgeLeft;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
