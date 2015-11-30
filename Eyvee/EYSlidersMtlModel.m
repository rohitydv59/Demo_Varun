//
//  EYSlidersMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 01/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYSlidersMtlModel.h"
#import "EYGetAllProductsMTLModel.h"

@implementation EYSlidersMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"sliderId" : @"sliderId",
             @"sliderType" : @"sliderType",
             @"headerText" : @"headerText",
             @"middleText":@"middleText",
             @"bottomText":@"bottomText",
             @"imageName":@"imageName",
             @"headerFontSize":@"headerFontSize",
             @"middleFontSize":@"middleFontSize",
             @"bottomFontSize":@"bottomFontSize",
             @"sliderTypeVal":@"sliderTypeVal",
             @"itemId":@"itemId",
             @"itemName":@"itemName",
             @"children":@"children",
             @"resizedImages" : @"resizedImages"
             };
}

+ (NSValueTransformer *)resizedImagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductResizeImages class]];
}

@end
