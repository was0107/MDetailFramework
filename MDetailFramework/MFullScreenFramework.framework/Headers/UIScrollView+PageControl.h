//
//  UIScrollView+PageControl.h
//  DW
//
//  Created by boguang on 15/7/3.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (PageControl)

@property (nonatomic, strong, readonly) UIPageControl *pageControl;

/**
 *  显示Page控件
 *
 *  @return
 *
 */
- (void) showPageControl;

/**
 *  根据当前的contentSize 及 frame.size.width,计算页数
 *
 *  @return
 *
 */
- (void) computePageControlPages;

@end
