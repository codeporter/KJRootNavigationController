//
//  ViewController.m
//  KJRootNavigationController
//
//  Created by kejunapple on 2017/7/29.
//  Copyright © 2017年 kejunapple. All rights reserved.
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
