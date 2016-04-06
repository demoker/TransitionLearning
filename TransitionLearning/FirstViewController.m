//
//  FirstViewController.m
//  TransitionLearning
//
//  Created by demoker on 16/4/6.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "FirstViewController.h"
#import "SimplePresentedAnimator.h"
#import "LastViewController.h"

@interface FirstViewController ()<UIViewControllerTransitioningDelegate>
- (IBAction)firstAction:(id)sender;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - 转场delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [SimplePresentedAnimator new];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [SimplePresentedAnimator new];
}


- (IBAction)firstAction:(id)sender {
    LastViewController * last = [[LastViewController alloc]init];
    last.transitioningDelegate = self;
    last.modalPresentationStyle =UIModalPresentationFullScreen;
    [self presentViewController:last animated:YES completion:nil];
}
@end
