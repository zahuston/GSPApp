//
//  GSPDayView.m
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

//TODO: Leave this around for a bit for if I change my mind. Clear it out later
#define SIDE_PADDING 0
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
    int hour = 1;
    for (int startLocation = 0; startLocation <= self.frame.size.height; startLocation += self.hourHeight)
    {
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        float red = 211.0/256.0;
        float green = 211.0/256.0;
        float blue = 211.0/256.0;
        
        CGFloat color[4] = {red, green, blue, 1.0f};
        CGContextSetStrokeColor(ctx, color);
        CGContextSetLineWidth(ctx, 1.0);
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, SIDE_PADDING, startLocation);
        CGContextAddLineToPoint(ctx, self.frame.size.width - SIDE_PADDING, startLocation);
        CGContextStrokePath(ctx);
        
        NSString *hourMark = [NSString stringWithFormat:@"%d", hour++];
        [hourMark drawAtPoint:CGPointMake(SIDE_PADDING, startLocation + 3)
               withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:11.0]}];
    }
    

}



@end
