//
//  EYHomeCategoryCell.h
//  Eyvee
//
//  Created by Neetika Mittal on 11/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "EYConstant.h"
@interface EYHomeCategoryCell : UITableViewCell

- (void)setlabelmainText:(NSString *)mainText headerText:(NSString*)headerText middleText:(NSString*)middleText bottomText:(NSString*)bottomText WithVCMode:(EYVCType)mode;
- (void)setcategoryImage:(UIImage *)image;
- (void)setBannerImage:(NSURL *)imageURl;
- (void)setHeaderTextFont:(NSInteger)headerFont middleTextFont:(NSInteger)middleTextFont bottomTextFont:(NSInteger)bottomTextFont;

@end
