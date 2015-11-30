//
//  EYAllBrandsMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYAllBrandsMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSNumber *displayInMenu;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *topDesigner;

@end
