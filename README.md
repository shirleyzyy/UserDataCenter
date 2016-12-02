# UserDataCenter
A demo using archive to realize some data operations such as add,delete,search,archive to files...
一个基于归档实现的小型本地数据存储方案需要新建的类需要实现基类的数据协议，就拥有了基类提供的所有数据管理方案。类似于基类为工厂，子类为订货商的实现。		
原文地址：http://www.jianshu.com/p/16f15fd0a12f
*参考书籍：《Head First Design Patterns》*
	
OO设计原则：

1.多组合，少继承

2.针对接口编程，不对实现编程

3.松耦合

4.类对扩展开放对修改关闭

5.依赖抽象不依赖具体
	
*实际项目需求：用户数据中心设计，存储一般用户的操作历史，个人信息，收藏等数据。*
下图为所有数据类型及功能比较：
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1918592-d5ad13f76be239ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
    先具体的分析需求，将需求归纳比较，找出公共的部分及必须依赖的部分：
		
   相同点：初步的一看，貌似像上图所示的那样，预约数据与收藏数据是数据分页需求的，比如添加一个“显示更多”的按钮，且这两种数据好像是不需要进行排序的，每次加入的数据排到队尾即可，但观看历史和常看频道及搜索历史这三种数据是由明确的排序需求的，我想最近观看的历史必须放到最前面，乍一看的确是这样。但是可以用归纳总结的方式来想一想，预约数据和收藏数据有分页需求，但是观看历史也许很少，并没有分页需求，所以若设计一个能满足所有数据类型需求的大工厂的话，必须讲究更加细则的需求，即为所有的数据提供分页功能，类似于观看历史这样的少量的数据就可以全部放在第一页中了，即第一页数据就放置所有的数据。再说排序功能，既然搜索历史和观看记录这样的对排序有着严格的需求，所以工厂必须提供此方法，至于预约数据与收藏甚至未来会出现的更多的没有排序需求的数据，也得满足排序的需求，而且，我相信从一位用户的角度来看，我将您最近预约的数据放在第一个，相信用户也是不会在意的，说不定体验更好。
	 
不同点：每种数据总归是有很多不同的地方，所以在开始构造工厂框架之前，就要先尽量多的考虑到数据间的不同之处，这些是工厂无法提供包办的地方。比如：数据存贮的最大数量，每页数据的数目等等。

    下面先给出我最初的设计思路，这种思路很简单，几乎是听到需求后所有新手都会想到的：
     就拿收藏和历史来说吧：
历史数据类m文件：
```
#import"HistoryDataManager.h"
@interfaceHistoryDataManager()
{
  NSMutableArray*dataArr;
}
@end
@implementationHistoryDataManager
- (void)addData:(NSString*)data{
  [dataArr addObject:data];
}
- (void)deleteData:(NSString*)data{
  [dataArr removeObject:data];
}
@end
```
收藏数据类m文件：
```
#import"CollectDataManager.h"
@interfaceCollectDataManager()
{
  NSMutableArray*dataArr;
}
@end
@implementationCollectDataManager
- (void)addData:(NSString*)data{
  [dataArr addObject:data];
}
- (void)deleteData:(NSString*)data{
  [dataArr removeObject:data];
}
@end
```
   使用时将两个类定义为单例来调用，可以清楚地感受到，这样做对业务层来说接口简单，易理解，但是仔细的看两个类的实现中，有大部分功能是完全一样的，甚至接口可以定义的一模一样，那这样，是否能将这部分重复的功能归纳出一个框架呢，那么所有的数据就不用再自己实现一遍这些公有的功能了，这就是我想用工厂模式来解决这个需求的初衷。下面讲讲我是怎样避免大段重复的代码，尽量精简的完成类似功能的类的构建的吧。
	 
   首先建立一个工厂，尽量满足所有的数据类的需求，但是也正是因为这一点，这个工厂的拓展性不如我预期的好，关于工厂模式下对于工厂的拓展方面希望能得到更好的指点。同时，考虑到OC中并不存在抽象类，但是我想让所有的数据类都拥有我提供的方法，那么必须用继承来实现了，其次，关于上述中提到的除了共同之处还有很多不同之处存在的，而这些不同就用OC中的协议方式来实现。下面贴出工厂的伪代码：
	 
工厂协议声明：
```
@protocol ZYDataManagerProtocol 
@required
/**
*子类来创建单例，并在单例中初始化父类，保证每一单例都拥有单独的内存空间
*
*@return返回子类单例对象
*/
+ (instancetype)sharedInstance;
/**
*为maxDataCount的get方法，由子类来重写此方法，设置保存的数据最大数量
*
*@return返回保存的最大数目值
*/
- (NSInteger)maxDataCount;
/**
*为eachPageNum的get方法，由子类来重写此方法，设置每页显示的数据数
*
*@return返回每页返回的数据数目
*/
- (NSInteger)eachPageNum;
```
工厂类中的添加数据，获取数据以及删除数据方法举例：
```
- (void)addData:(id)data{
//判断本地是否已有此数据，若有则先删除该条数据
  [self deleteDataIfExistWithData:data];
//判断数组是否已经到达上界,若达到上界，则删除最后的一个
  if(operateDataArray.count==aMaxDataCount) {
    [operateDataArray removeLastObject];
  }
//将新数据插入到最前
   [operateDataArray insertObjectAtIndex:0];
}
- (NSArray*)getDataWithPageNum: (NSInteger)pageNum{
  NSArray *pageArray = [[NSArray alloc] init];
  if(aEachPageNum<1) {
     return pageArray;
  }
  if(!operateDataArray.count) {
    return;
  }
//判断用户请求的页数是否超过本身的页数，若超过返回空，若不超过，返回该页的数据
  if(pageNum <=operateDataArray.count/aEachPageNum+1&& pageNum >0) {
      NSInteger startIndex = (pageNum-1) *self.eachPageNum;
      NSInteger endRange;
      if((operateDataArray.count- startIndex)
      endRange =operateDataArray.count- startIndex;
  }else{
    endRange =aEachPageNum;
  }
  pageArray = [operateDataArray objectsAtIndexes:[NSIndex SetindexSetWithIndexesInRange:NSMakeRange(startIndex, endRange)]];
}
  return pageArray;
}
- (void)deleteData:(id)data{
  [self deleteDataIfExistWithData:data];
}
- (void)deleteAllData{
  [operateDataArray removeAllObjects];
}];
}
- (BOOL)isDataExist:(id)data{
  BOOL ifExist =NO;
  if([operateDataArray containsObject:data]) {
    ifExist =YES;
  }
  return ifExist;
}
#pragma mark - Private Methods
//判断本地是否已有此数据，若有则先删除该条数据
- (void)deleteDataIfExistWithData:(id)data{
//判断是否存在此对象，若存在，则删除对应的对象
  if([operateDataArray containsObject:data]) {
    [operateDataArray removeObject:data];
  }
}
```
子类继承后需要自己实现工厂的协议，就像你要开一家加盟店，但是首先得遵循总店的要求，总店也必须知道你这家加盟店所要买的商品数量等。

子类伪代码如下：
```
@implementation ZYHistoryDataManager
#pragma mark - DataManagerProtocol
+ (instancetype)sharedInstance{
  static dispatch_once_t predicate;
  static ZYHistoryDataManager *instance =nil;
  dispatch_once(&predicate, ^{
    instance = [[super alloc] initUniqueInstance];
  });
  return instance;
}
-(instancetype) initUniqueInstance {
  return[super init];
}
- (NSInteger)maxDataCount{
  return20;
}
- (NSInteger)eachPageNum{
  return10;
}
```
   
   即实现单例和父类所定义的协议方法就OK了，在实际的项目中，这个工厂同时为近十种数据提供服务，目前未出现重大的bug，但是如果希望代码得到更好的精简的话我建议将工厂中操控可遍数组的queue设置为其他类的单例，因为所有的数据操作都由这个工厂完成，然而工厂只有一个，换句话说，对于对数据存储效率不高的情况下，完全可以工厂只持有一个queue，而不是为所有的子类新建queue，这个唯一的queue保持串行执行就OK了，这个我也试验过，也是可以的。暂时就记录这些了，也许我说的并不深刻，但是我有一颗虚心学习的心，欢迎各路大侠指点迷境^_^!
