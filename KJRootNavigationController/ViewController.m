//
//  ViewController.m
//  KJRootNavigationController
//
//  Created by coder on 2017/7/29.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+KJRootNavigationControllerItem.h"
#import "SecondViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSInteger count = self.kj_navigationController.viewControllers.count;
    
    if (count == 1) {
        self.title = @"RootVC";
        self.view.backgroundColor = [UIColor orangeColor];
        
    } else {
        UIColor *color = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
        self.view.backgroundColor = color;
        NSArray *colors = @[[UIColor whiteColor],
                            [UIColor cyanColor],
                            [UIColor greenColor]];
        
        self.title = @(count).stringValue;
        [self.navigationController.navigationBar setBarTintColor:colors[arc4random_uniform(3)]];
    }
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 200, 200, 100);
    [button setTitle:@"设置viewControllers" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setViewControllersEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)setViewControllersEvent {

    SecondViewController *vc1 = [SecondViewController new];
    SecondViewController *vc2 = [SecondViewController new];
    
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    
    self.navigationController.viewControllers = @[vcs.firstObject, vc1,vc2];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.kj_navigationController.viewControllers.count == 1) {
        SecondViewController *vc = [SecondViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self.navigationController pushViewController:[ViewController new] animated:YES];
    }    
}

@end
