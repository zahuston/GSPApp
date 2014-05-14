//
//  GSPDayView.m
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#define SIDE_PADDING 5
#import "GSPDayView.h"

@interface GSPDayView()

@property CGFloat hourHeight;

@end

@implementation GSPDayView

- (id)initWithFrame:(CGRect)frame andHourHeight:(CGFloat)hourHeight
{
    if (self = [super initWithFrame:frame]) {
        self.hourHeight = hourHeight;
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(ctx, red);
    CGContextSetLineWidth(ctx, 2.0);
    
    for (int startLocation = 0; startLocation <= self.frame.size.height; startLocation += self.hourHeight)
    {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, SIDE_PADDING, startLocation);
        CGContextAddLineToPoint(ctx, self.frame.size.width - SIDE_PADDING, startLocation);
        CGContextStrokePath(ctx);
    }
    

}


@end
