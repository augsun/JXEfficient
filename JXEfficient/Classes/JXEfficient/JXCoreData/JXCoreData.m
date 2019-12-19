//
//  JXCoreData.m
//  JXEfficient
//
//  Created by augsun on 1/4/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXCoreData.h"
#import "JXInline.h"

@interface JXCoreData ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation JXCoreData

- (instancetype)initWithXcdatamodeldName:(NSString *)xcdatamodeldName inBundle:(NSBundle *)inBundle storePath:(NSString *)storePath {
    if (jx_strValue(xcdatamodeldName).length == 0 ||
        jx_strValue(storePath).length == 0) {
        return nil;
    }
    
    if (inBundle == nil) {
        inBundle = [NSBundle mainBundle];
    }

    self = [super init];
    if (self) {
        // 获取 .xcdatamodel 文件 URL
        NSURL *coreDataURL = [inBundle URLForResource:xcdatamodeldName withExtension:@"momd"];
        
        // 读取文件
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:coreDataURL];
        
        // 持久化存储协调者
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 nil];
        
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:[NSURL fileURLWithPath:storePath]
                                                            options:options
                                                              error:nil];
        
        // 创建数据管理上下文
        self.managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return self;
}

- (__kindof NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName {
    NSManagedObject *model = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    return model;
}

- (NSArray <id> *)fetchRequestWithEntityName:(NSString *)entityName predicate:(nullable NSPredicate *)predicate {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = predicate;
    NSArray <id> *objs = [self.managedObjectContext executeFetchRequest:request error:nil];
    return objs;
}

- (void)deleteObject:(__kindof NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

- (BOOL)save:(NSError *__autoreleasing  _Nullable *)error {
    BOOL ret = [self.managedObjectContext save:error];
    return ret;
}

@end
