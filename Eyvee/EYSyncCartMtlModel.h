//
//  EYSyncCartMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 18/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
#import "EYShippingAddressMtlModel.h"

@interface EYSyncCartMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *cartId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *cookie;
@property (nonatomic, strong) NSNumber *shippingAddressId;
@property (nonatomic, strong) NSNumber *billingAddressId;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSDate *modifiedOn;
@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSString *modifiedBy;
@property (nonatomic, strong) NSNumber *isConvertedToOrder;
@property (nonatomic, strong) NSNumber *totalRentalPrice;
@property (nonatomic, strong) NSNumber *totalDiscount;
@property (nonatomic, strong) NSNumber *totalDiscountViaPromoCode;
@property (nonatomic, strong) NSNumber *totalShippingFee;
@property (nonatomic, strong) NSNumber *totalInsurance;
@property (nonatomic, strong) NSNumber *totalTax;
@property (nonatomic, strong) NSNumber *totalAmountPayableTaxExcl;
@property (nonatomic, strong) NSNumber *totalAmountPayable;
@property (nonatomic, strong) NSNumber *freeShipping;
@property (nonatomic, strong) NSArray *promoCodes;
@property (nonatomic, strong) NSNumber *promocodeId;
@property (nonatomic, strong) NSString *promocodeName;
@property (nonatomic, strong) NSNumber *amountPaid;
@property (nonatomic, strong) NSString *paymentMode;
@property (nonatomic, strong) NSString *tranactionId;
@property (nonatomic, strong) NSArray *cartProducts;
// for validate
@property (nonatomic, strong) NSNumber *isValidForOrder;
@property (nonatomic, strong) EYShippingAddressMtlModel * cartAddress;

@end

@interface EYSyncCartProductDetails : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSNumber *entityId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSNumber *sizeId;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSNumber *rentalPrice;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *discountViaPromoCode;
@property (nonatomic, strong) NSNumber *shippingFee;
@property (nonatomic, strong) NSNumber *insurance;
@property (nonatomic, strong) NSNumber *tax;
@property (nonatomic, strong) NSNumber *amountPayableTaxExcl;
@property (nonatomic, strong) NSNumber *amountPayable;
@property (nonatomic, strong) NSString *rentalStartDate;
@property (nonatomic, strong) NSString *rentalEndDate;
@property (nonatomic, strong) NSNumber *rentalType;
@property (nonatomic, strong) NSNumber *cartId;
@property (nonatomic, strong) NSNumber *cartSkuId;
@property (nonatomic, strong) NSArray *skuPromoCodes;
@property (nonatomic, strong) NSArray *productResizeImages;

@end
