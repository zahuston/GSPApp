//
//  GSPDayViewController.h
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPDayViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

-(id)initWithEvents:(NSMutableArray *)events andDateComponents:(NSDateComponents *)dateComps;

@end
