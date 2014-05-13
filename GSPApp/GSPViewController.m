//
//  GSPViewController.m
//  GSPEvents
//
//  Created by Zach Huston on 9/9/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPViewController.h"

@interface GSPViewController ()

@end

@implementation GSPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.monthVC = [[GSPMonthViewController alloc] init];
    self.title = @"Nav Controller";
    [self addChildViewController:self.monthVC];
    [self pushViewController:self.monthVC animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Received memory warning");
    // Dispose of any resources that can be recreated.
}

@end
