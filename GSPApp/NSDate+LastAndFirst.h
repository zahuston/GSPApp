//
//  NSDate+LastAndFirst.h
//  GSPEvents
//
//  Created by Zach Huston on 9/28/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LastAndFirst)

- (NSDate *) startOfMonth;
- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd;
- (NSDate *) endOfMonth;
- (NSDate *) standardizedDate;
@end
