//
//  ViewController.m
//  MyOCNote
//
//  Created by 秦威 on 2018/6/17.
//  Copyright © 2018年 秦威. All rights reserved.
//

#import "ViewController.h"
#import "RuntimeViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpUI];
}

- (void) setUpUI {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"runtime";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RuntimeViewController *runtimeVC = [RuntimeViewController new];
        [self.navigationController pushViewController:runtimeVC animated:YES];
    }
}

@end
