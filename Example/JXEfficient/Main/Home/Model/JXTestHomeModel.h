//
//  JXTestHomeModel.h
//  JXEfficient_Example
//
//  Created by augsun on 7/3/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTestHomeModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) Class vcClass;

+ (instancetype)modelFromVcClass:(Class)vcClass;

@end

NS_ASSUME_NONNULL_END
