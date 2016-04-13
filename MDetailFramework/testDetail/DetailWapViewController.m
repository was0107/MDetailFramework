//
//  DetailWapViewController.m
//  B5MDetailFramework
//
//  Created by boguang on 15/8/21.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "DetailWapViewController.h"
#import "DetailView.h"
#import "UIImage+extend.h"

static NSUInteger __totalNumber = 3;

static NSString * images[] = {@"1.jpg", @"l.jpg", @"w.jpg",@"xt.jpg"};
static NSString *titles[] = {@"图文详情",@"商品评论",@"百度"};
static NSString *urls[] = {
    @"http://m.b5m.com/item.html?tid=2614676&mps=____&type=content",
    @"http://m.b5m.com/item.html?tid=2614676&mps=____&type=comment",
    @"http://m.baidu.com"};

@interface DetailWapViewController () <DetailViewSectionDelegate, UIScrollPageControlViewDelegate>
@property (nonatomic, strong) DetailView *detailView;
@property (nonatomic, strong) UIWebView *topWebView;

@property (nonatomic, strong) MFullScreenControl *control;
@end

@implementation DetailWapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.detailView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.topWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.b5m.com/item.html?tid=2614676&mps=____&type=index"]]];
    [self.detailView reloadData];
}

- (void) dealloc {
    NSLog(@"DetailWapViewController dealloc");

}

- (DetailView *) detailView {
    if (!_detailView) {
        _detailView = [[DetailView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        _detailView.delegate = self;
        _detailView.startYPosition = 0.0f;
        _detailView.topScrollViewTopInset = 300.0f;
        _detailView.topScrollPageView.delegate = self;
    }
    return _detailView;
}

- (UIWebView *) topWebView {
    if (!_topWebView) {
        _topWebView = [[UIWebView alloc] initWithFrame:_detailView.bounds];
        _topWebView.scrollView.showsVerticalScrollIndicator = NO;
        _topWebView.backgroundColor = [UIColor whiteColor];
        [_topWebView setOpaque:NO];
    }
    return _topWebView;
}

- (MFullScreenControl *) control {
    if(!_control) {
        _control = self.detailView.fullScreencontrol;
        _control.screenPageView.delegate = self;
    }
    return _control;
}


#pragma mark UIScrollPageControlViewDelegate

- (NSUInteger) numberOfView:(UIScrollPageControlView *) control {
    return 4;
}

- (UIView *) configBannerItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index {
    UIImageView *cellItem = (UIImageView *)[control dequeueReusableViewWithIdentifier:@"reuse"];
    if (!cellItem) {
        cellItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _detailView.topScrollViewTopInset)];
        cellItem.userInteractionEnabled = YES;
        cellItem.clipsToBounds = YES;
        cellItem.contentMode = UIViewContentModeScaleAspectFill;
        cellItem.backgroundColor  = [UIColor colorWithWhite:0.7f alpha:0.4f];
        cellItem.reuseIdentifier = @"reuse";
        [cellItem  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTaped:)]];
    }
    UIImage *image = [UIImage imageNamed:images[index % 4]];
    cellItem.image = image;
    return cellItem;
}

- (UIView *) configFullItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index {
    MFullScreenView *cellItem = (MFullScreenView *)[control dequeueReusableViewWithIdentifier:@"reuse"];
    if (!cellItem) {
        cellItem = [[MFullScreenView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        cellItem.userInteractionEnabled = YES;
        cellItem.reuseIdentifier = @"reuse";
        [cellItem enableDoubleTap:YES];
        __weak typeof(self) blockSelf = self;
        cellItem.singleTapBlock = ^(UIGestureRecognizer * recognizer) {
            [blockSelf.detailView hideFullScreenOnView:recognizer.view];
        };
    }
    cellItem.imageView.image = [UIImage imageNamed:images[index % 4]];
    [cellItem reloadData];
    return cellItem;
}

- (void) reconfigItemOfControl:(UIScrollPageControlView *)control at:(NSUInteger) index withView:(UIView *)view {
    if (control == _control.screenPageView) {
        MFullScreenView *cellItem = (MFullScreenView *)view;
        [cellItem reloadData];
    }
}

- (UIView *) configItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index  {
    if (control == _control.screenPageView) {
        return [self configFullItemOfControl:_control.screenPageView at:index];
    }
    return [self configBannerItemOfControl:control at:index];
}


- (CGFloat) minimumRowSpacing:(UIScrollPageControlView *) control {
    return (control == _control.screenPageView) ? 20.0f : 0.0f;
}


- (void) imageViewDidTaped:(UIGestureRecognizer *) recognizer {
    if (self.control.isAppear) {
        [self.detailView hideFullScreenOnView:recognizer.view];
        return;
    }
    [self.detailView showFullScreenOnView:recognizer.view];
}


#pragma mark DetailViewSectionDelegate


- (UIView *) viewAtTop {
    return self.topWebView;
}

- (NSUInteger ) numberOfSections {
    return __totalNumber;
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

- (void) floatViewIsGoingTo:(BOOL) appear {
    NSLog(@"floatViewIsGoingTo = %d", appear);
}

@end
