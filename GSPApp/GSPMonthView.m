//
//  GSPMonthView.m
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPMonthView.h"
#import "GSPMonthCell.h"
#import "GSPMonthViewController.h"



@interface GSPMonthView()

@end

@implementation GSPMonthView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setFrame:frame];

        UICollectionViewLayout *tempLayout = [[UICollectionViewLayout alloc] init];
        self.collectionViewLayout = tempLayout;
        

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.frame = frame;
        self.collectionViewLayout = layout;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"init with coder called");
    return self;
}



#pragma mark - Delegate

@end
