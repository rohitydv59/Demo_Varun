//
//  EYFilterDataModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EYGetAllProductsMTLModel.h"

@interface EYFilterDataModel : NSObject

- (instancetype)initWithFourDayRentalFilter:(EYProductFilters *) filter;
- (void)initialisingFilterModel;
- (void)initialisingDateFilterModel;

@property (nonatomic ,strong) EYProductFilters * filter;
@property (nonatomic, assign) NSInteger rentalPeriod;
@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSMutableDictionary *priceRange;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableArray *sizes;
@property (nonatomic, strong) NSMutableArray *occasions;
@property (nonatomic, strong) NSMutableArray *allDesigners;
@property (nonatomic, strong) NSMutableArray *topDesigners;
@property (nonatomic, strong) NSMutableArray *otherFilters;

@property (nonatomic, strong) NSArray *offers;

@property (nonatomic, strong) NSMutableArray *occasionsIdArray;
@property (nonatomic, strong) NSMutableArray *allDesignerIdArray;
@property (nonatomic, strong) NSMutableArray *topDesignerIdArray;
@property (nonatomic, strong) NSMutableArray *sizeIdArray;
@property (nonatomic, strong) NSMutableArray *colorIdArray;

@end
