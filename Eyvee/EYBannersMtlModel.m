//
//  EYBannersMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 01/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYBannersMtlModel.h"
#import "EYGetAllProductsMTLModel.h"

@implementation EYBannersMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bannerId" : @"bannerId",
             @"bannerName" : @"bannerName",
             @"headerText" : @"headerText",
             @"middleText":@"middleText",
             @"bottomText":@"bottomText",
             @"imageName":@"imageName",
             @"link":@"link",
             @"runOrder":@"runOrder",
             @"isActive":@"isActive",
             @"imagePath":@"imagePath",
             @"headerFont":@"headerFont",
             @"middleFont":@"middleFont",
             @"bottomFont":@"bottomFont",
             @"bannerImageText":@"bannerImageText",
             @"resizedImages" : @"resizedImages",
             @"bannerProductsFile" : @"bannerProductsFile"
             };
}

+ (NSValueTransformer *)resizedImagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductResizeImages class]];
}


@end
