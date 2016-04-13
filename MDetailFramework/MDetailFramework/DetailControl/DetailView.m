//
//  DetailView.m
//  DW
//
//  Created by boguang on 15/6/23.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "DetailView.h"
#import "DetailTipView.h"
#import "DetailRefreshView.h"
#import "DetailPictureView.h"

static CGFloat animateTime  = 0.25f;
static CGFloat paddingSpace = 60.0f;
static CGFloat tipHeight    = 44.0f;


@interface DetailView ()
@property (nonatomic, strong) UIView                        *sectionView;
@property (nonatomic, strong) UIView                        *alphaView;
@property (nonatomic, strong) UIView                        *sectionLineView;
@property (nonatomic, assign) BOOL                          isTriggerd;
@property (nonatomic, assign) BOOL                          hidesForSingleTitle;    //中间的Section，是否对单个Ttitle的进行隐藏


@end

@implementation DetailView {
    __block CGFloat width, height, _middleHeight;
    NSInteger _currentIndex;
    NSUInteger _sectionTotal;
    __block NSTimeInterval  _timeInterval;
}
@synthesize topView             = _topView;
@synthesize bottomView          = _bottomView;
@synthesize tipView             = _tipView;
@synthesize fullScreencontrol   = _fullScreencontrol;
@synthesize topScrollPageView   = _topScrollPageView;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = -1;
        _sectionTotal = 0;
        width = frame.size.width;
        height = frame.size.height;
        _middleHeight = 44.0f;
        _startYPosition = 0.0f;
        self.topScrollViewTopInset = 370.0f;
        self.hidesForSingleTitle = YES;
        _timeInterval = [[NSDate date] timeIntervalSince1970];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) dealloc {
    _topScrollPageView.delegate = nil;
    _fullScreencontrol.screenPageView.delegate = nil;
    [_topScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_topScrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void) reloadData {
    self.isTriggerd = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(viewAtTop)]) {
        _sectionTotal = [_delegate numberOfSections];
        [self initTopScrollView];
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self configBottmSectionViews];
    }
    
    if (self.topScrollPageView.delegate) {
        [self configTopScrollView];
        [self.topScrollPageView reloadData];
    }
}

- (BOOL) isBottomViewShowed {
    if (_isTriggerd && self.topView.frame.origin.y >=0.0f) {
        return YES;
    }
    return NO;
}

- (void) disappearBottomView {
    if ([self isBottomViewShowed]) {
        [self hideBottomView];
    }
}

- (void) initTopScrollView {
    if (self.topScrollView) {
        return;
    }
    UIView *view = [self.delegate viewAtTop];
    if ([view isKindOfClass:[UIScrollView class]]) {
        self.topScrollView = (UIScrollView *)view;
    }
    else if ([view isKindOfClass:[UIWebView class]]) {
        self.topScrollView = ((UIWebView *) view).scrollView;
    }
    else  {
        assert(0);
        NSLog(@"scrollViewAtTop needs to be implemented");
        return;
    }
    
    [self.topScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    [self.topScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    [self.topScrollView addSubview:self.tipView];
    [self.topScrollView setContentInset:UIEdgeInsetsMake(0, 0, tipHeight, 0)];
    [self.topView addSubview:view];
}

- (void) configTopScrollView {
    [self.topScrollView setContentInset:UIEdgeInsetsMake(_topScrollViewTopInset-20, 0, tipHeight, 0)];
//    [self.topScrollView addDetailRefreshWithHandler:nil];
    [self.topScrollView addVerticalParallas:self.topScrollPageView block:nil];
    [self.topScrollView addSubview:self.topScrollPageView];
//    [self.topScrollView addSubview:self.alphaView];   //add shadow effect
    [self.topScrollView sendSubviewToBack:self.topScrollPageView];
    [self.topScrollView setContentOffset:CGPointMake(0, 20-_topScrollViewTopInset)];
    __weak typeof(self) blockSelf = self;
    [self.imageScrollView addDetaiPictureViewWithHandler:^{
        [blockSelf addDetailPictureViewHandler];
    }];
}

- (void) addDetailPictureViewHandler {
    if (_sectionTotal == 0) {
        return ;
    }
    CGRect rect = self.bottomView.frame;
    rect.origin = CGPointMake(width, 0);
    [self.bottomView setFrame:rect];
    [self bringSubviewToFront:_bottomView];
    [self didFirstShowOnBottomView];
    self.isTriggerd = YES;
    [self animateContent];
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:animateTime animations:^{
        [blockSelf.bottomView setFrame:CGRectMake(0, 0, width, height)];
    } completion:^(BOOL finished) {
    }];
}

- (void)  hideBottomView {

    __weak typeof(self) blockSelf = self;
    self.isTriggerd = NO;
    [UIView animateWithDuration:animateTime animations:^{
        [blockSelf animateContent];
        [blockSelf.topView setFrame:CGRectMake(0, 0, width, height)];
        [blockSelf.bottomView setFrame:CGRectMake(0, height, width, height - _middleHeight - _startYPosition)];
    } completion:^(BOOL finished) {
        if(blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(floatViewIsGoingTo:)]) {
            [blockSelf.delegate floatViewIsGoingTo:NO];
        }
    }];
}

- (void) configBottomView:(UIScrollView *) scrollView {
    __weak typeof(self) weakSelf = self;
    [scrollView addDetailRefreshWithHandler:^{
        [weakSelf hideBottomView];
    }];
}


- (void) configBottmSectionViews {
    [[[self bottomView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_delegate) {
        NSUInteger titleTotal = [_delegate numberOfSections];
        if (titleTotal == 0 || ![_delegate respondsToSelector:@selector(titleOfSectionAt:)]) {
            _middleHeight = 0.0f;
            return;
        }
        [[[self sectionView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat itemWidth = width/titleTotal;
        CGRect rect = self.sectionView.frame;

        if (titleTotal == 1 && self.hidesForSingleTitle ) {
            _middleHeight = 0.0f;
            rect.size.height = _middleHeight;
            self.sectionView.frame = rect;
        } else {
            _middleHeight = 44.0f;
            rect.origin.y = _startYPosition;
            rect.size.height = _middleHeight;
            self.sectionView.frame = rect;
            [_bottomView addSubview:self.sectionView];
            
            rect = self.sectionLineView.frame;
            rect.size.width = itemWidth;
            self.sectionLineView.frame = rect;
        }
        
        for (NSUInteger i = 0 ; i < titleTotal; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(itemWidth * i, 0, width/titleTotal, _middleHeight);
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:[_delegate titleOfSectionAt:i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            button.tag = 20140830 + i;
            [button addTarget:self action:@selector(sectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self sectionView] addSubview:button];
        }
        
        if (_middleHeight > 1.0f) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _middleHeight - 1, width, 1)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            lineView.alpha = 0.5f;
            [[self sectionView] addSubview:lineView];
        }

        rect = self.bottomView.frame;
        float sectionHeight = _startYPosition;
        if (self.sectionView.superview) {
            sectionHeight = self.sectionView.frame.origin.y + self.sectionView.frame.size.height;
        }
        for (NSUInteger i = 0 ; i < titleTotal; i++) {
            UIView *view = nil;
            if ([_delegate respondsToSelector:@selector(viewOfSectionAt:)]) {
                view = [_delegate viewOfSectionAt:i];
                CGRect rect1 = CGRectMake(0, sectionHeight, width, height - sectionHeight);
                [view setFrame:rect1];
                [self configBottomView:[self firstScrollViewOfView:view]];
                view.tag = 20150830 + i;
                [self.bottomView addSubview:view];
            }
        }
        
    }
}

- (void) didFirstShowOnBottomView {
    if (!self.sectionLineView.superview) {
        [_sectionView addSubview:self.sectionLineView];
    }
    if (-1 == _currentIndex) {
        [self sectionButtonAction:[self.sectionView viewWithTag:20140830]];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(floatViewIsGoingTo:)]) {
        [_delegate floatViewIsGoingTo:YES];
    }
}

#pragma mark --
#pragma mark Getter & Setter

- (UIScrollPageControlView *) topScrollPageView {
    if (!_topScrollPageView) {
        _topScrollPageView = [[UIScrollPageControlView alloc] initWithFrame:CGRectMake(0, -_topScrollViewTopInset, width, _topScrollViewTopInset)];
        _topScrollPageView.scrollView.frame = CGRectMake(0, 10, width, _topScrollViewTopInset);
        _topScrollPageView.layer.masksToBounds = NO;
    }
    return _topScrollPageView;
}

- (MFullScreenControl *) fullScreencontrol {
    if (!_fullScreencontrol) {
        _fullScreencontrol = [[MFullScreenControl alloc] init];
        __weak typeof(self) blockSelf = self;
        [_fullScreencontrol.screenPageView.scrollView addDetaiPictureViewWithHandler:^{
            [blockSelf hideFullScreenOnView:nil];
            [blockSelf addDetailPictureViewHandler];
        }];
        _fullScreencontrol.screenPageView.scrollView.pictureView.rightLabel.textColor = [UIColor whiteColor];
        _fullScreencontrol.screenPageView.scrollView.pictureView.leftImageView.image = [UIImage imageNamed:@"detail_left_loading_white"];
    }
    return _fullScreencontrol;
}

- (UIView *) alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, -2, width, 4)];
        _alphaView.backgroundColor     = [UIColor clearColor];
        _alphaView.layer.masksToBounds = NO;
        _alphaView.layer.shadowRadius  = 2.0f;
        _alphaView.layer.shadowOpacity = 0.25f;
        _alphaView.layer.shadowColor   = [[UIColor blackColor] CGColor];
        _alphaView.layer.shadowOffset  = CGSizeZero;
        _alphaView.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:CGRectMake(-4, 0, width+8, 4)] CGPath];
    }
    return _alphaView;
}


- (DetailTipView *) tipView {
    if (!_tipView) {
        _tipView = [[DetailTipView alloc] initWithFrame:CGRectMake(0, height, width, tipHeight)];
    }
    return _tipView;
}

- (UIView *) topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    }
    return _topView;
}

- (CGRect) bottomSectionFrame {
    return CGRectMake(0, _middleHeight, width, height - _middleHeight - _startYPosition);
}


- (UIView *) bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, height - _startYPosition)];
    }
    return _bottomView;
}

- (UIScrollView *) imageScrollView {
    return self.topScrollPageView.scrollView;
}

- (UIView *) sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, _middleHeight)];
        _sectionView.backgroundColor = [UIColor whiteColor];
    }
    return _sectionView;
}

- (UIView *) sectionLineView {
    if (!_sectionLineView) {
        _sectionLineView = [[UIView alloc] initWithFrame:CGRectMake(width, _middleHeight - 2, width, 2)];
        _sectionLineView.backgroundColor = [UIColor redColor];
    }
    return _sectionLineView;
}

- (UIScrollView *) firstScrollViewOfView:(UIView *) rootView {
    if ([rootView isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)rootView;
    }
    else {
        __weak typeof(self) blockSelf = self;
        __block UIScrollView *scrollView = nil;
        [rootView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([blockSelf firstScrollViewOfView:obj]) {
                scrollView = obj;
                *stop = YES;
            }
        }];
        return scrollView;
    }
    return nil;
}

- (void) animateContent {
    float contentStartY = _startYPosition;
    if (fabsf(contentStartY) < 1) {
        return;
    }
    if (_sectionView.superview) {
        contentStartY = _sectionView.frame.origin.y + _sectionView.frame.size.height;
    }
    if (!_isTriggerd) {
        contentStartY -= _startYPosition;
    }
    for (NSUInteger i = 0, total = [self.delegate numberOfSections]; i < total; i++) {
        UIView *view = (UIView *) [self.bottomView viewWithTag:20150830 + i];
        CGRect rect  = CGRectMake(0, contentStartY, width, height - contentStartY);
        [view setFrame:rect];
    }
    
}

#pragma mark --
#pragma mark Action



- (void) showFullScreenOnView:(UIView *) view {
    [self.fullScreencontrol.screenPageView reloadData];
    self.fullScreencontrol.screenPageView.currentIndex = self.topScrollPageView.currentIndex;
    [self.fullScreencontrol appearOnView:view];
}

- (void) hideFullScreenOnView:(UIView *) view {
    [self.topScrollPageView.scrollView setContentOffset:CGPointMake(self.fullScreencontrol.screenPageView.currentIndex * [self.topScrollPageView itemWidth], 0)];
    [self.topScrollPageView reloadData];
    [self.fullScreencontrol disAppearOnView:view];
}

- (IBAction)sectionButtonAction:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    if (!button) {
        return;
    }
    __weak typeof(self) blockSelf = self;
    NSUInteger index = button.tag - 20140830;
    
    UIView *theSectionView = [self.bottomView viewWithTag:20150830 + index];

    if (self.delegate && [self.delegate respondsToSelector:@selector(willChangeToSection:view:)]) {
        [self.delegate willChangeToSection:index view:theSectionView];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(canChangeToSection:)]) {
        if (![self.delegate canChangeToSection:index]) {
            return;
        }
    }
    for (NSUInteger i = 0 ; i < [self.delegate numberOfSections]; i++) {
        UIButton *buttonTmp = (UIButton *) [self.sectionView viewWithTag:20140830 + i];
        [buttonTmp setSelected:i == index];
    }
    if (button.isSelected) {
        CGRect rect = self.sectionLineView.frame;
        rect.origin.x = button.frame.size.width * index;
        [UIView animateWithDuration:animateTime animations:^{
            [blockSelf.sectionLineView setFrame:rect];
        } completion:nil];
    }
    for (NSUInteger i = 0 ; i < [self.delegate numberOfSections]; i++) {
        UIView *view = (UIView *) [self.bottomView viewWithTag:20150830 + i];
        [view setHidden:i != index];
    }
    _currentIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeToSection:view:)]) {
        [self.delegate didChangeToSection:index view:theSectionView];
    }
    
}


#pragma mark --
#pragma mark Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"contentSize" isEqualToString:keyPath]) {
        [self __scrollTipView:self.topScrollView];
    } else if ([@"contentOffset" isEqualToString:keyPath]) {
        [self __scrollAction:self.topScrollView];
    }
}

- (BOOL) __isNeedToAdjustTopScrollViewContentSize {
    CGFloat scrollSizeHeight = self.topScrollView.contentSize.height + self.topScrollView.contentInset.top + self.topScrollView.contentInset.bottom ;
    if (scrollSizeHeight  < height) {
        return YES;
    }
    return NO;
}

- (void) __adjustTopScrollViewContentSize {
    CGSize size = self.topScrollView.contentSize;
    size.height = height - (self.topScrollView.contentInset.top + self.topScrollView.contentInset.bottom);
    [self.topScrollView setContentSize:size];
}

- (void) __scrollTipView:(UIScrollView *)scrollView {
    if ([self __isNeedToAdjustTopScrollViewContentSize]) {
        [self __adjustTopScrollViewContentSize];
        return;
    }
    [self.tipView setFrame:CGRectMake(0, self.topScrollView.contentSize.height  , width, tipHeight)];
}

- (void)__scrollAction:(UIScrollView *)scrollView {

    if (scrollView == self.topScrollView && _sectionTotal > 0  && ![self __isNeedToAdjustTopScrollViewContentSize]) {
        CGSize contentSize          = scrollView.contentSize;
        CGPoint contentOffset       = scrollView.contentOffset;
        UIEdgeInsets contentInsets  = scrollView.contentInset;
        if (!_isTriggerd) {
            CGFloat startY =  (contentSize.height + contentInsets.bottom)  - (contentOffset.y + height);
            [self.bottomView setFrame:CGRectMake(0, startY + height, width, height)];
        }
        if (!scrollView.isDragging  && !_isTriggerd) {
            float value = self.topScrollView.contentOffset.y + height - self.topScrollView.contentSize.height;
            if (value > paddingSpace) {
                self.isTriggerd = YES;
                [self didFirstShowOnBottomView];
                __weak typeof(self) blockSelf = self;
                [UIView animateWithDuration:animateTime animations:^{
                    [blockSelf.bottomView setFrame:CGRectMake(0, 0, width, height)];
                    [blockSelf.topView setFrame:CGRectMake(0, -height, width, height)];
                    [blockSelf animateContent];
                } completion:nil];
            }
        }
    }

}

@end
