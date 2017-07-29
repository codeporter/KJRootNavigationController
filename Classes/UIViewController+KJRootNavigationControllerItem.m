//
//  UIViewController+KJRootNavigationControllerItem.m
//  KJRootNavigationController
//
//  Created by kejunapple on 2017/7/29.
//  Copyright © 2017年 kejunapple. All rights reserved.
//

#import "UIViewController+KJRootNavigationControllerItem.h"


@implementation UIViewController (KJRootNavigationControllerItem)

- (__kindof UINavigationController *)kj_navigationController {
    UINavigationController *nav = self.navigationController;
    
    while (nav && [nav isKindOfClass:[KJRootNavigationController class]] == NO) {
        nav = nav.navigationController;
    }
    return nav;
}

@end
