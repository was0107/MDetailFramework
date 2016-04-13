//
//  DetailScrollViewController.m
//  B5MDetailFramework
//
//  Created by boguang on 15/8/21.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "DetailScrollViewController.h"
#import "DetailView.h"
#import "UIImage+extend.h"

static NSString *titles[] = {@"图文详情",@"商品评论",@"店铺推荐"};
static NSString *urls[] = {
    @"http://m.b5m.com/item.html?tid=2614676&mps=____&type=content",
    @"http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment",
    @"http://m.baidu.com"};

@interface DetailScrollViewController () <DetailViewSectionDelegate, UIScrollPageControlViewDelegate>
@property (nonatomic, strong) DetailView *detailView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation DetailScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self scrollView];
    [self.view addSubview:self.detailView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.detailView reloadData];
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, (self.view.bounds.size.height - 64) * 2)];
}

- (void) dealloc {
    NSLog(@"DetailScrollViewController dealloc");

}

- (DetailView *) detailView {
    if (!_detailView) {
        _detailView = [[DetailView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        _detailView.delegate = self;
        _detailView.topScrollPageView.delegate = self;
    }
    return _detailView;
}

- (UIScrollView *) scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, (self.view.bounds.size.height - 64) * 1 + 1.0f) ];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        label.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4f];
        label.text = @"Label 1";
        label.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:label];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        label.backgroundColor = [UIColor redColor];
        label.text = @"Label 2";
        label.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:label];
    }
    return _scrollView;
}


#pragma mark UIScrollPageControlViewDelegate

- (NSUInteger) numberOfView:(UIScrollPageControlView *) control {
    return 10;
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
    return self.scrollView;
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


@end
