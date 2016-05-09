//
//  ZYDataManager.h
//  UserDataCenterDemo
//
//  Created by ZYY on 16/5/8.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZYDataManagerProtocol <NSObject>
@required
/**
 *  子类来创建单例，并在单例中初始化父类，保证每一单例都拥有单独的内存空间
 *
 *  @return 返回子类单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  为maxDataCount的get方法，由子类来重写此方法，设置保存的数据最大数量
 *
 *  @return 返回保存的最大数目值
 */
- (NSInteger)maxDataCount;

/**
 *  为eachPageNum的get方法，由子类来重写此方法，设置每页显示的数据数
 *
 *  @return 返回每页返回的数据数目
 */
- (NSInteger)eachPageNum;

@end

@interface ZYDataManager : NSObject

//数据的最大保存数量
@property (nonatomic, readonly) NSInteger maxDataCount;

//每页的数据数目
@property (nonatomic, readonly) NSInteger eachPageNum;


/**
 *  添加一条数据
 *
 *  @param data 为自定义数据类
 */
- (void)addData:(id)data;

/**
 *  根据页数请求数据
 *
 *  @param pageNum 请求的页数
 *
 *  @return 页数从1开始，当请求页数大于数据本身的页数时，返回为空，否则返回此页上的数据
 */
- (NSArray *)getDataWithPageNum:(NSInteger)pageNum;

/**
 *   删除一条数据
 *   本方法会先查询数据是否存在，所以无需外界再做查询的工作
 *  @param data 需要删除的数据对象
 */
- (void)deleteData:(id)data;

/**
 *  删除所有数据
 */
- (void)deleteAllData;

@end
