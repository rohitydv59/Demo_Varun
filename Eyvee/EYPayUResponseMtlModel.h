//
//  EYAllBanksMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 07/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYPayUResponseMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *creditCards;
@property (nonatomic, strong) NSArray *debitCards;
@property (nonatomic, strong) NSArray *allBanks;

@end

@interface EYPayUResponseDetailsMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *bank_id;
@property (nonatomic, strong) NSString *pgId;
@property (nonatomic, strong) NSString *pt_priority;
@property (nonatomic, strong) NSString *show_form;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *code;

@end