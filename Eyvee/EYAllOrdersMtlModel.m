//
//  EYConvertCartToOrderMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 18/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAllOrdersMtlModel.h"

@interface MTLJSONAdapterWithoutNil : MTLJSONAdapter
@end

@implementation MTLJSONAdapterWithoutNil

- (NSSet *)serializablePropertyKeys:(NSSet *)propertyKeys forModel:(id<MTLJSONSerializing>)model {
    NSMutableSet *ms = propertyKeys.mutableCopy;
    NSDictionary *modelDictValue = [model dictionaryValue];
    for (NSString *key in ms) {
        id val = [modelDictValue valueForKey:key];
        if ([[NSNull null] isEqual:val]) { // MTLModel -dictionaryValue nil value is represented by NSNull
            [ms removeObject:key];
        }
    }
    return [NSSet setWithSet:ms];
}

@end
@implementation EYAllOrdersMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"orderId" : @"orderId",
             @"userId" : @"userId",
             @"cartId" : @"cartId",
             @"cartSkuId" : @"cartSkuId",
             @"billingAddressId" : @"billingAddressId",
             @"shippingAddressId" : @"shippingAddressId",
             @"status" : @"status",
             @"skuId" : @"skuId",
             @"productId" : @"productId",
             @"rentalStartDate" : @"rentalStartDate",
             @"discount" : @"discount",
             @"promoCodesDiscount" : @"promoCodesDiscount",
             @"tax" : @"tax",
             @"amountPaidExclTax" : @"amountPaidExclTax",
             @"amountPaid" : @"amountPaid",
             @"rentalType" : @"rentalType",
             @"paymentMethod" : @"paymentMethod",
             @"paymentMode" : @"paymentMode",
             @"transactionId" : @"transactionId",
             @"carrierId" : @"carrierId",
             @"expectedDeliveryDate" : @"expectedDeliveryDate",
             @"expectedPickUpDate" : @"expectedPickUpDate",
//             @"promocodeName" : @"promocodeName",
             @"deliveredOn" : @"deliveredOn",
             @"pickedUpOn" : @"pickedUpOn",
             @"invoiceNumber" : @"invoiceNumber",
             @"emailId" : @"emailId",
             @"contactNo" : @"contactNo",
             @"orderStatus" : @"orderStatus",
             @"fullName" : @"fullName",
             @"createdBy" : @"createdBy",
             @"createdOn" : @"createdOn",
             @"modifiedBy" : @"modifiedBy",
             @"modifiedOn" : @"modifiedOn",
             @"productName" : @"productName",
             @"brandName" : @"brandName",
             @"size" : @"size",
             @"sku" : @"sku",
             @"productThumbnailImage" : @"productThumbnailImage",
             @"validOrder" : @"validOrder",
             @"manualOrder" : @"manualOrder",
             @"rentalEndDate" : @"rentalEndDate",
             @"shippingFee" : @"shippingFee",
             @"insurance" : @"insurance"
             };
}

+ (NSValueTransformer *)myDailyDataArrayJSONTransformer {
    return [MTLJSONAdapterWithoutNil arrayTransformerWithModelClass:EYAllOrdersMtlModel.class];
}



//missing: rentalEndDate: "2015­09­29" shippingFee: 0 insurance: 0

@end
