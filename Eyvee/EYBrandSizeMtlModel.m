//
//  EYBrandSizeMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYBrandSizeMtlModel.h"

@implementation EYBrandSizeMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"brandId" : @"brandId",
             @"brandSizeChartId" : @"brandSizeChartId",
             @"bustSizeMax" : @"bustSizeMax",
             @"bustSizeMin" : @"bustSizeMin",
             @"hipsSizeMax" : @"hipsSizeMax",
             @"hipsSizeMin" : @"hipsSizeMin",
             @"isActive" : @"isActive",
             @"lowWaistSizeMax" : @"lowWaistSizeMax",
             @"lowWaistSizeMin" : @"lowWaistSizeMin",
             @"naturalWaistSizeMax" : @"naturalWaistSizeMax",
             @"naturalWaistSizeMin" : @"naturalWaistSizeMin",
             @"sizeName" : @"sizeName",
             @"ukSizeMax" : @"ukSizeMax",
             @"ukSizeMin" : @"ukSizeMin",
             @"usSizeMax" : @"usSizeMax",
             @"usSizeMin" : @"usSizeMin"
             };
}

@end
