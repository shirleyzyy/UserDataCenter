//
//  ZYHistoryDataManager.m
//  UserDataCenterDemo
//
//  Created by ZYY on 16/5/8.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import "ZYHistoryDataManager.h"

@implementation ZYHistoryDataManager
#pragma mark - DataManagerProtocol
+ (instancetype)sharedInstance{
    static dispatch_once_t predicate;
    static ZYHistoryDataManager *instance = nil;
    dispatch_once(&predicate, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

-(instancetype) initUniqueInstance {
    return [super init];
}


- (NSInteger)maxDataCount{
    return 20;
}

- (NSInteger)eachPageNum{
    return 10;
}
@end
