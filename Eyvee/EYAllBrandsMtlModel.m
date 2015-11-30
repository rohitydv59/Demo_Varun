//
//  EYAllBrandsMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAllBrandsMtlModel.h"

@implementation EYAllBrandsMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"brandId" : @"brandId",
             @"brandName" : @"brandName",
             @"displayInMenu" : @"displayInMenu",
             @"isActive":@"isActive",
             @"topDesigner":@"topDesigner"
             };
}

@end
