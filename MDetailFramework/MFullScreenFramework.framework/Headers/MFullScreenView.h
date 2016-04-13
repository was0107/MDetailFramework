//
//  MFullScreenView.h
//  MFullScreenFramework
//
//  Created by Micker on 16/2/14.
//  Copyright © 2016年 b5m. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFullScreenView : UIView

@property (nonatomic, strong) UIScrollView  *scrollView;    //容器
@property (nonatomic, strong) UIImageView   *imageView;     //执行动画的图片视图
@property (nonatomic, assign, setter=enableDoubleTap:) BOOL isDoubleTapEnabled; //是否允许双击放大
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);   //单击的回调处理

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
