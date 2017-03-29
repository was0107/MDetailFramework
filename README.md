#MDetailFramework控件
##前言
[MDetailFramework](https://github.com/was0107/MDetailFramework),为实现淘宝中的商品详情页面中， 商品的基本信息、图文详情、评论、商家推荐的效果；

##效果图展示
为更好的展示效果，请耐心等待<br>
<img src="https://raw.githubusercontent.com/was0107/MDetailFramework/master/images/detail.gif" width="50%">

##简介
* 1、此包提供商品详情的展示，支持全屏、导航2种模式；
* 2、支持图片左滑到一定距离时，侧滑展示图文详情、评论，其中图片详情、评论可通过Delegate配置；
* 3、支持视图上拉到一定距离时，上移展示图文详情、评论，其中图片详情、评论可通过Delegate配置；
* 4、banner图片支持点击，全屏展示，且全屏展示模式下，亦支持左滑\点击缩小；
* 5、当Section个数为一个时，不显示SectionBar
* 6、testDetail,提供了四种展示展示方式，UITableView\UITableView（无sectionbar）\UIScrollView\UIWebView;

##依赖
* 1、此项目依赖[MFullScreenFramework](https://github.com/was0107/MFullScreenFramework)

##举例

```
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
        cellItem.backgroundColor  = [UIColor colorWithWhite:0.7f alpha:0.4f];
        cellItem.reuseIdentifier = @"reuse";
        [cellItem  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTaped:)]];
    }
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_%d",(int)(index+1) %4]];
    image = [image imageScaledToSizeEx:CGSizeMake(cellItem.frame.size.width * 2, cellItem.frame.size.height * 2)];
    cellItem.image = image;
    return cellItem;
}

- (UIView *) configFullItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index {
    UIImageView *cellItem = (UIImageView *)[control dequeueReusableViewWithIdentifier:@"reuseFull"];
    if (!cellItem) {
        cellItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _detailView.topScrollViewTopInset)];
        cellItem.userInteractionEnabled = YES;
        cellItem.backgroundColor  = [UIColor colorWithWhite:0.7f alpha:0.4f];
        cellItem.reuseIdentifier = @"reuseFull";
        [cellItem  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTaped:)]];
    }
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic_%d",(int)(index+1) %4]];
    image = [image imageScaledToSizeEx:CGSizeMake(cellItem.frame.size.width * 2, cellItem.frame.size.height * 2)];
//    cellItem.image = image;
    return cellItem;
}

- (UIView *) configItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index  {
    if (control == _control.screenPageView) {
        return [self configFullItemOfControl:_control.screenPageView at:index];
    }
    return [self configBannerItemOfControl:control at:index];    
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
//    __totalNumber = (1 == __totalNumber) ? 2 : 1;
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

```

