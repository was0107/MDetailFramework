//
//  UIScrollPageControlView.h
//  DW
//
//  Created by boguang on 15/6/25.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+PageControl.h"


@class UIScrollPageControlView;

#pragma mark UIView(_reuseIdentifier)

@interface UIView(_reuseIdentifier)

@property (nonatomic, copy) NSString *reuseIdentifier;          //复用标识

@end

#pragma mark UIScrollPageControlViewDelegate

@protocol UIScrollPageControlViewDelegate <NSObject>

@required

/**
 *  配置复用视图总数
 *
 *  @parames    control     复用控件
 *
 *  @return     回当前控件的数量
 *
 */
- (NSUInteger) numberOfView:(UIScrollPageControlView *) control;

/**
 *  配置索引位置的视图，类似于UITableViewCell的生成方式
 *
 *  @parames    control     复用控件
 *  @parames    index       索引位置
 *
 *  @return     生成视图
 *
 */
- (UIView *) configItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index ;

@optional

/**
 *  设置视图之间的间隙
 *
 *  @parames    control     复用控件
 *
 *  @return     默认为0
 *
 */
- (CGFloat) minimumRowSpacing:(UIScrollPageControlView *) control;

/**
 *  配置正常呈现的视图，主要用于图片失去焦点时，进行场景还原操作，此方法有待优化
 *
 *  @parames    control     复用控件
 *  @parames    index       索引位置
 *  @parames    view        对应的视图
 *
 *  @return
 *
 */
- (void) reconfigItemOfControl:(UIScrollPageControlView *)control at:(NSUInteger) index withView:(UIView *)view;

@end

#pragma mark UIScrollPageControlView

@interface UIScrollPageControlView : UIView

@property (nonatomic, strong) UIScrollView                          *scrollView;
@property (nonatomic, assign) BOOL                                  enablePageControl;  //默认为YES
@property (nonatomic, assign) NSInteger                             currentIndex;       //当前展示
@property (nonatomic, assign, readonly) UIView                      *currentView;       //当前展示的视图
@property (nonatomic, assign) id<UIScrollPageControlViewDelegate>   delegate;

/**
 *  获取当前视图的宽度，此宽度会计算间隙
 *
 *  @parames
 *
 *  @return  宽度
 *
 */
- (CGFloat) itemWidth;

/**
 *  获取复用视图
 *
 *  @parames    identifier  复用标识
 *
 *  @return 如果复用池中存在可复用的视图，则返回复用对象，否则返回nil
 *
 */
- (UIView *) dequeueReusableViewWithIdentifier:(NSString *) identifier;

/**
 *  重新加载数据
 *
 *  @parames
 *
 *  @return
 *
 */
- (void) reloadData;

@end
