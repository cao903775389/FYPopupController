//
//  FYPopupPresentTransition.h
//  FBSnapshotTestCase
//
//  Created by caofengyang on 2020/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYPopupPresentTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresenting;

@end

NS_ASSUME_NONNULL_END
