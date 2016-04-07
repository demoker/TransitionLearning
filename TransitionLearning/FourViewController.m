//
//  FourViewController.m
//  TransitionLearning
//
//  Created by demoker on 16/4/7.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "FourViewController.h"
#import "DKNavcontrollerAnimator.h"
#import "FiveViewController.h"

@interface FourViewController ()<UINavigationControllerDelegate>

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.delegate = self;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn setFrame:CGRectMake(0, 0, 100, 30)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UINavgationDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    return [[DKNavcontrollerAnimator alloc]init];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)push:(id)sender {
    FiveViewController * five = [[FiveViewController alloc]init];
    [self.navigationController pushViewController:five animated:YES];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
