//
//  GSPDayViewController.m
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPDayViewController.h"
#import "NSCalendar+StringNames.h"
#import "GSPDayEventCell.h"

#define HOUR_HEIGHT 65
#define HOURS_PER_DAY 24

@interface GSPDayViewController ()

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSDateComponents *dayComp;
@property (strong, nonatomic) NSCalendar *calendar;

@property (strong, nonatomic) NSString *titleString;

@end

@implementation GSPDayViewController


-(id)initWithEvents:(NSMutableArray *)events andDateComponents:(NSDateComponents *)dateComps
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.events = events;
        self.dayComp = dateComps;
        //TODO: Check for daylight savings time
    }
    return self;
}

//-(NSDateComponents *)dayComp
//{
//    if (!_dayComp) {
//        _dayComp = [self.calendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:self.day];
//    }
//    return _dayComp;
//}

-(NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _calendar;
}

-(NSString *)titleString
{
    if (!_titleString) {
        NSString *month = [NSCalendar monthNames][self.dayComp.month - 1];
        NSLog(@"Weekday: %d", self.dayComp.weekday);
        NSString *dayOfWeek = [NSCalendar weekdays][self.dayComp.weekday];
        
        _titleString = [NSString stringWithFormat:@"           %@, %@ %d", dayOfWeek, month, self.dayComp.day];
    }
    return _titleString;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 0, [self getScreenBounds].size.width, HOUR_HEIGHT * HOURS_PER_DAY);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView registerClass:[GSPDayEventCell class] forCellReuseIdentifier:@"GSPDayTable"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.titleString;

    [self.navigationItem setTitleView:titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                     
-(CGRect)getScreenBounds
{
    return [[UIScreen mainScreen] bounds];
}

#pragma mark - Data Source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GSPDayTable"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return HOURS_PER_DAY;
}

#pragma mark - Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HOUR_HEIGHT;
}

@end
