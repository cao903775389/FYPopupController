//
//  FYActionSheetAction.m
//  FYPopupController_Example
//
//  Created by caofengyang on 2020/6/28.
//  Copyright © 2020 caofengyang. All rights reserved.
//

#import "FYActionSheetAction.h"

@interface FYActionSheetView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FYActionSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

- (void)setUp {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
}

@end

@interface FYActionSheetAction ()

@property (nonatomic, assign) FYActionSheetStyle style;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy) void (^handler)(FYActionSheetAction *);
@property (nonatomic, strong) UIView *actionSheetView;

@end

@implementation FYActionSheetAction

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(FYActionSheetStyle)style
                        handler:(void (^ __nullable)(FYActionSheetAction *action))handler {
    return [[FYActionSheetAction alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString * _Nullable)title
                        style:(FYActionSheetStyle)style
                      handler:(void (^ __nullable)(FYActionSheetAction *action))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
        _actionSheetView = [self customActionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_actionSheetView addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)customActionView {
    FYActionSheetView *view = [[FYActionSheetView alloc] init];
    view.titleLabel.text = self.title;
    return view;
}

#pragma mark - event response
- (void)tapAction {
    if (self.handler) {
        self.handler(self);
    }
}

@end
