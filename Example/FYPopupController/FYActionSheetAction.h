//
//  FYActionSheetAction.h
//  FYPopupController_Example
//
//  Created by caofengyang on 2020/6/28.
//  Copyright © 2020 caofengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FYActionSheetStyle) {
    FYActionSheetStyleDefault = 0,
    FYActionSheetStyleCancel
};

@protocol FYActionSheetActionViewProvider <NSObject>

// for subclass override
- (UIView * _Nullable)customActionView;

@end

@interface FYActionSheetAction : NSObject <FYActionSheetActionViewProvider>

@property (nonatomic, assign, readonly) FYActionSheetStyle style;
@property (nonatomic, copy, nullable, readonly) NSString *title;
@property (nonatomic, strong, readonly) UIView *actionSheetView;

+ (instancetype)actionWithTitle:(nullable NSString *)title
                      style:(FYActionSheetStyle)style
                    handler:(void (^ __nullable)(FYActionSheetAction *action))handler;

@end

NS_ASSUME_NONNULL_END
