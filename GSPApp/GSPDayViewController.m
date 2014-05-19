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
#import "GSPDayView.h"
#import "GSPEvent.h"

#define HOUR_HEIGHT 65
#define HOURS_PER_DAY 24
#define MINUTES_PER_HOUR 60

@interface GSPDayViewController ()

@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSDateComponents *dayComp;
@property (strong, nonatomic) NSCalendar *calendar;

@property (strong, nonatomic) NSString *titleString;

@property (strong, nonatomic) UIScrollView *baseView;
@property (strong, nonatomic) GSPDayView *dayView;

@end

@implementation GSPDayViewController


-(id)initWithEvents:(NSMutableArray *)events andDateComponents:(NSDateComponents *)dateComps
{
    if (self = [super init]) {
        self.events = events;
        self.dayComp = dateComps;

        //TODO: Check for daylight savings time
    }
    return self;
}

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

-(GSPDayView *)dayView
{
    if (!_dayView) {
//        _dayView = [[GSPDayView alloc] initWithFrame:self.view.frame andHourHeight:HOUR_HEIGHT];
        _dayView = [[GSPDayView alloc] initWithFrame:CGRectMake(0, 0, [self getScreenBounds].size.width, HOUR_HEIGHT * HOURS_PER_DAY) andHourHeight:HOUR_HEIGHT];
    }
    return _dayView;
}

-(UIScrollView *)baseView
{
    if (!_baseView) {
        _baseView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    return _baseView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [self getScreenBounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.baseView.contentSize = self.dayView.frame.size;

    [self.baseView addSubview:self.dayView];
    [self.view addSubview:self.baseView];

//    NSLog(@"Content size: %@", NSStringFromCGSize(self.baseView.contentSize));
//    NSLog(@"Day view frame: %@", NSStringFromCGRect(self.dayView.frame));
    
    for (GSPEvent *event in self.events) {
        NSLog(@"Need to do something with events, %@", event);
        [self addEventIndicator:event];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.titleString;

    [self.navigationItem setTitleView:titleLabel];
}

-(void)addEventIndicator:(GSPEvent *)event
{
    NSDateComponents *comps = [self.calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:event.date];
    float hourPerMinute = 1/MINUTES_PER_HOUR;
    CGRect eventFrame = CGRectMake(0, (comps.hour + (hourPerMinute * comps.minute)) * HOUR_HEIGHT, [self getScreenBounds].size.width, HOUR_HEIGHT * 1.5);
    UIView *eventIndicator = [[UIView alloc] initWithFrame:eventFrame];
    eventIndicator.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.2];
    NSLog(@"%@", NSStringFromCGRect(eventFrame));
    [self.dayView addSubview:eventIndicator];
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


@end
