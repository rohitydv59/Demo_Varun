//
//  EYSiteInfoMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYSiteInfoMtlModel.h"

@implementation EYSiteInfoMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"shippingInformation" : @"shippingInformation",
             @"qualityAssurance" : @"qualityAssurance",
             @"freeText1" : @"freeText1",
             @"freeText2" : @"freeText2",
             @"freeText3" : @"freeText3"
             };
}

@end
