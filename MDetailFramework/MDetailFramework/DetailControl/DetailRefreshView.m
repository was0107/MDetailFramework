//
//  DetailRefreshView.m
//  DW
//
//  Created by boguang on 15/6/23.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "DetailRefreshView.h"
#include <objc/runtime.h>

#pragma mark --
#pragma mark DetailRefreshView

@interface DetailRefreshView()
@property (nonatomic, assign) CGFloat originalTopInset;
@property (nonatomic, assign) CGFloat thresHold;

@end

@implementation DetailRefreshView


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomLabel];
        self.thresHold = frame.size.height +  5;
        self.backgroundColor = [UIColor clearColor];
        self.animateType = DetailRefreshViewAnimateTypeAttachTop;
    }
    return self;
}

- (UILabel *) bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.bounds.size.width, 18)];
        _bottomLabel.font = [UIFont systemFontOfSize:12.0f];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.text = @"下拉，返回宝贝详情";
        _bottomLabel.backgroundColor = [UIColor clearColor];   
    }
    return _bottomLabel;
}

- (UIImageView *) topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 25) / 2, 9, 22, 22)];
        _topImageView.backgroundColor = [UIColor clearColor];
        _topImageView.image = [UIImage imageNamed:@"detail_down_loading"];
    }
    return _topImageView;
}

- (void) didMoveToSuperview {
    if (!self.superview) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    } else {
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void) setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    self.originalTopInset = scrollView.contentInset.top;
    [self setState:DetailRefreshStateNormal];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
}


- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if (contentOffset.y > 0) {
        return;
    }
    CGFloat scrollOffsetThreshold = self.bottomLabel.bounds.size.height - self.thresHold  - self.scrollView.contentInset.top;
    if(!self.scrollView.isDragging && self.state == DetailRefreshStateLoading)
        self.state = DetailRefreshStateTriggerd;
    else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state != DetailRefreshStateLoading)
        self.state = DetailRefreshStateLoading;
    else if(contentOffset.y >= scrollOffsetThreshold && self.state != DetailRefreshStateNormal)
        self.state = DetailRefreshStateNormal;
    
    CGFloat offset = contentOffset.y + self.scrollView.contentInset.top;
//    NSLog(@"offset = %f | contentOffset= %f", offset, contentOffset.y);

    //move when cross the points
    if (offset <= -self.bounds.size.height && contentOffset.y <= -self.bounds.size.height) {
        switch (self.animateType) {
            case DetailRefreshViewAnimateTypeAttachTop:   //吸顶
                    break;
            case DetailRefreshViewAnimateTypeAttachBottom:
                offset -= (offset + self.bounds.size.height) ; //开启，则跟随底部
                break;
            case DetailRefreshViewAnimateTypeSpeed1:
                offset -= (offset + self.bounds.size.height) /3.0f ; //开启，则速度是底部的1/3速度；差速
                break;
            case DetailRefreshViewAnimateTypeSpeed2:
                offset -= (offset + self.bounds.size.height) /2.0f ; //开启，则速度是底部的一半速度；差速
                break;
            default:      //吸顶
                break;
        }
    }
    self.frame = CGRectMake(0,offset - self.scrollView.contentInset.top + self.originalTopInset,
                            self.bounds.size.width, self.bounds.size.height);
    self.alpha = (offset < 0) ? (fabs(offset * 1.5f)/self.bounds.size.height) : 0;
}


- (void) setState:(DetailRefreshState)state {
    if (_state != state) {
        _state = state;
        __weak typeof(self) blockSelf = self;

        switch (_state) {
            case DetailRefreshStateTriggerd: {
                if (self.handler) {
                    self.handler();
                }
            }
                break;
            case DetailRefreshStateLoading: {
                _bottomLabel.text = @"释放，返回宝贝详情";
                [UIView animateWithDuration:0.2f animations:^{
                    [blockSelf.topImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
                }];
            }
                
                break;
            case DetailRefreshStateNormal:{
                _bottomLabel.text = @"下拉，返回宝贝详情";
                [UIView animateWithDuration:0.2f animations:^{
                    [blockSelf.topImageView setTransform:CGAffineTransformIdentity];
                }];
            }
                break;
                
            default:
                break;
        }
    }
}
@end


#pragma mark --
#pragma mark -- __DetailRefreshView

@implementation UIScrollView(__DetailRefreshView)

- (void)setRefreshView:(DetailRefreshView *)refreshView{
    objc_setAssociatedObject(self, @selector(refreshView), refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DetailRefreshView *) refreshView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void) addDetailRefreshWithHandler:(void (^)(void)) handler {
    if (!self.refreshView) {
        DetailRefreshView *detailRefreshView = [[DetailRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 64)];
        [self setRefreshView:detailRefreshView];
        self.refreshView.scrollView = self;
    }
    
    self.refreshView.handler = handler;
    [self addSubview:self.refreshView];
    [self sendSubviewToBack:self.refreshView];
}


@end
