//
//  FYDemoContentViewController.m
//  FYPopupController_Example
//
//  Created by caofengyang on 2020/6/10.
//  Copyright © 2020 caofengyang. All rights reserved.
//

#import "FYDemoContentViewController.h"

@interface FYDemoContentViewController ()

@property (nonatomic, strong) UISlider *slider;

@end

@implementation FYDemoContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor greenColor];
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 50, 200, 100)];
    self.slider.continuous = YES;
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 420);
    self.slider.maximumValue = self.preferredContentSize.height;
    self.slider.minimumValue = 220.f;
    self.slider.value = self.slider.maximumValue;
}

- (CGFloat)updatePercentForGesture:(UIPanGestureRecognizer *)gesture {
    return 0.f;
}

- (void)sliderValueChange:(UISlider*)sender {
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, sender.value);
}

@end
