//
//  MFullScreenControl.h
//  MFullScreenFramework
//
//  Created by boguang on 15/8/20.
//  Copyright (c) 2015年 b5m. All rights reserved.
//

#include <UIKit/UIKit.h>
#import "UIScrollPageControlView.h"

@interface MFullScreenControl : NSObject

@property (nonatomic, strong) UIScrollPageControlView       *screenPageView;    //滚动视图
@property (nonatomic, assign) BOOL                           isAppear;          //记录当前状态

/**
*  从指定视图中，展开全屏浏览模式
*
*  @parames
*  @param  view     一般为UIImageView的对象
*
*  @return
*
*/
- (void) appearOnView:(UIView *) view;


/**
 *  从指定视图中，取消全屏浏览模式，带有动画效果
 *
 *  @parames
 *  @param  view     一般为UIImageView的对象
 *
 *  @return
 *
 */
- (void) disAppearOnView:(UIView *) view;

@end
