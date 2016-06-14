//
//  DetailLocalizable.m
//  MDetailFramework
//
//  Created by Micker on 16/6/14.
//  Copyright © 2016年 micker. All rights reserved.
//

#import "DetailLocalizable.h"

@implementation DetailLocalizable

+ (NSString *) localizStringKey:(NSString *)key comment:(NSString *) comment{
    NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"Detail" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    
    NSString *result =  NSLocalizedStringFromTableInBundle(key, @"Root", resourceBundle, comment);
    if ([result length] == 0) {
        result = comment;
    }
    return result;
}
@end
