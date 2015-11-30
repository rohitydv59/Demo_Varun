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


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_productsInfo forKey:@"productsInfo"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _productsInfo = [decoder decodeObjectForKey:@"productsInfo"];
    
    return self;
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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_absoluteDiscount forKey:@"absoluteDiscount"];
    [encoder encodeObject:_brandId forKey:@"brandId"];
    [encoder encodeObject:_brandName forKey:@"brandName"];
    [encoder encodeObject:_categories forKey:@"categories"];
    [encoder encodeObject:_discountedPercentage forKey:@"discountedPercentage"];
    [encoder encodeObject:_eightDayRentalPrice forKey:@"eightDayRentalPrice"];
    [encoder encodeObject:_fourDayRentalPrice forKey:@"fourDayRentalPrice"];
    [encoder encodeObject:_insurance forKey:@"insurance"];
    [encoder encodeObject:_occasions forKey:@"occasions"];
    [encoder encodeObject:_originalPrice forKey:@"originalPrice"];
    [encoder encodeObject:_productAttributes forKey:@"productAttributes"];
    [encoder encodeObject:_productDetails forKey:@"productDetails"];
    [encoder encodeObject:_productId forKey:@"productId"];
    [encoder encodeObject:_productName forKey:@"productName"];
    [encoder encodeObject:_productSKUs forKey:@"productSKUs"];
    [encoder encodeObject:_salePercentage forKey:@"salePercentage"];
    [encoder encodeObject:_salePrice forKey:@"salePrice"];
    [encoder encodeObject:_shippingFee forKey:@"shippingFee"];
    [encoder encodeObject:_status forKey:@"status"];
    [encoder encodeObject:_stylistNotes forKey:@"stylistNotes"];
    [encoder encodeObject:_tags forKey:@"tags"];
    [encoder encodeObject:_productResizeImages forKey:@"productResizeImages"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    _absoluteDiscount = [decoder decodeObjectForKey:@"absoluteDiscount"];
    _brandId = [decoder decodeObjectForKey:@"brandId"];
    _brandName = [decoder decodeObjectForKey:@"brandName"];
    _categories = [decoder decodeObjectForKey:@"categories"];
    _discountedPercentage = [decoder decodeObjectForKey:@"discountedPercentage"];
    _eightDayRentalPrice = [decoder decodeObjectForKey:@"eightDayRentalPrice"];
    _fourDayRentalPrice = [decoder decodeObjectForKey:@"fourDayRentalPrice"];
    _insurance = [decoder decodeObjectForKey:@"insurance"];
    _occasions = [decoder decodeObjectForKey:@"occasions"];
    _originalPrice = [decoder decodeObjectForKey:@"originalPrice"];
    _productAttributes = [decoder decodeObjectForKey:@"productAttributes"];
    _productDetails = [decoder decodeObjectForKey:@"productDetails"];
    _productId = [decoder decodeObjectForKey:@"productId"];
    _productName = [decoder decodeObjectForKey:@"productName"];
    _productSKUs = [decoder decodeObjectForKey:@"productSKUs"];
    _salePercentage = [decoder decodeObjectForKey:@"salePercentage"];
    _salePrice = [decoder decodeObjectForKey:@"salePrice"];
    _shippingFee = [decoder decodeObjectForKey:@"shippingFee"];
    _status = [decoder decodeObjectForKey:@"status"];
    _stylistNotes = [decoder decodeObjectForKey:@"stylistNotes"];
    _tags = [decoder decodeObjectForKey:@"tags"];
    _productResizeImages = [decoder decodeObjectForKey:@"productResizeImages"];
    
    return self;
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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_attrValueIds forKey:@"attrValueIds"];
    [encoder encodeObject:_attrValues forKey:@"attrValues"];
    [encoder encodeObject:_attributeId forKey:@"attributeId"];
    [encoder encodeObject:_attributeName forKey:@"attributeName"];
    [encoder encodeObject:_attributeValueId forKey:@"attributeValueId"];
    [encoder encodeObject:_createdBy forKey:@"createdBy"];
    [encoder encodeObject:_modifiedBy forKey:@"modifiedBy"];
    [encoder encodeObject:_productAttributeId forKey:@"productAttributeId"];
    [encoder encodeObject:_productId forKey:@"productId"];
    [encoder encodeObject:_status forKey:@"status"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _attrValueIds = [decoder decodeObjectForKey:@"attrValueIds"];
    _attrValues = [decoder decodeObjectForKey:@"attrValues"];
    _attributeId = [decoder decodeObjectForKey:@"attributeId"];
    _attributeName = [decoder decodeObjectForKey:@"attributeName"];
    _attributeValueId = [decoder decodeObjectForKey:@"attributeValueId"];
    _createdBy = [decoder decodeObjectForKey:@"createdBy"];
    _modifiedBy = [decoder decodeObjectForKey:@"modifiedBy"];
    _productAttributeId = [decoder decodeObjectForKey:@"productAttributeId"];
    _productId = [decoder decodeObjectForKey:@"productId"];
    _status = [decoder decodeObjectForKey:@"status"];
    return self;
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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_depth forKey:@"depth"];
    [encoder encodeObject:_entityId forKey:@"entityId"];
    [encoder encodeObject:_isActive forKey:@"isActive"];
    [encoder encodeObject:_productId forKey:@"productId"];
    [encoder encodeObject:_sizeValueId forKey:@"sizeValueId"];
    [encoder encodeObject:_sku forKey:@"sku"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _depth = [decoder decodeObjectForKey:@"depth"];
    _entityId = [decoder decodeObjectForKey:@"entityId"];
    _isActive = [decoder decodeObjectForKey:@"isActive"];
    _productId = [decoder decodeObjectForKey:@"productId"];
    _sizeValueId = [decoder decodeObjectForKey:@"sizeValueId"];
    _sku = [decoder decodeObjectForKey:@"sku"];
    return self;
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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_filterType forKey:@"filterType"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_filterId forKey:@"filterId"];
    [encoder encodeObject:_valueIds forKey:@"valueIds"];
    [encoder encodeObject:_values forKey:@"values"];
    [encoder encodeObject:_minVal forKey:@"minVal"];
    [encoder encodeObject:_maxVal forKey:@"maxVal"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _filterType = [decoder decodeObjectForKey:@"filterType"];
    _name = [decoder decodeObjectForKey:@"name"];
    _filterId = [decoder decodeObjectForKey:@"filterId"];
    _valueIds = [decoder decodeObjectForKey:@"valueIds"];
    _values = [decoder decodeObjectForKey:@"values"];
    _minVal = [decoder decodeObjectForKey:@"minVal"];
    _maxVal = [decoder decodeObjectForKey:@"maxVal"];
    return self;
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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_image forKey:@"image"];
    [encoder encodeObject:_imageSize forKey:@"imageSize"];
    [encoder encodeObject:_imageTag forKey:@"imageTag"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _image = [decoder decodeObjectForKey:@"image"];
    _imageSize = [decoder decodeObjectForKey:@"imageSize"];
    _imageTag = [decoder decodeObjectForKey:@"imageTag"];
    return self;
}

@end