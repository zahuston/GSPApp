//
//  GSPMonthViewController.h
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPMonthView.h"

#define FORM_PADDING 10
#define FORM_HEIGHT 30

@interface GSPMonthViewController : UIViewController
@property (strong, nonatomic) GSPMonthView *MonthView;
@property (strong, nonatomic) NSMutableDictionary *events; //Map NSDate -> NSArray of GSPEvents
@property (strong, nonatomic) UITextField *eventName;
@property (strong, nonatomic) UITextField *eventDescription;
@property (strong, nonatomic) UITextField *eventLocation;
@property (strong, nonatomic) UIDatePicker *eventDate;
@property (strong, nonatomic) UIViewController *eventForm;
@end
