//
//  EYGetAllProductsMTLModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYGetAllProductsMTLModel.h"

@implementation EYGetAllProductsMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"productsInfo" : @"productsInfo",
             @"productsFilters" : @"productsFilters"
             };
}

-(id) initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self)
    {
        NSMutableArray * deliveryArray = [[NSMutableArray alloc] init];
        NSMutableArray * occassionArray = [[NSMutableArray alloc] init];
        NSMutableArray * colorArray = [[NSMutableArray alloc] init];
        NSMutableArray * designerArray = [[NSMutableArray alloc] init];
        NSMutableArray * sizeArray = [[NSMutableArray alloc] init];

        for (EYProductFilters * productFilter in self.productsFilters)
        {
            if ([productFilter.name isEqualToString:NSLocalizedString(@"fourdayrentalprice", @"")] || [productFilter.name isEqualToString:NSLocalizedString(@"eightdayrentalprice", @"")])
            {
                [deliveryArray addObject:productFilter];
            }
            else if ([productFilter.name isEqualToString:NSLocalizedString(@"occasion", @"")])
            {
                [occassionArray addObject:productFilter];
            }
            
            else if ([productFilter.name isEqualToString:NSLocalizedString(@"Color", @"")])
            {
                [colorArray addObject:productFilter];
            }
            
            else if ([productFilter.name isEqualToString:NSLocalizedString(@"designer", @"")])
            {
                [designerArray addObject:productFilter];
            }
            if ([productFilter.name isEqualToString:NSLocalizedString(@"Size", @"")])
            {
                [sizeArray addObject:productFilter];
            }
        }
        
        self.allDeliveryArray = [[NSArray alloc] initWithArray:deliveryArray];
        self.allOccassionArray = [[NSArray alloc] initWithArray:occassionArray];
        self.allColorArray = [[NSArray alloc] initWithArray:colorArray];
        self.allDesignerArray = [[NSArray alloc] initWithArray:designerArray];
        self.allSizeArray = [[NSArray alloc] initWithArray:sizeArray];
        
    }
    return self;
}

+ (NSValueTransformer *)productsInfoJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductsInfo class]];
}

+ (NSValueTransformer *)productsFiltersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductFilters class]];
}

@end

@implementation EYProductsInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"absoluteDiscount" : @"absoluteDiscount",
             @"brandId" : @"brandId",
             @"brandName" : @"brandName",
             @"categories" : @"categories",
             @"discountedPercentage" : @"discountedPercentage",
             @"eightDayRentalPrice" : @"eightDayRentalPrice",
             @"fourDayRentalPrice" : @"fourDayRentalPrice",
             @"insurance" : @"insurance",
             @"occasions" : @"occasions",
             @"originalPrice" : @"originalPrice",
             @"productAttributes" : @"productAttributes",
             @"productDetails" : @"productDetails",
             @"productId" : @"productId",
             @"productName" : @"productName",
             @"productSKUs" : @"productSKUs",
             @"salePercentage" : @"salePercentage",
             @"salePrice" : @"salePrice",
             @"shippingFee" : @"shippingFee",
             @"status" : @"status",
             @"stylistNotes" : @"stylistNotes",
             @"tags" : @"tags",
             @"productResizeImages" : @"productResizeImages"
             };
}

+ (NSValueTransformer *)productAttributesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductAttributes class]];
}

+ (NSValueTransformer *)productSKUsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductSKUs class]];
}

+ (NSValueTransformer *)productResizeImagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductResizeImages class]];
}

@end

@implementation EYProductAttributes

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"attrValueIds" : @"attrValueIds",
             @"attrValues" : @"attrValues",
             @"attributeId" : @"attributeId",
             @"attributeName" : @"attributeName",
             @"attributeValueId" : @"attributeValueId",
             @"createdBy" : @"createdBy",
             @"modifiedBy" : @"modifiedBy",
             @"productAttributeId" : @"productAttributeId",
             @"productId" : @"productId",
             @"status" : @"status"
             };
}

@end

@implementation EYProductSKUs

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"depth" : @"depth",
             @"entityId" : @"entityId",
             @"isActive" : @"isActive",
             @"productId" : @"productId",
             @"sizeValueId" : @"sizeValueId",
             @"sku" : @"sku"
             };
}

@end

@implementation EYProductFilters

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"filterType" : @"filterType",
             @"name" : @"name",
             @"filterId" : @"id",
             @"valueIds" : @"valueIds",
             @"values" : @"values",
             @"minVal" : @"minVal",
             @"maxVal" : @"maxVal"
             };
}

@end

@implementation EYProductResizeImages

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"image" : @"image",
             @"imageSize" : @"imageSize",
             @"imageTag" : @"imageTag",
             };
}

@end