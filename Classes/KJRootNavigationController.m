//
//  KJRootNavigationController.m
//  KJRootNavigationController
//
//  Created by coder on 2017/7/28.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "KJRootNavigationController.h"
#import <objc/runtime.h>

static UIImage *kBackBarItemImage = nil;
static NSString *kBackBarItemTitle = nil;

#pragma mark - Class 【__KJWrapperNavigaionController】
@interface __KJWrapperNavigaionController : UINavigationController

@property (assign, nonatomic) BOOL hasBackItem;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController hasBackItem:(BOOL)hasBack;
@end
@implementation __KJWrapperNavigaionController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController hasBackItem:(BOOL)hasBack {
    
    //这里不用initWithRootViewController方法初始化,因为该方法会导致直接进入viewDidLoad方法，而不是先走if内的逻辑，故改为[super init]，然后在给viewControllers设值，效果等同
    if (self = [super init]) {
        _hasBackItem = hasBack;
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.interactivePopGestureRecognizer addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.hidden = NO;
    [self.navigationBar setTranslucent:NO];
    
    [self setupBackBarItem];
}
- (void)dealloc {
    [self.interactivePopGestureRecognizer removeObserver:self forKeyPath:@"enabled"];
}

- (void)backEvent {
    [self popViewControllerAnimated:YES];
}

- (void)setupBackBarItem {
    if (self.hasBackItem) {
        if (kBackBarItemTitle == nil & kBackBarItemImage == nil) {
            //使用默认的返回样式
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"＜返回" style:UIBarButtonItemStylePlain target:self action:@selector(backEvent)];
            self.topViewController.navigationItem.leftBarButtonItem = backItem;
        } else {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:kBackBarItemTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setImage:kBackBarItemImage forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            
            if (button.bounds.size.width < 40) {
                CGRect rect = button.bounds;
                rect.size.width = 40;
                button.frame = rect;
            }
            
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.topViewController.navigationItem.leftBarButtonItem = backItem;
        }
    } else {
        self.topViewController.navigationItem.leftBarButtonItem = nil;
    }
}
- (void)setHasBackItem:(BOOL)hasBackItem {
    if (_hasBackItem != hasBackItem) {
        _hasBackItem = hasBackItem;
        [self setupBackBarItem];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"enabled"]) {
        BOOL enabled = [change[NSKeyValueChangeNewKey] boolValue];
        UINavigationController *navigationVC = getRootNavigationControllerFor(self);
        navigationVC.interactivePopGestureRecognizer.enabled = enabled;
    }
}

#pragma mark - c function
UINavigationController *getRootNavigationControllerFor(UINavigationController *selfVC) {
    UINavigationController *navigationVC = selfVC;
    
    while (navigationVC && [navigationVC isKindOfClass:[KJRootNavigationController class]] == NO) {
        navigationVC = navigationVC.navigationController;
    }
    return navigationVC;
}
#pragma mark - override
- (NSArray<UIViewController *> *)viewControllers {
    UINavigationController *navigationVC = getRootNavigationControllerFor(self);
    
    if (navigationVC) {
       return [navigationVC viewControllers];
    } else {
        return [super viewControllers];
    }
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSAssert(viewControllers.count, @"viewControllers 不能为空");
    
    UINavigationController *navigationVC = getRootNavigationControllerFor(self);
    
    if (navigationVC) {
        [navigationVC setViewControllers:viewControllers animated:animated  ];
    } else {
        [super setViewControllers:viewControllers animated:animated];
    }
}
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    [self setViewControllers:viewControllers animated:NO];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UINavigationController *navigationVC = getRootNavigationControllerFor(self);
    
    //找到KJRootNavigationController，如果有说明是通过vc中调用的[self.navigationController pushViewController:xx]，那么用KJRootNavigationController来push；
    //如果没有KJRootNavigationController，则表明是用来包装viewController
    if (navigationVC) {
        [navigationVC pushViewController:viewController animated:animated];
    } else {
        [super pushViewController:viewController animated:animated];
    }
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    UINavigationController *navigationVC = getRootNavigationControllerFor(self);
    
    if (navigationVC) {
        return [navigationVC popViewControllerAnimated:animated];
    } else {
        return [super popViewControllerAnimated:animated];
    }
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UINavigationController *navigationVC = getRootNavigationControllerFor(self);
    
    if (navigationVC) {
        return [navigationVC popToViewController:viewController animated:animated];
    } else {
        return [super popToViewController:viewController animated:animated];
    }
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    
    UINavigationController *navigationVC = getRootNavigationControllerFor(self);
    
    if (navigationVC) {
        return [navigationVC popToRootViewControllerAnimated:animated];
    } else {
        return [super popToRootViewControllerAnimated:animated];
    }
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.topViewController.hidesBottomBarWhenPushed;
}
@end

#pragma mark - Class【__KJWrapperViewController】

@interface __KJWrapperViewController : UIViewController

@property (strong, nonatomic) __KJWrapperNavigaionController *contentViewController;
/** 
    如果contentViewController不是__KJWrapperNavigaionController，则将contentViewController包装进__KJWrapperNavigaionController，然后改naviVC作为子控制器加入到__KJWrapperViewController
 */
- (instancetype)initWithContentViewController:(UIViewController *)contentViewController  hasBackItem:(BOOL)hasBack;

@end

@implementation __KJWrapperViewController

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController hasBackItem:(BOOL)hasBack {
    
    if (self = [super init]) {
        __KJWrapperNavigaionController *nav = (__KJWrapperNavigaionController *)contentViewController;
        if ([contentViewController isKindOfClass:[__KJWrapperNavigaionController class]] == NO) {
            nav = [[__KJWrapperNavigaionController alloc] initWithRootViewController:contentViewController hasBackItem:hasBack];
        }
        self.contentViewController = nav;
        
        [self addChildViewController:nav];
        [nav didMoveToParentViewController:self];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentViewController.view.frame = self.view.bounds;
    self.contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:self.contentViewController.view];
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.contentViewController.hidesBottomBarWhenPushed;
}

@end

#pragma mark - Class 【KJRootNavigationController】
@interface KJRootNavigationController ()

@end

@implementation KJRootNavigationController

#pragma mark - init

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[__KJWrapperViewController class]] == NO) {
        rootViewController = [[__KJWrapperViewController alloc] initWithContentViewController:rootViewController hasBackItem:NO];
    }
    if (self = [super initWithRootViewController:rootViewController]) {
        
    }
    return self;
};
- (void)awakeFromNib {
    [super awakeFromNib];
    UIViewController *rootViewController = self.viewControllers.firstObject;
    if ([rootViewController isKindOfClass:[__KJWrapperViewController class]] == NO) {
        rootViewController = [[__KJWrapperViewController alloc] initWithContentViewController:rootViewController hasBackItem:NO];
    }
    self.viewControllers = @[rootViewController];
}

+ (void)setBackBarButtonItemWithImage:(UIImage *)image title:( NSString *)title {
    
    kBackBarItemImage = image;
    kBackBarItemTitle = title;
    
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.hidden = YES;
}


#pragma mark - override

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSAssert(viewControllers.count, @"viewControllers 不能为空");
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:viewControllers.count];
    for (NSInteger index = 0; index < viewControllers.count; index++) {
        BOOL hasBack = index > 0;
        UIViewController *vc = viewControllers[index];
        
        if ([vc isKindOfClass:[__KJWrapperViewController class]]) {
            __KJWrapperViewController *wraperVC = (__KJWrapperViewController *)vc;
            wraperVC.contentViewController.hasBackItem = hasBack;
            [vcArray addObject:vc];
        } else {
            __KJWrapperViewController *wrapperVC = [[__KJWrapperViewController alloc] initWithContentViewController:vc hasBackItem:hasBack];
            [vcArray addObject:wrapperVC];
        }
    }
    [super setViewControllers:vcArray animated:animated];
}
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    [self setViewControllers:viewControllers animated:NO];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //注意：直接push一个navigationController是不被允许的，所以需要把navigationController作为子VC添加到一个ViewController上，然后push这ViewController
    BOOL hasBack = self.viewControllers.count > 0 ? YES : NO;
    
    if ([viewController isKindOfClass:[__KJWrapperViewController class]] == NO) {
        viewController = [[__KJWrapperViewController alloc] initWithContentViewController:viewController hasBackItem:hasBack];
    }

    [super pushViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController.parentViewController.parentViewController isKindOfClass:[__KJWrapperViewController class]]) {
        return [super popToViewController:viewController animated:animated];
    }
    return [super popToViewController:viewController animated:animated];
}
@end

