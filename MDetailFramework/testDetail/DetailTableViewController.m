//
//  DetailTableViewController.m
//  B5MDetailFramework
//
//  Created by boguang on 15/8/21.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "DetailTableViewController.h"

#import "DetailView.h"
#import "UIImage+extend.h"

static NSString *titles[] = {@"图文详情",@"商品评论",@"店铺推荐"};
static NSString *urls[] = {
    @"http://micker.cn/2016/04/14/%E6%B7%98%E5%AE%9D%E5%95%86%E5%93%81%E8%AF%A6%E6%83%85%E6%8E%A7%E4%BB%B6/",
    @"http://micker.cn/2016/04/14/%E5%85%A8%E5%B1%8F%E6%B5%8F%E8%A7%88%E6%8E%A7%E4%BB%B6/",
    @"http://micker.cn"};

@interface DetailTableViewController () <DetailViewSectionDelegate, UIScrollPageControlViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) DetailView *detailView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.detailView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.detailView reloadData];
    [self.tableView reloadData];
}

- (void) dealloc {
    NSLog(@"DetailTableViewController dealloc");

}

- (DetailView *) detailView {
    if (!_detailView) {
        _detailView = [[DetailView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        _detailView.delegate = self;
        _detailView.topScrollPageView.delegate = self;
    }
    return _detailView;
}

- (UITableView *) tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:_detailView.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


#pragma mark UIScrollPageControlViewDelegate

- (NSUInteger) numberOfView:(UIScrollPageControlView *) control {
    return 8;
}

- (UIView *) configItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index  {
    UIImageView *cellItem = (UIImageView *)[control dequeueReusableViewWithIdentifier:@"reuse"];
    NSString *reuse = @"复用来的";
    UILabel *label  = nil;
    if (!cellItem) {
        cellItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 370)];
        cellItem.userInteractionEnabled = YES;
        cellItem.backgroundColor  = [UIColor colorWithWhite:0.7f alpha:0.4f];
        cellItem.reuseIdentifier = @"reuse";
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100)];
        reuse = @"=====新生成的";
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1000;
        [cellItem addSubview:label];
    } else {
        label = (UILabel *) [cellItem viewWithTag:1000];
    }
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_%d",(int)(index+1) %4]];
    image = [image imageScaledToSizeEx:CGSizeMake(cellItem.frame.size.width * 2, cellItem.frame.size.height * 2)];
    cellItem.image = image;
    
    label.text = [NSString stringWithFormat:@"item = %ld || reuse = %@", index,reuse];
    return cellItem;
}

#pragma mark DetailViewSectionDelegate


- (UIView *) viewAtTop {
    return self.tableView;
}

- (NSUInteger ) numberOfSections {
    return 3;
}


- (NSString *) titleOfSectionAt:(NSUInteger )index {
    return titles[index];
}

- (UIView *) viewOfSectionAt:(NSUInteger ) index {
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectZero];
    return webview;
}

- (void) didChangeToSection:(NSUInteger) index view:(UIView *) view {
    NSString *url = urls[index];
    UIWebView *webView = (UIWebView *) view;
    if (!webView.request) {
        [webView stopLoading];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}


#pragma mark ==
#pragma mark == tableView


- (NSMutableArray *) data {
    if (!_data) {
        _data = [NSMutableArray array];
        [_data addObject:@{@"title":@"Wap商品详情",@"author":@"伯光",@"class":@"DetailWapViewController"}];
        [_data addObject:@{@"title":@"TableView商品详情",@"author":@"伯光",@"class":@"DetailTableViewController"}];
        [_data addObject:@{@"title":@"ScrollView商品详情",@"author":@"伯光",@"class":@"DetailScrollViewController"}];
        [_data addObject:@{@"title":@"Wap商品详情",@"author":@"伯光",@"class":@"DetailWapViewController"}];
        [_data addObject:@{@"title":@"TableView商品详情",@"author":@"伯光",@"class":@"DetailTableViewController"}];
        [_data addObject:@{@"title":@"ScrollView商品详情",@"author":@"伯光",@"class":@"DetailScrollViewController"}];
    }
    return _data;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:dequeueReusableCellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = self.data[indexPath.row][@"title"];
    cell.detailTextLabel.text = self.data[indexPath.row][@"author"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
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
