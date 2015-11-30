//
//  EYSyncCartMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 18/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYSyncCartMtlModel.h"
#import "EYGetAllProductsMTLModel.h"

@implementation EYSyncCartMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cartId" : @"cartId",
             @"userId" : @"userId",
             @"cookie" : @"cookie",
             @"shippingAddressId" : @"shippingAddressId",
             @"billingAddressId" : @"billingAddressId",
             @"isActive" : @"isActive",
             @"createdOn" : @"createdOn",
             @"modifiedOn" : @"modifiedOn",
             @"createdBy" : @"createdBy",
             @"modifiedBy" : @"modifiedBy",
             @"isConvertedToOrder" : @"isConvertedToOrder",
             @"totalRentalPrice" : @"totalRentalPrice",
             @"totalDiscount" : @"totalDiscount",
             @"totalDiscountViaPromoCode" : @"totalDiscountViaPromoCode",
             @"totalShippingFee" : @"totalShippingFee",
             @"totalInsurance" : @"totalInsurance",
             @"totalTax" : @"totalTax",
             @"totalAmountPayableTaxExcl" : @"totalAmountPayableTaxExcl",
             @"totalAmountPayable" : @"totalAmountPayable",
             @"freeShipping" : @"freeShipping",
             @"promoCodes" : @"promoCodes",
             @"promocodeId" : @"promocodeId",
             @"promocodeName" : @"promocodeName",
             @"amountPaid" : @"amountPaid",
             @"paymentMode" : @"paymentMode",
             @"tranactionId" : @"tranactionId",
             @"cartProducts" : @"cartProducts",
             @"isValidForOrder" : @"isValidForOrder"
             };
}

+ (NSValueTransformer *)cartProductsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYSyncCartProductDetails class]];
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    return dateFormatter;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_cartId forKey:@"cartId"];
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_cookie forKey:@"cookie"];
    [encoder encodeObject:_shippingAddressId forKey:@"shippingAddressId"];
    [encoder encodeObject:_billingAddressId forKey:@"billingAddressId"];
    [encoder encodeObject:_isActive forKey:@"isActive"];
    [encoder encodeObject:_createdOn forKey:@"createdOn"];
    [encoder encodeObject:_modifiedOn forKey:@"modifiedOn"];
    [encoder encodeObject:_createdBy forKey:@"createdBy"];
    [encoder encodeObject:_modifiedBy forKey:@"modifiedBy"];
    [encoder encodeObject:_isConvertedToOrder forKey:@"isConvertedToOrder"];
    [encoder encodeObject:_totalRentalPrice forKey:@"totalRentalPrice"];
    [encoder encodeObject:_totalDiscount forKey:@"totalDiscount"];
    [encoder encodeObject:_totalDiscountViaPromoCode forKey:@"totalDiscountViaPromoCode"];
    [encoder encodeObject:_totalShippingFee forKey:@"totalShippingFee"];
    [encoder encodeObject:_totalInsurance forKey:@"totalInsurance"];
    [encoder encodeObject:_totalTax forKey:@"totalTax"];
    [encoder encodeObject:_totalAmountPayableTaxExcl forKey:@"totalAmountPayableTaxExcl"];
    [encoder encodeObject:_totalAmountPayable forKey:@"totalAmountPayable"];
    [encoder encodeObject:_freeShipping forKey:@"freeShipping"];
    [encoder encodeObject:_promoCodes forKey:@"promoCodes"];
    [encoder encodeObject:_promocodeId forKey:@"promocodeId"];
    [encoder encodeObject:_promocodeName forKey:@"promocodeName"];
    [encoder encodeObject:_amountPaid forKey:@"amountPaid"];
    [encoder encodeObject:_paymentMode forKey:@"paymentMode"];
    [encoder encodeObject:_tranactionId forKey:@"tranactionId"];
    [encoder encodeObject:_cartProducts forKey:@"cartProducts"];
    [encoder encodeObject:_isValidForOrder forKey:@"isValidForOrder"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    _cartId = [decoder decodeObjectForKey:@"cartId"];
    _userId = [decoder decodeObjectForKey:@"userId"];
    _cookie = [decoder decodeObjectForKey:@"cookie"];
    _shippingAddressId = [decoder decodeObjectForKey:@"shippingAddressId"];
    _billingAddressId = [decoder decodeObjectForKey:@"billingAddressId"];
    _isActive = [decoder decodeObjectForKey:@"isActive"];
    _createdOn = [decoder decodeObjectForKey:@"createdOn"];
    _modifiedOn = [decoder decodeObjectForKey:@"modifiedOn"];
    _createdBy = [decoder decodeObjectForKey:@"createdBy"];
    _modifiedBy = [decoder decodeObjectForKey:@"modifiedBy"];
    _isConvertedToOrder = [decoder decodeObjectForKey:@"isConvertedToOrder"];
    _totalRentalPrice = [decoder decodeObjectForKey:@"totalRentalPrice"];
    _totalDiscount = [decoder decodeObjectForKey:@"totalDiscount"];
    _totalDiscountViaPromoCode = [decoder decodeObjectForKey:@"totalDiscountViaPromoCode"];
    _totalShippingFee = [decoder decodeObjectForKey:@"totalShippingFee"];
    _totalInsurance = [decoder decodeObjectForKey:@"totalInsurance"];
    _totalTax = [decoder decodeObjectForKey:@"totalTax"];
    _totalAmountPayableTaxExcl = [decoder decodeObjectForKey:@"totalAmountPayableTaxExcl"];
    _totalAmountPayable = [decoder decodeObjectForKey:@"totalAmountPayable"];
    _freeShipping = [decoder decodeObjectForKey:@"freeShipping"];
    _promoCodes = [decoder decodeObjectForKey:@"promoCodes"];
    _promocodeId = [decoder decodeObjectForKey:@"promocodeId"];
    _promocodeName = [decoder decodeObjectForKey:@"promocodeName"];
    _amountPaid = [decoder decodeObjectForKey:@"amountPaid"];
    _paymentMode = [decoder decodeObjectForKey:@"paymentMode"];
    _tranactionId = [decoder decodeObjectForKey:@"tranactionId"];
    _cartProducts = [decoder decodeObjectForKey:@"cartProducts"];
    _isValidForOrder = [decoder decodeObjectForKey:@"isValidForOrder"];

    return self;
}


@end

@implementation EYSyncCartProductDetails

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"productId" : @"productId",
             @"orderId" : @"orderId",
             @"sku" : @"sku",
             @"entityId" : @"entityId",
             @"productName" : @"productName",
             @"brandName" : @"brandName",
             @"brandId" : @"brandId",
             @"sizeId" : @"sizeId",
             @"size" : @"size",
             @"rentalPrice" : @"rentalPrice",
             @"discount" : @"discount",
             @"discountViaPromoCode" : @"discountViaPromoCode",
             @"shippingFee" : @"shippingFee",
             @"insurance" : @"insurance",
             @"tax" : @"tax",
             @"amountPayableTaxExcl" : @"amountPayableTaxExcl",
             @"amountPayable" : @"amountPayable",
             @"rentalStartDate" : @"rentalStartDate",
             @"rentalEndDate" : @"rentalEndDate",
             @"rentalType" : @"rentalType",
             @"cartId" : @"cartId",
             @"cartSkuId" : @"cartSkuId",
             @"skuPromoCodes" : @"skuPromoCodes",
             @"productResizeImages" : @"productResizeImages"
             };
}

+ (NSValueTransformer *)productResizeImagesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EYProductResizeImages class]];
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_productId forKey:@"productId"];
    [encoder encodeObject:_orderId forKey:@"orderId"];
    [encoder encodeObject:_sku forKey:@"sku"];
    [encoder encodeObject:_entityId forKey:@"entityId"];
    [encoder encodeObject:_productName forKey:@"productName"];
    [encoder encodeObject:_brandName forKey:@"brandName"];
    [encoder encodeObject:_brandId forKey:@"brandId"];
    [encoder encodeObject:_sizeId forKey:@"sizeId"];
    [encoder encodeObject:_size forKey:@"size"];
    [encoder encodeObject:_rentalPrice forKey:@"rentalPrice"];
    [encoder encodeObject:_discount forKey:@"discount"];
    [encoder encodeObject:_discountViaPromoCode forKey:@"discountViaPromoCode"];
    [encoder encodeObject:_shippingFee forKey:@"shippingFee"];
    [encoder encodeObject:_insurance forKey:@"insurance"];
    [encoder encodeObject:_tax forKey:@"tax"];
    [encoder encodeObject:_amountPayableTaxExcl forKey:@"amountPayableTaxExcl"];
    [encoder encodeObject:_amountPayable forKey:@"amountPayable"];
    [encoder encodeObject:_rentalStartDate forKey:@"rentalStartDate"];
    [encoder encodeObject:_rentalEndDate forKey:@"rentalEndDate"];
    [encoder encodeObject:_rentalType forKey:@"rentalType"];
    [encoder encodeObject:_cartId forKey:@"cartId"];
    [encoder encodeObject:_cartSkuId forKey:@"cartSkuId"];
    [encoder encodeObject:_skuPromoCodes forKey:@"skuPromoCodes"];
    [encoder encodeObject:_productResizeImages forKey:@"productResizeImages"];

    
}

- (id)initWithCoder:(NSCoder *)decoder {
    _productId = [decoder decodeObjectForKey:@"productId"];
    _orderId = [decoder decodeObjectForKey:@"orderId"];
    _sku = [decoder decodeObjectForKey:@"sku"];
    _entityId = [decoder decodeObjectForKey:@"entityId"];
    _productName = [decoder decodeObjectForKey:@"productName"];
    _brandName = [decoder decodeObjectForKey:@"brandName"];
    _brandId = [decoder decodeObjectForKey:@"brandId"];
    _sizeId = [decoder decodeObjectForKey:@"sizeId"];
    _size = [decoder decodeObjectForKey:@"size"];
    _rentalPrice = [decoder decodeObjectForKey:@"rentalPrice"];
    _discount = [decoder decodeObjectForKey:@"discount"];
    _discountViaPromoCode = [decoder decodeObjectForKey:@"discountViaPromoCode"];
    _shippingFee = [decoder decodeObjectForKey:@"shippingFee"];
    _insurance = [decoder decodeObjectForKey:@"insurance"];
    _tax = [decoder decodeObjectForKey:@"tax"];
    _amountPayableTaxExcl = [decoder decodeObjectForKey:@"amountPayableTaxExcl"];
    _amountPayable = [decoder decodeObjectForKey:@"amountPayable"];
    _rentalStartDate = [decoder decodeObjectForKey:@"rentalStartDate"];
    _rentalEndDate = [decoder decodeObjectForKey:@"rentalEndDate"];
    _rentalType = [decoder decodeObjectForKey:@"rentalType"];
    _cartId = [decoder decodeObjectForKey:@"cartId"];
    _cartSkuId = [decoder decodeObjectForKey:@"cartSkuId"];
    _skuPromoCodes = [decoder decodeObjectForKey:@"skuPromoCodes"];
    _productResizeImages = [decoder decodeObjectForKey:@"productResizeImages"];
    
    return self;
}



@end
