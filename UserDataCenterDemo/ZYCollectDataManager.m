//
//  ZYCollectDataManager.m
//  UserDataCenterDemo
//
//  Created by ZYY on 16/5/8.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import "ZYCollectDataManager.h"

@implementation ZYCollectDataManager
#pragma mark - DataManagerProtocol
+ (instancetype)sharedInstance{
    static dispatch_once_t predicate;
    static ZYCollectDataManager *instance = nil;
    dispatch_once(&predicate, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

-(instancetype) initUniqueInstance {
    return [super init];
}


- (NSInteger)maxDataCount{
    return 10;
}

- (NSInteger)eachPageNum{
    return 5;
}
@end
