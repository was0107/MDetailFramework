//
//  DetailView.h
//  DW
//
//  Created by boguang on 15/6/23.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTipView.h"
#import <MFullScreenFramework/MFullScreenFramework.h>

/**
 *  Detail View Section Delegate
 */
@protocol DetailViewSectionDelegate <NSObject>

@required

/**
 *  顶部的滚动视图，此视图可以为如下值，UIWebView, UIScrollView及其之类
 *
 *  @return 视图
 */
- (UIView *) viewAtTop;

/**
 *  配置中间区间值的数量
 *
 *  @return 具体数量
 */
- (NSUInteger ) numberOfSections;

/**
 *  配置中间区间的标题
 *
 *  @param index 索引
 *
 *  @return 具体的标题
 */
- (NSString *) titleOfSectionAt:(NSUInteger )index;

@optional

/**
 *  配置区间中某个索引对应的视图，可以为空
 *
 *  @param index 索引
 *
 *  @return 具体的值，此视图可以为如下值，UIWebView, UIScrollView及其之类
 */
- (UIView *) viewOfSectionAt:(NSUInteger ) index;

/**
 *  配置区间之间，是否可以进行页面切换，若不能切换，则在此编写具体的业务逻辑
 *
 *  @param index 索引
 *
 *  @return 是否能够切换
 */
- (BOOL) canChangeToSection:(NSUInteger) index;

/**
 *  将要切换到某个区间
 *
 *  @param index 索引
 *  @param view  区间视图
 */
- (void) willChangeToSection:(NSUInteger) index view:(UIView *) view;

/**
 *  已经切换到某个区间
 *
 *  @param index 索引
 *  @param view  区间视图
 */
- (void) didChangeToSection:(NSUInteger) index view:(UIView *) view;


/**
 *  弹出层将要出现或者消失
 *
 *  @param appear 是否显示
 */
- (void) floatViewIsGoingTo:(BOOL) appear;

@end


#pragma mark --
#pragma mark -- DetailView

@interface DetailView : UIView
@property (nonatomic, weak) UIScrollView                                *topScrollView;         //最重要的视图，用于作各种效果
@property (nonatomic, weak) UIScrollView                                *imageScrollView;       //banner上的图片滚动视图
@property (nonatomic, strong, readonly) DetailTipView                   *tipView;               //中间的提示视图
@property (nonatomic, strong, readonly) UIScrollPageControlView         *topScrollPageView;     //banner视图，包含滚动视图和页面控件
@property (nonatomic, strong, readonly) MFullScreenControl            *fullScreencontrol;     //全屏浏览控件，内聚有查看更多功能，即将底部的section上移；
@property (nonatomic, strong, readonly) UIView                          *topView;               //顶部视图的容器
@property (nonatomic, strong, readonly) UIView                          *bottomView;            //底部视图的容器
@property (nonatomic, assign) CGFloat                                   startYPosition;         //Section与顶部的间隙，全屏是设置为64.0f，默认为0.0f
@property (nonatomic, assign) CGFloat                                   topScrollViewTopInset;  //banner的高度设置，默认为370.0f
@property (nonatomic, weak  ) id<DetailViewSectionDelegate>             delegate;               //代理

/**
 *  底部视图是否已经显示
 *
 *  @param appear 是否显示
 */
- (BOOL) isBottomViewShowed;

/**
 *  触发底部视图消失
 *
 *  @param appear 是否显示
 */
- (void) disappearBottomView;

/**
 *  显示图片的全屏浏览
 *
 *  @param view  触发的视图
 */
- (void) showFullScreenOnView:(UIView *) view;

/**
 *  隐藏图片的全屏浏览模式，
 *
 *  @param view  触发的视图  ||  如果view为空，则不显示动画效果，否则展示缩放的效果；
 */
- (void) hideFullScreenOnView:(UIView *) view;

/**
 *  刷新页面
 *
 */
- (void) reloadData;

@end
