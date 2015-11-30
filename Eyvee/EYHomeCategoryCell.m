//
//  EYHomeCategoryCell.m
//  Eyvee
//
//  Created by Neetika Mittal on 11/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYHomeCategoryCell.h"
#import "EYConstant.h"
#import "EYCategoryView.h"
#import "UIImageView+AFNetworking.h"

@interface EYHomeCategoryCell ()

@property (nonatomic, strong) EYCategoryView *categoryView;

@end

@implementation EYHomeCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.categoryView = [[EYCategoryView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_categoryView];
}

- (void)setlabelmainText:(NSString *)mainText headerText:(NSString*)headerText middleText:(NSString*)middleText bottomText:(NSString*)bottomText WithVCMode:(EYVCType)mode
{
    [self.categoryView setLabelText:mainText headerText:headerText middleText:middleText bottomText:bottomText WithVCMode:mode];
}

-(void)setHeaderTextFont:(NSInteger)headerFont middleTextFont:(NSInteger)middleTextFont bottomTextFont:(NSInteger)bottomTextFont
{
    [self.categoryView setHeaderTextFont:headerFont middleTextFont:middleTextFont bottomTextFont:bottomTextFont];
}

- (void)setcategoryImage:(UIImage *)image
{
//    [self.categoryView setImgViewImage:image];
}

- (void)setBannerImage:(NSURL *)imageURl
{
    if (!imageURl) {
        [self.categoryView resetImage];
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURl];
    [self.categoryView setImgViewImageWithUrl:request];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    self.categoryView.frame = rect;
}

@end
