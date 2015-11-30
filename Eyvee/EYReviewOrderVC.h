//
//  EYReviewOrderVC.h
//  Eyvee
//
//  Created by Disha Jain on 18/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EYSyncCartMtlModel;
//#import "EYShippingDataModel.h"

@interface EYReviewOrderVC : UIViewController
@property (nonatomic, strong) EYSyncCartMtlModel * cartModel;

//@property (strong, nonatomic) EYShippingDataModel *shippingModelReceived;

@end
