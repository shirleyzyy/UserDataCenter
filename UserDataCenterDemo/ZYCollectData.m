//
//  ZYCollectData.m
//  UserDataCenterDemo
//
//  Created by ZYY on 16/5/8.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import "ZYCollectData.h"

@implementation ZYCollectData
#pragma mark - SuperClass Override Methods
//重写description方法，打印出对象
- (NSString *)description{
    return [NSString stringWithFormat:@"ZYCollectData:programName:%@ ",self.programName];
}

//重写isEqual与hash方法
- (BOOL)isEqual:(id)object{
    if (!object) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    
    NSString *objectClass = NSStringFromClass([object class]);
    NSString *selfClass = NSStringFromClass([ZYCollectData class]);
    if ([objectClass isEqualToString:selfClass]) {
        ZYCollectData *temp = (ZYCollectData *)object;
        if ([temp.programName isEqualToString:self.programName]) {
            return YES;
        }
    }    
    return NO;
}

- (NSUInteger)hash{
    return [self.programName hash];
}

@end
