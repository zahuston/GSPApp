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

#define DAYS_PER_WEEK 7

@interface GSPMonthView()
@property (nonatomic) int numRows;
@property (nonatomic) NSRange daysInMonth;
@property (strong, nonatomic) NSArray *monthNames; // I don't want to touch date formatter
@property (nonatomic) NSNumber *offset;
@property BOOL formatted;
@end

@implementation GSPMonthView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setFrame:frame];
        self.dataSource = self;
        self.delegate = self;
        UICollectionViewLayout *tempLayout = [[UICollectionViewLayout alloc] init];
        self.collectionViewLayout = tempLayout;
        self.relevantCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.relevantDate = [NSDate date];
        
        [self formatCalendar];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.frame = frame;
        self.collectionViewLayout = layout;
        self.dataSource = self;
        self.delegate = self;
        self.relevantCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.relevantDate = [NSDate date];
        [self formatCalendar];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"init with coder called");
    return self;
}

-(void)formatCalendar
{
    self.relevantDateComponents =
    [self.relevantCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                             fromDate:self.relevantDate];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake(50, 50);
    self.collectionViewLayout = layout;
    self.backgroundColor = [UIColor colorWithRed: .85f green:.85f blue:.85f alpha:1.0f];
    self.titleFormattedString = [NSString stringWithFormat:@"%@ %i", self.monthNames[self.relevantDateComponents.month - 1], self.relevantDateComponents.year];
}

-(NSRange) daysInMonth
{
    _daysInMonth = [self.relevantCalendar rangeOfUnit:NSDayCalendarUnit
                                               inUnit:NSMonthCalendarUnit
                                              forDate:self.relevantDate];
    return _daysInMonth;
}

-(NSArray *)monthNames
{
    if (!_monthNames)
    {
        _monthNames = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    }
    return _monthNames;
}

/*
    Calculates the number of rows that should appear in the calendar. Assuming the gregorian calendar
    Throughout this project. Could possible be reworked in the future to adapt for others
*/
-(int)numRows
{
    if (!_numRows)
    {
        _numRows =  (self.daysInMonth.length / DAYS_PER_WEEK) + (self.daysInMonth.length % DAYS_PER_WEEK != 0);
    }
    return _numRows;
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
            return -1;
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

-(void)updateEvents:(NSDate *)updatedDate
{
//    [self reloadData];
    // 1) Find the cell to update
    GSPMonthCell *cell = [self getCellForDate:updatedDate];
    
    
    // 2) Update the cell accordingly
    NSLog(@"Something %d", cell.dayOfMonth);
    [cell class];
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
    GSPMonthCell *toReturn = (GSPMonthCell *)[self collectionView:self cellForItemAtIndexPath:cellPath];
    return toReturn;
}

#pragma mark - Data source
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
    GSPMonthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCell" forIndexPath:indexPath];
    int offset = [self adjustCollectionViewIndexToDate:indexPath.row];
    [cell initializeCellContentsFor:offset andWith:[self findNumEvents:self.relevantDate withOffset:offset]];
    return cell;
}

/*
    Gets the number of events currently associated with a date
    Will start at 0 initially, hoping to load these from a server
    At some point down the road
 */
-(int)findNumEvents:(NSDate*)date withOffset:(int)offset
{
    NSDateComponents *startComponents = [self.relevantCalendar components:NSWeekdayCalendarUnit  fromDate:[self.relevantDate startOfMonth]];
    [startComponents setDay:offset];
    NSDate *currentDay = [self.relevantCalendar dateFromComponents:startComponents];
    
    NSArray *eventArray = [((GSPMonthViewController *)self.parentViewController).events objectForKey:[currentDay standardizedDate]];
    return eventArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(38, 38);
}


#pragma mark - Delegate

@end
