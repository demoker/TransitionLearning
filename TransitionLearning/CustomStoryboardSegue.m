//
//  CustomStoryboardSegue.m
//  TransitionLearning
//
//  Created by demoker on 16/4/4.
//  Copyright © 2016年 demoker. All rights reserved.
//

#import "CustomStoryboardSegue.h"

@implementation CustomStoryboardSegue
- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination{
    UIStoryboard * board = [UIStoryboard storyboardWithName:identifier bundle:[NSBundle bundleForClass:self.class]];
    
    id init = [board instantiateInitialViewController];
    return [super initWithIdentifier:identifier source:source destination:init];
}

- (void)perform{
    //
    [self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
}
@end
