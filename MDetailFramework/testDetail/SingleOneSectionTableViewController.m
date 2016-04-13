//
//  SingleOneSectionTableViewController.m
//  B5MDetailFramework
//
//  Created by Micker on 16/4/13.
//  Copyright © 2016年 micker. All rights reserved.
//

#import "SingleOneSectionTableViewController.h"

@implementation SingleOneSectionTableViewController

- (void) dealloc {
    NSLog(@"SingleOneSectionTableViewController.h dealloc");
}

//仅返回1
- (NSUInteger ) numberOfSections {
    return 1;
}

@end
