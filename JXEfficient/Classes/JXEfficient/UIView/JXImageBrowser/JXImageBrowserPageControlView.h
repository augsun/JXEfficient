//
//  JXImageBrowserPageControlView.h
//  JXEfficient
//
//  Created by augsun on 1/29/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 JXEfficient Internal Use Class.
 */
@interface JXImageBrowserPageControlView : UIView

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL hidesForSinglePage;

@end

NS_ASSUME_NONNULL_END
