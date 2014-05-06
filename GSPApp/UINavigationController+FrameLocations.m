//
//  UINavigationController+FrameLocations.m
//  GSPEvents
//
//  Created by Zach Huston on 1/8/14.
//  Copyright (c) 2014 Zach Huston. All rights reserved.
//

#import "UINavigationController+FrameLocations.h"

@implementation UINavigationController (FrameLocations)

-(CGFloat)endY
{
    return self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height;
}

@end
