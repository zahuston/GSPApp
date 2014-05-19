//
//  GSPEvent.h
//  GSPEvents
//
//  Created by Zach Huston on 10/1/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum event_types {
    Lecture = 0,
    CGMeeting = 1,
    Informal = 2, 
} eventTypes;



@interface GSPEvent : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate   *date;
@property (strong, nonatomic) UIColor  *eventColor;
@property (strong, nonatomic) NSNumber *length;
@property (nonatomic) eventTypes type;

- (id) initWithTitle:(NSString *)title
         Description:(NSString *)desc
                Date:(NSDate *)date
               Color:(UIColor *)color
              OfType:(eventTypes)type;

@end
