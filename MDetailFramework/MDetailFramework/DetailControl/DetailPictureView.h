//
//  DetailPictureView.h
//  DW
//
//  Created by boguang on 15/6/24.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailPictureViewState) {
    DetailPictureViewStateNormal,
    DetailPictureViewStateLoading,
    DetailPictureViewStateTriggerd
};

typedef NS_ENUM(NSInteger, DetailPictureViewAnimateType) {
    DetailPictureViewAnimateTypeAttachRight,        //右边吸住，靠近边框, 默认值
    DetailPictureViewAnimateTypeAttachLeft,         //左边吸住，跟随变化
    DetailPictureViewAnimateTypeSpeed1,             //差速1
    DetailPictureViewAnimateTypeSpeed2,             //差速2
};

#pragma mark --
#pragma mark DetailPictureView

@interface DetailPictureView : UIView

@property (nonatomic, strong) UILabel               *rightLabel;
@property (nonatomic, strong) UIImageView           *leftImageView;
@property (nonatomic, assign) UIScrollView          *scrollView;
@property (nonatomic, assign) DetailPictureViewState state;
@property (nonatomic, assign) DetailPictureViewAnimateType animateType;
@property (nonatomic, copy)  void (^handler)(void);

@end



#pragma mark --
#pragma mark __DetailPictureView

@interface UIScrollView(__DetailPictureView)

@property (nonatomic, strong, readonly) DetailPictureView *pictureView;

- (void) addDetaiPictureViewWithHandler:(void (^)(void)) handler;

@end



#pragma mark --
#pragma mark --Parallas

@interface ParallasObject : NSObject

@property (nonatomic, strong) UIScrollView    *scrollView;
@property (nonatomic, weak) UIView          *targetView;
@property (nonatomic, assign) BOOL          isVertical;
@property (nonatomic, copy)  void (^handler)(void);

@end


#pragma mark --
#pragma mark --UIScrollView(__Parallas)

@interface UIScrollView(__Parallas)

@property (nonatomic, strong) ParallasObject *parallas;

- (void) addHorizeParallas:(UIView *) targetView block:(void (^)(void))block ;

- (void) addVerticalParallas:(UIView *) targetView block:(void (^)(void))block ;

@end