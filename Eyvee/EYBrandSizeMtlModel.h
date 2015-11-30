//
//  EYBrandSizeMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYBrandSizeMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSNumber *brandSizeChartId;
@property (nonatomic, strong) NSNumber *bustSizeMax;
@property (nonatomic, strong) NSNumber *bustSizeMin;
@property (nonatomic, strong) NSNumber *hipsSizeMax;
@property (nonatomic, strong) NSNumber *hipsSizeMin;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *lowWaistSizeMax;
@property (nonatomic, strong) NSNumber *lowWaistSizeMin;
@property (nonatomic, strong) NSNumber *naturalWaistSizeMax;
@property (nonatomic, strong) NSNumber *naturalWaistSizeMin;
@property (nonatomic, strong) NSString *sizeName;
@property (nonatomic, strong) NSNumber *ukSizeMax;
@property (nonatomic, strong) NSNumber *ukSizeMin;
@property (nonatomic, strong) NSNumber *usSizeMax;
@property (nonatomic, strong) NSNumber *usSizeMin;

@end
