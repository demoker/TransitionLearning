//
//  ViewController.m
//  TransitionLearning
//
//  Created by demoker on 16/4/4.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "FourViewController.h"
#import "TabbarTransitionDelegate.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mtableView;
@property (retain, nonnull) NSArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataArray = @[@"simplePresented",@"swipe",@"nav",@"tabbar"];
    
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        FirstViewController * first = [[FirstViewController alloc]init];
        [self presentViewController:first animated:YES completion:nil];
    }else if (indexPath.row == 1){
        SecondViewController * second = [[SecondViewController alloc]init];
        [self presentViewController:second animated:YES completion:nil];
    }else if (indexPath.row == 2){
        FourViewController * four = [[FourViewController alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:four];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        TabbarTransitionDelegate * delegate = [[TabbarTransitionDelegate alloc]init];
        UITabBarController * tabbarVC = [[UITabBarController alloc]init];
        
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * colors = @[[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor yellowColor]];
        for(int i = 0;i<4;i++){
            FirstViewController * first = [[FirstViewController alloc]init];
            first.view.backgroundColor =colors[i];
            first.title = [NSString stringWithFormat:@"vc%d",i];
            [arr addObject:first];
        }
        tabbarVC.viewControllers = arr;
        delegate.mtabbarController = tabbarVC;
        [self presentViewController:tabbarVC animated:YES completion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITransition
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
}

#pragma mark -storyboard跳转动画

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender{

}


@end
