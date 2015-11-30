//
//  EYOrderDetailsViewController.h
//  Eyvee
//
//  Created by Disha Jain on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYAddToBagHeaderView.h"
#import "EYUtility.h"
#import "EYConstant.h"
#import "EYAllOrdersMtlModel.h"
#import "EYShippingAddressMtlModel.h"
@interface EYOrderDetailsViewController : UITableViewController
@property (strong, nonatomic) EYAllOrdersMtlModel *orderModelReceived;
@property (nonatomic, assign) EYMyOrderType orderTypeReceived;
@property (strong, nonatomic) EYAllAddressMtlModel *allAddressesReceived;
@end
