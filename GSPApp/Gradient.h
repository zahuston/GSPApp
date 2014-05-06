//
//  Gradient.h
//  GSPEvents
//
//  Created by Zach Huston on 12/24/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gradient : UIView

-(id)initWithColors:(NSArray *)colors Locations:(NSArray *)locations andView:(UIView *)view;
//-(void)drawGradientInRect:(UIView *)view; Now a private method, called by the gradients own draw rect.

/*
typedef struct {
    CGFloat *components;
    int size;
} colorArray;
 */

@property (nonatomic) CGFloat* colors;
@property (nonatomic) CGFloat* locations;
@property (strong, nonatomic) UIView *associatedView;

@end
