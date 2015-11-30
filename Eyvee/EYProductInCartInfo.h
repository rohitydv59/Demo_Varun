//
//  EYProductInCartInfo.h
//  Eyvee
//
//  Created by Neetika Mittal on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EYGetAllProductsMTLModel.h"

@interface EYProductInCartInfo : NSObject

@property (nonatomic, strong) EYProductsInfo *productAllInfo;
@property (nonatomic, assign) NSInteger rentalPeriod;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *size;

@end