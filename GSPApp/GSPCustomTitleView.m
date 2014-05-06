//
//  GSPCustomTitleView.m
//  GSPEvents
//
//  Created by Zach Huston on 12/29/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPCustomTitleView.h"
#import "UIColor+HexString.h"

@implementation GSPCustomTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor colorFromHexString:@"4c8ab8"]; //Hex: 0x009ACD
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont fontWithName:@"Helvetica" size:23.0f];
        
        [self.layer setBorderColor:[[UIColor lightGrayColor] colorWithAlphaComponent:.4].CGColor];
        [self.layer setBorderWidth:1.0f];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

}
 */

@end
