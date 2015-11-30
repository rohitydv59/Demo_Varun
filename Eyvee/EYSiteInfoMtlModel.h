//
//  EYSiteInfoMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYSiteInfoMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *shippingInformation;
@property (nonatomic, strong) NSString *qualityAssurance;
@property (nonatomic, strong) NSString *freeText1;
@property (nonatomic, strong) NSString *freeText2;
@property (nonatomic, strong) NSString *freeText3;

@end
