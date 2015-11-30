    //
//  EYFilterDataModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYFilterDataModel.h"

@implementation EYFilterDataModel

- (instancetype)initWithFourDayRentalFilter:(EYProductFilters *) filter
{
    self = [super init];
    if (self) {
        self.filter = filter;
        [self initialisingFilterModel];
    }
    return self;
}


- (void)initialisingFilterModel
{
    self.rentalPeriod = 4;
    self.occasions = [[NSMutableArray alloc] init];
    self.sizes = [[NSMutableArray alloc] init];
    self.colors = [[NSMutableArray alloc] init];
    self.priceRange = [[NSMutableDictionary alloc] init];
    
    [self.priceRange setObject:_filter.minVal forKey:@"minValue"];
    [self.priceRange setObject:_filter.maxVal forKey:@"maxValue"];
    [self.priceRange setObject:_filter.minVal forKey:@"selectedMinValue"];
    [self.priceRange setObject:_filter.maxVal forKey:@"selectedMaxValue"];

    self.allDesigners = [[NSMutableArray alloc] init];
    self.topDesigners = [[NSMutableArray alloc] init];
    [self initialisingDateFilterModel];
    
    self.occasionsIdArray = [[NSMutableArray alloc] init];
    self.allDesignerIdArray = [[NSMutableArray alloc] init];
    self.topDesignerIdArray = [[NSMutableArray alloc] init];
    self.sizeIdArray = [[NSMutableArray alloc] init];
    self.colorIdArray = [[NSMutableArray alloc] init];
    self.otherFilters = [[NSMutableArray alloc] init];
}

- (void)initialisingDateFilterModel
{
    self.startDate = nil;
}
   
@end
