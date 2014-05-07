//
//  GSPMonthView.h
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+LastAndFirst.h"

@class GSPMonthCell;
@class GSPMonthViewController;

@interface GSPMonthView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

/*
    Set of values used to initialize/format the calendar
    Relevant in the sense that it may be a month selected by the user other than the current
    Nonetheless, will still all be initialized ot the current date/time/what have you
*/
@property (strong, nonatomic) GSPMonthViewController *parent; // Breaking MVC, think I messed up in how this view was organized, more of this code should have been in the view controller itself
@property (strong, nonatomic) NSCalendar *relevantCalendar;
@property (strong, nonatomic) NSDate *relevantDate;
@property (strong, nonatomic) NSDateComponents *relevantDateComponents;
@property (strong, nonatomic) NSString *titleFormattedString;
@property (strong, nonatomic) UIViewController *parentViewController;

-(void)updateEvents:(NSDate *)date withNumEvents:(int)numEvents;
-(GSPMonthCell *)getCellForDate:(NSDate*)date;
-(int)adjustDateToCollectionViewIndex:(int)day;

@end


