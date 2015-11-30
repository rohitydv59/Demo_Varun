//
//  EYAllAddressVC.h
//  Eyvee
//
//  Created by kartik shahzadpuri on 9/24/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYConstant.h"

@class EYSyncCartMtlModel;
@class EYAllAddressMtlModel;

@interface EYAllAddressVC : UIViewController
@property (nonatomic, strong) EYAllAddressMtlModel * addressModl;
@property (nonatomic, strong) EYSyncCartMtlModel * currentCart;
@property (assign, nonatomic) EYAllAddressMode comingFromMode;
@property (nonatomic) BOOL comingFromReview;
@end
