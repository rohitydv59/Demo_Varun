//
//  EYAddToBagHeaderView.h
//  Eyvee
//
//  Created by Disha Jain on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYGetAllProductsMTLModel.h"
#import "EYAllOrdersMtlModel.h"
@interface EYAddToBagHeaderView : UIView
- (CGFloat)getHeight:(CGFloat)width;

-(void)setHeaderDetails:(EYProductsInfo *)productModelReceived withReceivedRentalPeriod:(NSInteger)rental;
-(void)updateHeaderPriceAsPerRentSelected:(NSInteger)rentalPeriod;

-(void)updateOrderDetailSummaryView:(EYAllOrdersMtlModel*)orderInfo;
+(CGFloat)requiredHeightforViewWithWidth:(CGFloat)width andProduct:(EYAllOrdersMtlModel*)productInfo;

@end
