//
//  ZYDataManager.m
//  UserDataCenterDemo
//
//  Created by ZYY on 16/5/8.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import "ZYDataManager.h"

@interface ZYDataManager()
{
    NSMutableArray *operateDataArray;//内部操控的数据数组
    NSInteger aMaxDataCount;
    NSInteger aEachPageNum;
    NSOperationQueue *queue;//所有数据操控均放在这个异步队列中执行
}

@end

@implementation ZYDataManager

#pragma mark - Instance Lifecycle

- (instancetype)init{
    self = [super init];
    if (self) {
        aMaxDataCount = self.maxDataCount;
        aEachPageNum = self.eachPageNum;
        operateDataArray = [NSMutableArray array];
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (void)addData:(id)data{
    //判断本地是否已有此数据，若有则先删除该条数据
    [self deleteDataIfExistWithData:data];
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        //判断数组是否已经到达上界,若达到上界，则删除最后的一个
        if (operateDataArray.count == aMaxDataCount) {
            [operateDataArray removeLastObject];
        }
        //将新数据插入到最前
        [operateDataArray insertObject:data atIndex:0];
        NSLog(@"加入数据成功，当前数据为:%@",operateDataArray);
    }];
    [queue addOperation:blockOperation];
}

- (NSArray *)getDataWithPageNum: (NSInteger)pageNum{
    __block NSArray *pageArray = [[NSArray alloc] init];
    if (aEachPageNum < 1) {
        return pageArray;
    }
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        if (!operateDataArray.count) {
            return;
        }
        //判断用户请求的页数是否超过本身的页数，若超过返回空，若不超过，返回该页的数据
        if (pageNum <= operateDataArray.count/aEachPageNum+1 && pageNum >0) {
            NSInteger startIndex = (pageNum-1) * self.eachPageNum;
            NSInteger endRange;
            if ((operateDataArray.count - startIndex) < aEachPageNum) {
                endRange = operateDataArray.count - startIndex;
            } else {
                endRange = aEachPageNum;
            }
            pageArray = [operateDataArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endRange)]];
        }
    }];
    [queue addOperations:@[blockOperation] waitUntilFinished:YES];
    return pageArray;
}

- (void)deleteData:(id)data{
    [self deleteDataIfExistWithData:data];
}

- (void)deleteAllData{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [operateDataArray removeAllObjects];
    }];
    [queue addOperation:blockOperation];
}


#pragma mark - Pivate Methods
//判断本地是否已有此数据，若有则先删除该条数据
- (void)deleteDataIfExistWithData:(id)data{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        //判断是否存在此对象，若存在，则删除对应的对象
        if ([operateDataArray containsObject:data]) {
            [operateDataArray removeObject:data];
            NSLog(@"删除数据成功，当前数据为:%@",operateDataArray);
        }
    }];
    [queue addOperations:@[blockOperation] waitUntilFinished:YES];
}

@end
