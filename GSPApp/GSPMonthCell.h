//
//  GSPMonthCell.h
//  GSPEvents
//
//  Created by Zach Huston on 9/22/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EVENT_INDICATOR_SPACING 3
#define EVENT_INDICATOR_SIZE 5

@interface GSPMonthCell : UICollectionViewCell

-(void)initializeCellContentsFor:(NSInteger)dayOfMonth andWith:(NSInteger)numberOfEvents;
-(void)drawEvents:(int)numberOfEvents;

@end
