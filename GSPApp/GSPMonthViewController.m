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
#import "GSPCustomTitleView.h"
#import "Gradient.h"
#import "UINavigationController+FrameLocations.h"

@interface GSPMonthViewController ()

@end

@implementation GSPMonthViewController

-(id)init
{
    if (self = [super init])
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.MonthView = [[GSPMonthView alloc] initWithFrame:CGRectMake(10, 10, screenRect.size.width - 20, screenRect.size.height) collectionViewLayout:[self generateLayout]];
        self.view.backgroundColor = [UIColor colorWithRed: .85f green:.85f blue:.85f alpha:1.0f];
        [self.MonthView registerClass:[GSPMonthCell class] forCellWithReuseIdentifier:@"DayCell"];
    }
    return self;
}

-(UICollectionViewLayout *)generateLayout
{
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
    return layout;
}

-(NSMutableDictionary *)events
{
    if (!_events)
    {
        _events = [NSMutableDictionary dictionaryWithCapacity:365];
    }
    return _events;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.MonthView];
//    self.navigationItem.title = self.MonthView.titleFormattedString;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.MonthView.titleFormattedString;
    [self.navigationItem setTitleView:titleLabel];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(setupEvent)];

}

/*
    Presents a view which allows the user to enter information about an event.
    Actually entry of event left to control on the view itself
 */
-(void)setupEvent
{
    NSLog(@"Setup event called");
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
    
    self.eventDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, initialLocation + ((FORM_PADDING + FORM_HEIGHT) * index++)  , fieldWidth, FORM_HEIGHT)];
    
    UIButton *enterEvent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    enterEvent.frame = CGRectMake(FORM_PADDING, FORM_PADDING + self.eventDate.frame.origin.y + self.eventDate.frame.size.height, fieldWidth, 30);
    [enterEvent setTitle:@"Enter Event" forState:UIControlStateNormal];
    [enterEvent addTarget:self action:@selector(enterEvent) forControlEvents:UIControlEventTouchUpInside];

    [eventFormController.view addSubview:self.eventName];
    [eventFormController.view addSubview:self.eventDescription];
    [eventFormController.view addSubview:self.eventLocation];
    [eventFormController.view addSubview:self.eventDate];
    [eventFormController.view addSubview:enterEvent];
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
                                                                                                                                  
-(void)returnToCalendar
{
    NSLog(@"return to calendar called");

}

-(CGRect)getScreenBounds
{
    return [[UIScreen mainScreen] bounds];
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
    NSLog(@"enter event called");
    
    //Construct a GSP Event Class
    GSPEvent *event = [[GSPEvent alloc] initWithTitle:self.eventName.text
                                          Description:self.eventDescription.text
                                                 Date:self.MonthView.relevantDate
                                                Color:[UIColor blueColor]
                                               OfType:Informal];
    
    [self.events setObject:event forKey:event.date];
    [self.MonthView updateEvents:event.date];
    [self.navigationController popViewControllerAnimated:NO];
}

/*
    Takes care of adding a newly created event into the events dictionary
    Will be used both as a reference, and to create the UI for the calendar
 */
-(void)mapEvent:(GSPEvent *)event
{

    NSDate *standardizedDate = [event.date standardizedDate];
    
    // Try to find an array if it existed previously.
    NSMutableArray *tmp = [self.events objectForKey:standardizedDate];
    if (!tmp) //Create it if it was not found
    {
        tmp = [[NSMutableArray alloc] init];
    }
    [self.events setObject:tmp forKey:standardizedDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
