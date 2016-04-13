//
//  DetailPictureView.m
//  DW
//
//  Created by boguang on 15/6/24.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "DetailPictureView.h"
#include <objc/runtime.h>


#pragma mark --
#pragma mark DetailPictureView

@interface DetailPictureView()
@property (nonatomic, assign) CGFloat originInsetY;
@property (nonatomic, assign) CGFloat thresHold;

@end

@implementation DetailPictureView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightLabel];
        self.thresHold = self.rightLabel.frame.origin.x + self.rightLabel.frame.size.width;
        self.animateType = DetailPictureViewAnimateTypeAttachRight;
    }
    return self;
}

- (UILabel *) rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 18, self.bounds.size.height)];
        _rightLabel.font = [UIFont systemFontOfSize:12.0f];
        _rightLabel.numberOfLines = 0;
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.text = @"滑动，查看图文详情";
        _rightLabel.backgroundColor = [UIColor clearColor];
    }
    return _rightLabel;
}

- (UIImageView *) leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.bounds.size.height - 25) / 2, 22, 22)];
        _leftImageView.backgroundColor = [UIColor clearColor];
        _leftImageView.image = [UIImage imageNamed:@"detail_left_loading"];
    }
    return _leftImageView;
}


- (void) didMoveToSuperview {
    if (!self.superview) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    } else {
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void) setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    self.originInsetY = scrollView.contentInset.top;
    [self setState:DetailPictureViewStateNormal];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewDidScroll:self.scrollView.contentOffset];
    }
}


- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    CGFloat scrollOffsetThreshold = self.scrollView.contentSize.width + self.thresHold - self.scrollView.bounds.size.width;
    if(!self.scrollView.isDragging && self.state == DetailPictureViewStateLoading)
        self.state = DetailPictureViewStateTriggerd;
    else if(contentOffset.x > scrollOffsetThreshold && self.scrollView.isDragging && self.state != DetailPictureViewStateLoading)
        self.state = DetailPictureViewStateLoading;
    else if(contentOffset.x <= scrollOffsetThreshold && self.state != DetailPictureViewStateNormal)
        self.state = DetailPictureViewStateNormal;
    
    CGFloat offset = contentOffset.x + self.scrollView.contentInset.right + self.scrollView.bounds.size.width - self.scrollView.contentSize.width;
    
    //move when cross the points
    if (offset >= self.bounds.size.width) {
        switch (self.animateType) {
            case DetailPictureViewAnimateTypeAttachRight:
                offset = self.bounds.size.width;
                break;
            case DetailPictureViewAnimateTypeAttachLeft:
                break;
            case DetailPictureViewAnimateTypeSpeed1:
                offset += (self.bounds.size.width - offset)/2 ;
                break;
            case DetailPictureViewAnimateTypeSpeed2:
                offset += (self.bounds.size.width - offset)/4 ;
                break;
                
            default:
                break;
        }
    }
    
    self.frame = CGRectMake(contentOffset.x + self.scrollView.bounds.size.width - offset,0, self.bounds.size.width, self.bounds.size.height);
}


- (void) setState:(DetailPictureViewState)state {
    if (_state != state) {
        _state = state;
        switch (_state) {
            case DetailPictureViewStateTriggerd: {
                if (self.handler) {
                    self.handler();
                }
            }
                break;
            case DetailPictureViewStateLoading: {
                _rightLabel.text = @"释放，查看图文详情";
                [UIView animateWithDuration:0.2f animations:^{
                    [_leftImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
                }];
            }
                
                break;
            case DetailPictureViewStateNormal:{
                _rightLabel.text = @"滑动，查看图文详情";
                
                [UIView animateWithDuration:0.2f animations:^{
                    [_leftImageView setTransform:CGAffineTransformIdentity];
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
#pragma mark -- UIScrollView(__DetailPictureView)

@implementation UIScrollView(__DetailPictureView)

- (void)setPictureView:(DetailPictureView *)pictureView {
    objc_setAssociatedObject(self, @selector(pictureView), pictureView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DetailPictureView *) pictureView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void) addDetaiPictureViewWithHandler:(void (^)(void)) handler {
    if (!self.pictureView) {
        DetailPictureView *detailRefreshView = [[DetailPictureView alloc] initWithFrame:CGRectMake(0, self.bounds.size.width, 64, self.bounds.size.height)];
        [self setPictureView:detailRefreshView];
        detailRefreshView.scrollView = self;
    }
    
    self.pictureView.handler = handler;
    [self addSubview:self.pictureView];
    [self bringSubviewToFront:self.pictureView];
}

@end


#pragma mark --
#pragma mark --Paralles

@implementation ParallasObject

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && self.targetView ) {
        [self scrollViewDidVerticalScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
}

- (void)scrollViewDidVerticalScroll:(CGPoint)contentOffset {
    CGRect  targetFrame         = self.targetView.frame;
    UIEdgeInsets contentInsets  = self.scrollView.contentInset;
    if (self.isVertical) {
        CGFloat frameY = - targetFrame.size.height;
        CGFloat offset =  - contentOffset.y - contentInsets.top;
//        if (offset< 0) {
//        offset *= -2.0f;// -2.0f the imageview will stop at the top; 匀速  | remove offset charge ,then will adapter to all direction
//        offset *= -3.0f;// -3.0f the imageview will stop at the top; 差速  | remove offset charge ,then will adapter to all direction
//            offset *= -4.0f;// -4.0f the imageview will stop at the top; 吸顶 | remove offset charge ,then will adapter to all direction
//        }
        targetFrame.origin.y = frameY + offset/4;
        _targetView.frame = targetFrame;
    }
}

- (void) dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void) setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

@end

#pragma mark --
#pragma mark --UIScrollView(__Parallas)

@implementation UIScrollView(__Parallas)

- (void) setParallas:(ParallasObject *)parallas {
    objc_setAssociatedObject(self, @selector(parallas), parallas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ParallasObject *) parallas {
    return objc_getAssociatedObject(self, _cmd);
}

- (void) addHorizeParallas:(UIView *) targetView block:(void (^)(void))block {
    if (!self.parallas) {
        ParallasObject *object = [[ParallasObject alloc] init];
        object.targetView = targetView;
        object.scrollView = self;
        object.handler = block;
        object.isVertical = NO;
        [self setParallas:object];
    }
}

- (void) addVerticalParallas:(UIView *) targetView block:(void (^)(void))block {
    if (!self.parallas) {
        ParallasObject *object = [[ParallasObject alloc] init];
        object.targetView = targetView;
        object.scrollView = self;
        object.handler = block;
        object.isVertical = YES;
        [self setParallas:object];
    }
}

@end