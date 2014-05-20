//
//  GSPEvent.m
//  GSPEvents
//
//  Created by Zach Huston on 10/1/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPEvent.h"

@implementation GSPEvent

- (id) initWithTitle:(NSString *)title
         Description:(NSString *)desc
                Date:(NSDate *)date
               Color:(UIColor *)color
              OfType:(eventTypes)type
              Length:(NSNumber *)length
{
    if (self = [super init])
    {
        self.title = title;
        self.description = desc;
        self.date = date;
        self.eventColor = color;
        self.type = type;
        NSNumber *hoursVal = [[NSNumber alloc] initWithFloat:[length floatValue] / 60];
        self.length = hoursVal;
    }
    return self;
}



@end
