//
//  GSPMonthCell.m
//  GSPEvents
//
//  Created by Zach Huston on 9/22/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPMonthCell.h"
#import "NSDate+LastAndFirst.h"
#import <QuartzCore/QuartzCore.h>


@interface GSPMonthCell()

@property int dayOfMonth;
@property int eventsCount;
@property bool initialized;

@end

@implementation GSPMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.contentView.layer setBorderWidth:1.0f];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (colorSpace,
    (const CGFloat[8]){.99f, .99f, .99f, 1.0f, .9f, .9f, .9f, 1.0f},
    (const CGFloat[2]){0.0f,1.0f},
    2);

    CGContextDrawLinearGradient(context,
    gradient,
    CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)),
    CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
    0);

    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
    self.initialized = true;
}

-(void)initializeCellContentsFor:(NSInteger)dayOfMonth andWith:(NSInteger)numberOfEvents
{
    //FIXME: Not receiving all of the days currently. Not this function's fault
    self.dayOfMonth = dayOfMonth;
    if (dayOfMonth > 0)
    {
        NSString *dayString = [NSString stringWithFormat:@"%i", dayOfMonth];
        UILabel *daylabel = [[UILabel alloc] initWithFrame:CGRectMake(2, -4, 20, 20)];
        daylabel.text = dayString;
        daylabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
        daylabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:daylabel];
        [self drawEvents:numberOfEvents];
    }
    else {
        self.contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.3];
    }
}

-(void)drawEvents:(int)numberOfEvents
{
    CGFloat startPoint = self.contentView.frame.size.width / 2;
    if (numberOfEvents % 2) //odd
    {
        startPoint -= (EVENT_INDICATOR_SPACING) / 2 + (EVENT_INDICATOR_SIZE + EVENT_INDICATOR_SPACING) * numberOfEvents/2 - EVENT_INDICATOR_SPACING;
    } else {
        startPoint -= EVENT_INDICATOR_SPACING / 2 + EVENT_INDICATOR_SIZE / 2;
    }
    for (int i = 0; i < MIN(4, numberOfEvents); i++)
    {
        UIView *eventSquare = [[UIView alloc] initWithFrame:CGRectMake(startPoint, self.contentView.frame.size.height - 12, EVENT_INDICATOR_SIZE, EVENT_INDICATOR_SIZE)];
        eventSquare.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.4];
        [self.contentView addSubview:eventSquare];
        startPoint += EVENT_INDICATOR_SIZE + EVENT_INDICATOR_SPACING;
    }
}

@end
