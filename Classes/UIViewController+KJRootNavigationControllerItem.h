//
//  UIViewController+KJRootNavigationControllerItem.h
//  KJRootNavigationController
//
//  Created by coder on 2017/7/29.
//  Copyright © 2017年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJRootNavigationController.h"

@interface UINavigationController (KJRootNavigationController)
/** 获取KJRootNavigationController的最上层的VC*/
@property(nullable, nonatomic,readonly,strong) UIViewController *kj_topViewController;
/** 获取去除__KJWrapperViewController包裹后的VC数组*/
@property(nullable, nonatomic,readonly,copy) NSArray<UIViewController *> *kj_unwrappedViewControllers;
@end

@interface UIViewController (KJRootNavigationControllerItem)

@property(nullable, nonatomic,readonly,strong,) KJRootNavigationController *kj_navigationController;

@end
