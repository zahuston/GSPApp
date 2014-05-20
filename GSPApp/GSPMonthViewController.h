//
//  GSPMonthViewController.h
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FORM_PADDING 10
#define FORM_HEIGHT 30

#define GREYED_OUT -1

@interface GSPMonthViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UICollectionView *MonthView;

// Event related properties
@property (strong, nonatomic) NSMutableDictionary *events; //Map NSDate -> NSArray of GSPEvents
@property (strong, nonatomic) UITextField *eventName;
@property (strong, nonatomic) UITextField *eventDescription;
@property (strong, nonatomic) UITextField *eventLocation;
//@property (strong, nonatomic) UISlider *eventHours;
@property (strong, nonatomic) UISlider *eventMinutes;
@property (strong, nonatomic) UIDatePicker *eventDate;
@property (strong, nonatomic) UIViewController *eventForm;

/*
    Calendar properties
    Relevant in the sense that it may be a month selected by the user other than the current
    Nonetheless, will still all be initialized ot the current date/time/what have you
*/
@property (strong, nonatomic) NSCalendar *relevantCalendar;
@property (strong, nonatomic) NSDate *relevantDate;
@property (strong, nonatomic) NSDateComponents *relevantDateComponents;
@property (strong, nonatomic) NSString *titleFormattedString;


-(int)eventCountForDate:(NSDate *)date;

@end
