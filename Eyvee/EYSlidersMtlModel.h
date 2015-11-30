//
//  EYSlidersMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 01/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import "EYGetAllProductsMTLModel.h"
#import <Mantle.h>

@interface EYSlidersMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *sliderId;
@property (nonatomic, strong) NSNumber *sliderType;
@property (nonatomic, strong) NSString *headerText;
@property (nonatomic, strong) NSNumber *headerFontSize;
@property (nonatomic, strong) NSString *middleText;
@property (nonatomic, strong) NSNumber *middleFontSize;
@property (nonatomic, strong) NSString *bottomText;
@property (nonatomic, strong) NSNumber *bottomFontSize;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *sliderTypeVal;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSArray *children;

@property (nonatomic, strong) NSArray *resizedImages;

//added
//@property (nonatomic, strong) NSArray *childrenDataFilePath;

@end
