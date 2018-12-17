//
//  SecondViewController.m
//  KJRootNavigationController
//
//  Created by coder on 2017/7/28.
//  Copyright © 2017年 coder. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "UIViewController+KJRootNavigationControllerItem.h"


@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"VCWithOnwerBar";
    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self.view addSubview:self.tableView];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.kj_navigationController.interactivePopGestureRecognizer.enabled = NO;
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.kj_navigationController.interactivePopGestureRecognizer.enabled = YES;
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"KJRootNavigationContoller-%ld", indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return _tableView;
}

@end
