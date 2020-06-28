//
//  FYViewController.m
//  FYPopupController
//
//  Created by caofengyang on 06/10/2020.
//  Copyright (c) 2020 caofengyang. All rights reserved.
//

#import "FYViewController.h"
#import <FYPopupController/UIViewController+FYPopup.h>
#import "FYDemoContentViewController.h"

@interface FYViewController ()
@end

@implementation FYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)onClickPopupButton:(UIButton *)sender {
    [self show:[[FYDemoContentViewController alloc] init] style:FYPopupStyleRoundedCorner];
}

@end
