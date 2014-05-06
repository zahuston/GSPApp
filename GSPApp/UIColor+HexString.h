//
//  UIColor+HexString.h
//  GSPEvents
//
//  Created by Zach Huston on 12/24/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *) colorFromHexString: (NSString *) hexString;

@end
