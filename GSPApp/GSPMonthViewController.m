//
//  GSPMonthViewController.m
//  GSPEvents
//
//  Created by Zach Huston on 9/10/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPMonthViewController.h"
#import "GSPMonthCell.h"
#import "GSPEvent.h"
#import <QuartzCore/QuartzCore.h>
#import "GSPViewController.h"
#import "GSPDayViewController.h"
//#import "GSPCustomTitleView.h"
#import "NSCalendar+StringNames.h" // Don't want to touch date formatter..
#import "Gradient.h"

#import "UINavigationController+FrameLocations.h"
#import "UIColor+HexString.h"
#include "NSDate+LastAndFirst.h"

#define DAYS_PER_WEEK 7

@interface GSPMonthViewController ()
@property (nonatomic) int numRows;
@property (nonatomic) NSNumber *offset;
@property BOOL formatted;
@property (nonatomic) NSRange daysInMonth;

@property (strong, nonatomic) UILabel *eventHoursLabel;

@end

@implementation GSPMonthViewController

#pragma mark - Initial Setup

-(id)init
{
    if (self = [super init])
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.itemSize = CGSizeMake(50, 50);
        self.MonthView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, screenRect.size.width - 20, screenRect.size.height) collectionViewLayout:layout];
        
        self.MonthView.dataSource = self;
        self.MonthView.delegate = self;

//        self.view.backgroundColor = [UIColor colorWithRed: .85f green:.85f blue:.85f alpha:1.0f];
        self.view.backgroundColor = [UIColor colorFromHexString:@"4b86b9"];
        self.MonthView.backgroundColor = self.view.backgroundColor;
        
        [self.MonthView registerClass:[GSPMonthCell class] forCellWithReuseIdentifier:@"DayCell"];
        [self.view addSubview:self.MonthView];
        
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self formatCalendar];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.titleFormattedString;
    [self.navigationItem setTitleView:titleLabel];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(setupEvent)];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

-(void)formatCalendar
{
    self.relevantCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.relevantDate = [NSDate date];
    self.relevantDateComponents =
    [self.relevantCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                             fromDate:self.relevantDate];

//    self.MonthView.collectionViewLayout = layout;
    self.MonthView.backgroundColor = [UIColor colorWithRed: .85f green:.85f blue:.85f alpha:1.0f];
    
    self.titleFormattedString = [NSString stringWithFormat:@"%@ %i", [NSCalendar monthNames][self.relevantDateComponents.month - 1], self.relevantDateComponents.year];
}

-(UICollectionViewLayout *)generateLayout
{
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
    return layout;
}

-(NSRange) daysInMonth
{
    _daysInMonth = [self.relevantCalendar rangeOfUnit:NSDayCalendarUnit
                                               inUnit:NSMonthCalendarUnit
                                              forDate:self.relevantDate];
    return _daysInMonth;
}

-(NSMutableDictionary *)events
{
    if (!_events)
    {
        _events = [NSMutableDictionary dictionaryWithCapacity:365];
    }
    return _events;
}

/*
 Calculates the number of rows that should appear in the calendar. Assuming the gregorian calendar
 Throughout this project. Could possible be reworked in the future to adapt for others
 */
-(int)numRows
{
    if (!_numRows) {
        _numRows =  (self.daysInMonth.length / DAYS_PER_WEEK) + (self.daysInMonth.length % DAYS_PER_WEEK != 0);
    }
    return _numRows;
}

-(CGRect)getScreenBounds
{
    return [[UIScreen mainScreen] bounds];
}

-(int)adjustCollectionViewIndexToDate:(int)collectionViewIndex
{
    if (self.numRows > self.daysInMonth.length / DAYS_PER_WEEK) //i.e. certain days need to be greyed out
    {
        NSDateComponents *startComponents = [self.relevantCalendar components:NSWeekdayCalendarUnit  fromDate:[self.relevantDate startOfMonth]];
        int distanceFromStart = [startComponents weekday] - 2; //Why does -2 work..
        if (!self.offset) {
            self.offset = [[NSNumber alloc] initWithInt:distanceFromStart];
        }
        if (collectionViewIndex - distanceFromStart > self.daysInMonth.length) {
            return GREYED_OUT;
        }
        return (collectionViewIndex - distanceFromStart);
    }
    else return collectionViewIndex;
}

-(int)adjustDateToCollectionViewIndex:(int)day
{
    assert(self.offset);
    return day + [self.offset intValue];
}

#pragma mark - Event Presentation
/*
    Presents a view which allows the user to enter information about an event.
    Actually entry of event left to control on the view itself
 */
-(void)setupEvent
{
//    NSLog(@"Setup event called");
    self.eventForm = [[UIViewController alloc] init];
    [self setupEventForm:self.eventForm];
    [self.navigationController pushViewController:self.eventForm animated:YES];
    self.eventForm.view.backgroundColor = [UIColor colorWithRed: .97f green:.97f blue:.97f alpha:1.0f];;
    self.eventForm.view.superview.center = self.view.center;
    [self.eventForm.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)]];
}

/*
    Initializes the UI elements on the event view
 */
-(void)setupEventForm:(UIViewController *) eventFormController
{
    eventFormController.modalPresentationStyle = UIModalPresentationFormSheet;
    eventFormController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    eventFormController.view.frame = self.view.frame;
    eventFormController.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat fieldWidth = eventFormController.view.frame.size.width - 2 * FORM_PADDING;
    CGFloat initialLocation = [self.navigationController endY] + FORM_PADDING;
    int index = 0;
    
    self.eventName = [self createTextField:CGRectMake(FORM_PADDING, initialLocation + ((FORM_PADDING + FORM_HEIGHT) * index++), fieldWidth, FORM_HEIGHT)
                                   withPlaceholder:@"Enter event name"];
    
    self.eventDescription = [self createTextField:CGRectMake(FORM_PADDING,  initialLocation + ((FORM_PADDING + FORM_HEIGHT) * index++), fieldWidth, FORM_HEIGHT)           withPlaceholder:@"Enter event description"];
    
    self.eventLocation = [self createTextField:CGRectMake(FORM_PADDING, initialLocation + ((FORM_PADDING + FORM_HEIGHT) * index++)  , fieldWidth, FORM_HEIGHT) withPlaceholder:@"Enter event location"];

    self.eventMinutes = [[UISlider alloc] initWithFrame:CGRectMake(FORM_PADDING, initialLocation + ((FORM_PADDING + FORM_HEIGHT * index++)) + FORM_PADDING, fieldWidth - 40 , FORM_HEIGHT)];
    
    self.eventHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(fieldWidth - 70 + FORM_PADDING, initialLocation + ((FORM_PADDING + FORM_HEIGHT * index)), 70, FORM_HEIGHT)];
    
    [self setupSlider];
    
    self.eventDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, initialLocation + ((FORM_PADDING + FORM_HEIGHT) * index++)  , fieldWidth, FORM_HEIGHT)];
    
    UIButton *enterEvent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    enterEvent.frame = CGRectMake(FORM_PADDING, FORM_PADDING + self.eventDate.frame.origin.y + self.eventDate.frame.size.height, fieldWidth, 30);
    [enterEvent setTitle:@"Enter Event" forState:UIControlStateNormal];
    [enterEvent addTarget:self action:@selector(enterEvent) forControlEvents:UIControlEventTouchUpInside | UIControlEventValueChanged];

    [eventFormController.view addSubview:self.eventName];
    [eventFormController.view addSubview:self.eventDescription];
    [eventFormController.view addSubview:self.eventLocation];
    [eventFormController.view addSubview:self.eventMinutes];
    [eventFormController.view addSubview:self.eventHoursLabel];
    [eventFormController.view addSubview:self.eventDate];
    [eventFormController.view addSubview:enterEvent];
}

-(void)setupSlider
{
    self.eventMinutes.minimumValue = 0;
    self.eventMinutes.maximumValue = 360;
    self.eventMinutes.continuous = NO;
    
    [self.eventMinutes addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.eventHoursLabel.text = @"0";
}

-(void)sliderChanged:(UISlider *)slider
{
    NSLog(@"Called");
    self.eventHoursLabel.text = [NSString stringWithFormat:@"%d", (int)self.eventMinutes.value];
}
/*
    Resigns first responder from all the possible text views. Should be a more elegant way to do it
    But this itself isn't particularly inefficient
 */
-(void)closeKeyboard
{
    [self.eventName resignFirstResponder];
    [self.eventDescription resignFirstResponder];
    [self.eventLocation resignFirstResponder];
}

/*
    Creates the text fields which should all have an identical styling, only different screen locations
 */
-(UITextField *)createTextField:(CGRect)frame withPlaceholder:(NSString *)placeholder
{
    UITextField *toReturn = [[UITextField alloc] initWithFrame:frame];
    toReturn.borderStyle = UITextBorderStyleRoundedRect;
    toReturn.backgroundColor = [UIColor clearColor];
    toReturn.font = [UIFont fontWithName:@"Helvetica" size:18.0f];
    toReturn.placeholder = placeholder;
    return toReturn;
}

-(void)enterEvent
{
    //Construct a GSP Event Class
    GSPEvent *event = [[GSPEvent alloc] initWithTitle:self.eventName.text
                                          Description:self.eventDescription.text
                                                 Date:self.eventDate.date
                                                Color:[UIColor blueColor]
                                               OfType:Informal
                                               Length:[[NSNumber alloc] initWithFloat:self.eventMinutes.value]];
    
    [self mapEvent:event];
    
    NSDateComponents *eventDateComps = [[self relevantCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit fromDate:event.date];
    
    // Only change if the current calendar on display matches the month/year the event was added
    if (self.relevantDateComponents.year == eventDateComps.year
        && self.relevantDateComponents.month == eventDateComps.month) {
    
        // Redraw cell
        unsigned int indices[2] = {0, [self adjustDateToCollectionViewIndex:eventDateComps.day]};
        [self.MonthView reloadItemsAtIndexPaths:@[[[NSIndexPath alloc] initWithIndexes:indices length:2]]];
        
    }
    
    // Remove the event view controller, returning screen to month view
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSMutableArray *)getEventsForDate:(NSDate *)date
{
    return [self.events objectForKey:[date standardizedDate]];
}

/*
    Takes care of adding a newly created event into the events dictionary
    Will be used both as a reference, and to create the UI for the calendar
 */
-(void)mapEvent:(GSPEvent *)event
{
    // Look up array of events
    NSMutableArray *eventArr = [self getEventsForDate:event.date];
    
    if (!eventArr) {
        eventArr = [[NSMutableArray alloc] init];
    }
    [eventArr addObject:event];
    [self.events setObject:eventArr forKey:[event.date standardizedDate]];
}

/*
 * Takes in a date and returns the number of events on that day
 */
-(int)eventCountForDate:(NSDate *)date {

    NSMutableArray *eventArr = [self getEventsForDate:date];
    
    if (!eventArr) {
        return 0;
    }
//    NSLog(@"%@ has %d events", date, [eventArr count]);
    return [eventArr count];
}

/*
    Gets the number of events currently associated with a date
    Will start at 0 initially, hoping to load these from a server
    At some point down the road
 */
-(int)findNumEvents:(int)day
{
    if (day == GREYED_OUT) {
        return 0;
    }
    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *startComponents = [self.relevantCalendar components:units  fromDate:[self.relevantDate startOfMonth]];
    [startComponents setDay:day];
    NSDate *currentDay = [self.relevantCalendar dateFromComponents:startComponents];
    
    return [self eventCountForDate:currentDay];
}

/*
 * Retreives a cell which corresponds to the date passed in
 */
-(GSPMonthCell *)getCellForDate:(NSDate*)date
{
    NSDateComponents *components = [self.relevantCalendar components:NSDayCalendarUnit fromDate:[date startOfMonth] toDate:date options:0];
    
    // Only one section in the collection view (self) so date corresponds to the second tier
    NSUInteger indices[2] = {0, (unsigned int)[self adjustDateToCollectionViewIndex:components.day]};
    NSIndexPath *cellPath = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    return (GSPMonthCell *)[self collectionView:self.MonthView cellForItemAtIndexPath:cellPath];
}

#pragma mark - Collection View Data source

/*
     Returns the number of rows that should be present in collection view (i.e. num relevant weeks)
     Then multiplies it by 7. May want to make this more extensible
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numRows * DAYS_PER_WEEK;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Dequeing cell at index location: %d", indexPath.row);
    GSPMonthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    
    cell.dayOfMonth = [self adjustCollectionViewIndexToDate:indexPath.row];
    
    [cell initializeCellContentsFor:cell.dayOfMonth andWith:[self findNumEvents:cell.dayOfMonth]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(38, 38);
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - Collection View Delegate Methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GSPMonthCell *cell = (GSPMonthCell *)[self collectionView:self.MonthView cellForItemAtIndexPath:indexPath];
    
    if (cell.dayOfMonth > 0) {
        // Translate day into date
        unsigned units = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit;
        NSDateComponents *selectedDay = [self.relevantCalendar components:units fromDate:self.relevantDate];
        selectedDay.weekday = indexPath.row % 7; // Hackish, maybe without the ish.
        [selectedDay setDay:cell.dayOfMonth];
        
        NSDate *selectedDate = [self.relevantCalendar dateFromComponents:selectedDay];
        
        GSPDayViewController *dayVC = [[GSPDayViewController alloc] initWithEvents:[self getEventsForDate:selectedDate] andDateComponents:selectedDay];
        
        [self addChildViewController:dayVC];
        [self.navigationController pushViewController:dayVC animated:YES];
        
    }
}

#pragma mark - Table View Datasource Methods

#pragma mark - Table View Delegate Methods



@end
