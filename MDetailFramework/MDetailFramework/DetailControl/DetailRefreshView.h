//
//  DetailRefreshView.h
//  DW
//
//  Created by boguang on 15/6/23.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailRefreshState) {
    DetailRefreshStateNormal,
    DetailRefreshStateLoading,
    DetailRefreshStateTriggerd
};

typedef NS_ENUM(NSInteger, DetailRefreshViewAnimateType) {
    DetailRefreshViewAnimateTypeAttachTop,          //吸顶, 默认值
    DetailRefreshViewAnimateTypeAttachBottom,       //跟随底部
    DetailRefreshViewAnimateTypeSpeed1,             //差速，速度是底部的1/3速度；难于滑动
    DetailRefreshViewAnimateTypeSpeed2,             //差速，是底部的1/2速度；易于滑动
};

#pragma mark --
#pragma mark DetailRefreshView

@interface DetailRefreshView : UIView
@property (nonatomic, strong) UILabel               *bottomLabel;
@property (nonatomic, strong) UIImageView           *topImageView;
@property (nonatomic, assign) UIScrollView          *scrollView;
@property (nonatomic, assign) DetailRefreshState    state;
@property (nonatomic, assign) DetailRefreshViewAnimateType    animateType;
@property (nonatomic, copy)  void (^handler)(void);

@end


#pragma mark --
#pragma mark __DetailRefreshView


@interface UIScrollView(__DetailRefreshView)

@property (nonatomic, strong, readonly) DetailRefreshView *refreshView;

- (void) addDetailRefreshWithHandler:(void (^)(void)) handler;

@end