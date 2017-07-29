//
//  KJRootNavigationController.h
//  KJRootNavigationController
//
//  Created by kejunapple on 2017/7/28.
//  Copyright © 2017年 kejunapple. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface KJRootNavigationController : UINavigationController
/**
 全局统一设置导航栏返回按钮样式

 @param image 返回按钮图片，可为nil
 @param title 返回按钮文字，可为nil
 */
+ (void)setBackBarButtonItemWithImage:(UIImage *_Nullable)image title:( NSString *_Nullable)title;
@end

