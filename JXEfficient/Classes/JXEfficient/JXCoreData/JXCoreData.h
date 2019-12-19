//
//  JXCoreData.h
//  JXEfficient
//
//  Created by augsun on 1/4/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

/**
 使用方法
 1, 新建 XXX_NAME.xcdatamodeld 文件
 2, 在 XXX_NAME.xcdatamodeld 里创建 XXX_Entity
 3, 在 Show the File Inspector 中将 Code Generation / Language 设置为 Objective-C
 4, 为 XXX_Entity 添加表单字段
 */
@interface JXCoreData : NSObject

/**
 初始化
 
 @param xcdatamodeldName XXX_NAME.xcdatamodeld 的 XXX_NAME
 @param inBundle 文件所在 bundle 一般为 nil
 @param storePath 数据库保存位置
 @return JXCoreDatar 的实例对象
 */
- (nullable instancetype)initWithXcdatamodeldName:(NSString *)xcdatamodeldName inBundle:(nullable NSBundle *)inBundle storePath:(NSString *)storePath;

/**
 增
 
 @param entityName XXX_NAME.xcdatamodeld 里的表名称
 @return NSManagedObject 的实例对象
 */
- (__kindof NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName;

/**
 查 改 <查询到的数据可以修改>
 
 @param entityName XXX_NAME.xcdatamodeld 里的表名称
 @param predicate e.g. predicate = [NSPredicate predicateWithFormat:@"name = %@ and age = %ld and sex = %@", @"sun", 18, @"M"]
 @return NSManagedObject 的实例对象数组
 */
- (nullable NSArray <id> *)fetchRequestWithEntityName:(NSString *)entityName predicate:(nullable NSPredicate *)predicate;

/**
 删除
 
 @param object 查询到的 NSManagedObject 实例
 */
- (void)deleteObject:(__kindof NSManagedObject *)object;

/**
 [增 删 改] 后需调用 -save: 方法
 
 @return 执行是否成功
 */
- (BOOL)save:(NSError * _Nullable __autoreleasing * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
