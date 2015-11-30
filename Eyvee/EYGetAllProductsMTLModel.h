//
//  EYGetAllProductsMTLModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYGetAllProductsMTLModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *productsInfo;
@property (nonatomic, strong) NSArray *productsFilters;
@property (nonatomic, strong) NSArray *allDeliveryArray;
@property (nonatomic, strong) NSArray *allOccassionArray;
@property (nonatomic, strong) NSArray *allColorArray;
@property (nonatomic, strong) NSArray *allDesignerArray;
@property (nonatomic, strong) NSArray *allSizeArray;
@end

@interface EYProductsInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *absoluteDiscount;
@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSArray *categories;//
@property (nonatomic, strong) NSNumber *discountedPercentage;
@property (nonatomic, strong) NSNumber *eightDayRentalPrice;
@property (nonatomic, strong) NSNumber *fourDayRentalPrice;
@property (nonatomic, strong) NSNumber *insurance;
@property (nonatomic, strong) NSArray *occasions;//
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSArray *productAttributes;//
@property (nonatomic, strong) NSString *productDetails;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSArray *productSKUs;//
@property (nonatomic, strong) NSNumber *salePercentage;
@property (nonatomic, strong) NSNumber *salePrice;
@property (nonatomic, strong) NSNumber *shippingFee;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *stylistNotes;
@property (nonatomic, strong) NSArray *tags;//
@property (nonatomic, strong) NSArray *productResizeImages;

@end

@interface EYProductAttributes : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *attrValueIds;
@property (nonatomic, strong) NSArray *attrValues;
@property (nonatomic, strong) NSNumber *attributeId;
@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, strong) NSNumber *attributeValueId;
@property (nonatomic, strong) NSNumber *createdBy;
@property (nonatomic, strong) NSNumber *modifiedBy;
@property (nonatomic, strong) NSNumber *productAttributeId;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *status;

@end

@interface EYProductSKUs : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSNumber *entityId;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *sizeValueId;
@property (nonatomic, strong) NSString *sku;

@end

@interface EYProductFilters : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *filterType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *filterId;
@property (nonatomic, strong) NSArray *valueIds;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSString *minVal;
@property (nonatomic, strong) NSString *maxVal;

@end

@interface EYProductResizeImages : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *imageSize;
@property (nonatomic, strong) NSString *imageTag;

@end
