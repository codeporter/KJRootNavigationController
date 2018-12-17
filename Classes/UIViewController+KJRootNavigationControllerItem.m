//
//  UIViewController+KJRootNavigationControllerItem.m
//  KJRootNavigationController
//
//  Created by coder on 2017/7/29.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "UIViewController+KJRootNavigationControllerItem.h"

@implementation UINavigationController (KJRootNavigationController)

- (UIViewController *)kj_topViewController {
    UINavigationController *nav = self;
    
    while (nav && [nav isKindOfClass:[KJRootNavigationController class]] == NO) {
        nav = nav.navigationController;
    }
    if (nav) {
        UIViewController *topVC = nav.topViewController;
        if ([topVC isKindOfClass:NSClassFromString(@"__KJWrapperViewController")]) {
            nav = [topVC valueForKey:@"contentViewController"];
        }
    }
    return nav.topViewController;
}
- (NSArray<UIViewController *> *)kj_unwrappedViewControllers {
    if ([self isKindOfClass:NSClassFromString(@"__KJWrapperNavigaionController")]) {
        UINavigationController *nav = self.kj_navigationController;
        return nav.kj_unwrappedViewControllers;
    } else if ([self isKindOfClass:[KJRootNavigationController class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"__KJWrapperViewController")]) {
                UINavigationController *wrapNavi = [vc valueForKey:@"contentViewController"];
                if (wrapNavi.topViewController) {
                    [array addObject:wrapNavi.topViewController];
                }
            }
        }
        return [array copy];
    }
    return self.viewControllers;
}
@end

@implementation UIViewController (KJRootNavigationControllerItem)

- (__kindof UINavigationController *)kj_navigationController {
    UINavigationController *nav = self.navigationController;
    
    while (nav && [nav isKindOfClass:[KJRootNavigationController class]] == NO) {
        nav = nav.navigationController;
    }
    return nav;
}

@end
