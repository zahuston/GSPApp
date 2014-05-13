//
//  CircleView.m
//  GSPApp
//
//  Created by Zach Huston on 5/9/14.
//  Copyright (c) 2014 Zach Huston. All rights reserved.
//

#import "CircleView.h"

@interface CircleView()

@property (strong, nonatomic) UIColor *color;

@end

@implementation CircleView

// Please use this initializer
- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)circleColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.color = circleColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Color defaults to white
-(UIColor *)color {
    // These colors need to be handled differently for CGColorGetComponents
    // to function properly
    if ([_color isEqual:[UIColor whiteColor]]) {
        _color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    if ([_color isEqual:[UIColor blackColor]]) {
        _color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    
    if (!_color) {
        _color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    return _color;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    rect = CGRectInset(rect, 1, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
//    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetFillColor(context, CGColorGetComponents([self.color CGColor]));
    CGContextSetStrokeColor(context, CGColorGetComponents([self.color CGColor]));
    CGContextSetLineWidth(context, 2.0);
    CGContextFillEllipseInRect (context, rect);
    CGContextStrokeEllipseInRect(context, rect);
    CGContextFillPath(context);
}

@end
