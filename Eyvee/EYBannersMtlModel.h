//
//  EYBannersMtlModel.h
//  Eyvee
//
//  Created by Neetika Mittal on 01/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface EYBannersMtlModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *bannerId;
@property (nonatomic, strong) NSString *bannerName;
@property (nonatomic, strong) NSString *headerText;
@property (nonatomic, strong) NSString *middleText;
@property (nonatomic, strong) NSString *bottomText;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSNumber *runOrder;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *headerFont;
@property (nonatomic, strong) NSNumber *middleFont;
@property (nonatomic, strong) NSNumber *bottomFont;
@property (nonatomic, strong) NSString *bannerImageText;
@property (nonatomic, strong) NSArray *resizedImages;
@property (nonatomic, strong) NSString *bannerProductsFile;


@end
