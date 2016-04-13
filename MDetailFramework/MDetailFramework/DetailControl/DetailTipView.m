//
//  DetailTipView.m
//  DW
//
//  Created by boguang on 15/6/23.
//  Copyright (c) 2015年 micker. All rights reserved.
//

#import "DetailTipView.h"

@implementation DetailTipView {
    UIView *_leftLine , *_rightLine;
    CGFloat layerWidth;
    CGFloat layerSpace;
}

- (id) initWithFrame:(CGRect)frame {
    layerSpace = 15.0f;
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1];
        label.text = @"继续拖动，查看图文详情";
        label.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:label];
        
        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        layerWidth = (self.bounds.size.width -  size.width - layerSpace * 4) / 2 ;
        [self addLeftRightLayer];
    }
    return self;
}

- (void) addLeftRightLayer {
    UIColor *lineColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:0.7f];
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(layerSpace, self.bounds.size.height/2 - 1, layerWidth, 1)];
    _leftLine.backgroundColor = lineColor;
    [self addSubview:_leftLine];
    
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - layerSpace - layerWidth), self.bounds.size.height/2 - 1, layerWidth, 1)];
    _rightLine.backgroundColor = lineColor;
    [self addSubview:_rightLine];
}
@end
