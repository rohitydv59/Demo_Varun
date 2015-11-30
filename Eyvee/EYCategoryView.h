//
//  EYCategoryView.h
//  Eyvee
//
//  Created by Neetika Mittal on 11/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYConstant.h"

typedef enum {
    HeaderViewTypeNoButtons = 0,
    HeaderViewTypeCartButton = 1,
    HeaderViewTypeBackButton = 2,
    HeaderViewTypeAllButtons = 3
}HeaderViewType;

@interface EYCategoryView : UIView

@property (nonatomic, assign) HeaderViewType headerType;
@property (nonatomic, strong) UIButton *cartBtn;
@property (nonatomic, strong) UIButton *backBtn;

- (void)setLabelText:(NSString *)mainText headerText:(NSString *)headerText middleText:(NSString*)midText bottomText:(NSString*)btomText WithVCMode:(EYVCType)mode;

- (void)setImgViewImageWithUrl:(NSURLRequest*)urlRequest;
- (void)setHeaderTextFont:(NSInteger)headerFont middleTextFont:(NSInteger)middleTextFont bottomTextFont:(NSInteger)bottomTextFont;

- (void)resetImage;

@end
