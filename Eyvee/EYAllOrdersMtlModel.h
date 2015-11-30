//
//  EYConvertCartToOrderMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 18/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYAllOrdersMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *cartId;
@property (nonatomic, strong) NSNumber *cartSkuId;
@property (nonatomic, strong) NSNumber *shippingAddressId;
@property (nonatomic, strong) NSNumber *billingAddressId;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *skuId;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *rentalStartDate;
@property (nonatomic, strong) NSString *rentalEndDate;
@property (nonatomic, strong) NSNumber *shippingFee;
@property (nonatomic, strong) NSNumber *insurance;
@property (nonatomic, strong) NSNumber *rentalPrice;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *promoCodesDiscount;
@property (nonatomic, strong) NSNumber *tax;
@property (nonatomic, strong) NSNumber *amountPaidExclTax;
@property (nonatomic, strong) NSNumber *amountPaid;
@property (nonatomic, strong) NSNumber *rentalType;
@property (nonatomic, strong) NSString *paymentMethod; //
@property (nonatomic, strong) NSString *paymentMode; //
@property (nonatomic, strong) NSString *transactionId; //
@property (nonatomic, strong) NSNumber *carrierId;
@property (nonatomic, strong) NSString *expectedDeliveryDate;
@property (nonatomic, strong) NSString *expectedPickUpDate;
@property (nonatomic, strong) NSString *deliveredOn; //
@property (nonatomic, strong) NSString *pickedUpOn; //
@property (nonatomic, strong) NSNumber *invoiceNumber;
@property (nonatomic, strong) NSString *emailId;
@property (nonatomic, strong) NSString *contactNo; //
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *fullName; //
@property (nonatomic, strong) NSNumber *createdBy;
@property (nonatomic, strong) NSString *createdOn;
@property (nonatomic, strong) NSNumber *modifiedBy;
@property (nonatomic, strong) NSString *modifiedOn; //
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *productThumbnailImage;
@property (nonatomic, strong) NSNumber *validOrder;
@property (nonatomic, strong) NSNumber *manualOrder;

+ (NSDictionary *)JSONKeyPathsByPropertyKey;
@end
