//
//  RootTableViewController.m
//  B5MDetailFramework
//
//  Created by boguang on 15/8/21.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "RootTableViewController.h"


@interface RootTableViewController ()
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) dealloc {
    
    NSLog(@"RootTableViewController dealloc");
}

- (NSMutableArray *) data {
    if (!_data) {
        _data = [NSMutableArray array];
        [_data addObject:@{@"title":@"Wap商品详情",@"author":@"伯光",@"class":@"DetailWapViewController"}];
        [_data addObject:@{@"title":@"Wap商品详情（单个隐藏Section）",@"author":@"伯光",@"class":@"SingleOneSectionTableViewController"}];
        [_data addObject:@{@"title":@"TableView商品详情",@"author":@"伯光",@"class":@"DetailTableViewController"}];
        [_data addObject:@{@"title":@"ScrollView商品详情",@"author":@"伯光",@"class":@"DetailScrollViewController"}];
    }
    return _data;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *dequeueReusableCellWithIdentifier = @"dequeueReusableCellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueReusableCellWithIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dequeueReusableCellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.data[indexPath.row][@"title"];
    cell.detailTextLabel.text = self.data[indexPath.row][@"author"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *classString = self.data[indexPath.row][@"class"];
    Class newClass = NSClassFromString(classString);
    UIViewController *controller = [[newClass alloc] init];
    controller.title = self.data[indexPath.row][@"title"];
    if (controller)
        [self.navigationController pushViewController:controller animated:YES];
}
@end
