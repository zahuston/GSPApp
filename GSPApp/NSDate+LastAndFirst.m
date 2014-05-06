//
//  NSDate+LastAndFirst.m
//  GSPEvents
//
//  Created by Zach Huston on 9/28/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//
//Category methods used from stack overflow post found here: http://stackoverflow.com/questions/10717574/get-firstdatelastdate-of-month
//standardizeDate self created

#import "NSDate+LastAndFirst.h"

@implementation NSDate (LastAndFirst)

-(NSDate *)startOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * currentDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: self];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    
    return startOfMonth;
}

- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    
    return [calendar dateByAddingComponents: months toDate: self options: 0];
}

- (NSDate *) endOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDate * plusOneMonthDate = [self dateByAddingMonths: 1];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1]; 
    
    return endOfMonth;
}

-(NSDate *) standardizedDate
{
    unsigned units = NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:self];
    [components setSecond:0]; [components setMinute:0];
    NSDate *standardizedDate = [calendar dateFromComponents:components];
    return standardizedDate;
}


@end
