//
//  FYViewController.m
//  FYPopupController
//
//  Created by caofengyang on 06/10/2020.
//  Copyright (c) 2020 caofengyang. All rights reserved.
//

#import "FYViewController.h"
#import <FYPopupController/FYPopupController.h>
#import "FYDemoContentViewController.h"

@interface FYViewController ()

@property (nonatomic, strong) FYPopupController *popUpController;

@end

@implementation FYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)onClickPopupButton:(UIButton *)sender {
        
    UIViewController *contentViewController = [[FYDemoContentViewController alloc] init];
    self.popUpController = [[FYPopupController alloc] init];
    contentViewController.transitioningDelegate = _popUpController;
    contentViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:contentViewController animated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
