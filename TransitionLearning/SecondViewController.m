//
//  SecondViewController.m
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "SecondViewController.h"
#import "InteractiveAnimatorDelegate.h"
#import "ThirdViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) InteractiveAnimatorDelegate * delegate;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScreenEdgePanGestureRecognizer  * pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    pan.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:pan];
    
}

- (InteractiveAnimatorDelegate *)delegate{
    if(!_delegate){
        _delegate = [[InteractiveAnimatorDelegate alloc]init];
    }
    return _delegate;
}

- (void)swipe:(UIScreenEdgePanGestureRecognizer *)gesture{
    InteractiveAnimatorDelegate * animator = self.delegate;
    animator.gestureRecognizer = gesture;
    animator.targetEdge = UIRectEdgeRight;
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        ThirdViewController * third = [[ThirdViewController alloc]init];
        third.transitioningDelegate = animator;
        third.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:third animated:YES completion:nil];
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
