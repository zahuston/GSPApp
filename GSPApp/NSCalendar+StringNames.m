//
//  NSCalendar+StringNames.m
//  GSPApp
//
//  Created by Zach Huston on 5/13/14.
//  Copyright (c) 2014 Zach Huston. All rights reserved.
//

#import "NSCalendar+StringNames.h"


@implementation NSCalendar (StringNames)

+(NSArray *)monthNames
{
    return @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
}

+(NSArray *)weekdays {
    return @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
}

@end



