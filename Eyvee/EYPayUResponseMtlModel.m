//
//  EYAllBanksMtlModel.m
//  Eyvee
//
//  Created by Neetika Mittal on 07/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYPayUResponseMtlModel.h"

@implementation EYPayUResponseMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"debitCards" : @"debitcard",
             @"allBanks" : @"netbanking",
             @"creditCards" : @"creditcard"
             };
}

+ (NSValueTransformer *)debitCardsJSONTransformer
{
    return [self getTransformedValue];
}

+ (NSValueTransformer *)getTransformedValue
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *options, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSArray *allKeys = [options allKeys];
        for (NSString *key in allKeys) {
            NSDictionary *values = options[key];
            NSError *err = nil;
            EYPayUResponseDetailsMtlModel *model = [MTLJSONAdapter modelOfClass:[EYPayUResponseDetailsMtlModel class] fromJSONDictionary:values error:&err];
            model.code = key;
            if (!err) {
                [arr addObject:model];
            }
        }
        return arr;
    }];

}

+ (NSValueTransformer *)creditCardsJSONTransformer
{
    return [self getTransformedValue];
}

+ (NSValueTransformer *)allBanksJSONTransformer
{
    return [self getTransformedValue];
}

@end

@implementation EYPayUResponseDetailsMtlModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bank_id" : @"bank_id",
             @"pgId" : @"pgId",
             @"pt_priority" : @"pt_priority",
             @"show_form" : @"show_form",
             @"title" : @"title",
             };
}

@end