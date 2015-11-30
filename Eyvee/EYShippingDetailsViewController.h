//
//  EYShippingDetailsViewController.h
//  Eyvee
//
//  Created by Disha Jain on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYConstant.h"


@class EYSyncCartMtlModel;
@class EYAllAddressMtlModel;
@class EYShippingAddressMtlModel;
@protocol EYNewAddressAddedDelegate <NSObject>

- (void)newAddressAddedDelegateWithAllAddressModel:(EYAllAddressMtlModel *)allAddresses;
@end

@interface EYShippingDetailsViewController : UIViewController
@property (nonatomic, weak) id<EYNewAddressAddedDelegate> delegate;
@property (nonatomic, strong) EYSyncCartMtlModel * cartModel;
@property (nonatomic,strong)EYShippingAddressMtlModel *addressModel;

@property (nonatomic) BOOL updateAddress;
@property (nonatomic) BOOL comingFromReview;
@property (nonatomic,assign)EYAllAddressMode comingFromMode;

@end
