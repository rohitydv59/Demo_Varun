//
//  EYGridCollectionCell.m
//  Eyvee
//
//  Created by Neetika Mittal on 12/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYGridCollectionCell.h"
#import "EYConstant.h"
#import "EYCategoryView.h"

@interface EYGridCollectionCell ()

@property (nonatomic, strong) EYCategoryView *categoryView;

@end

@implementation EYGridCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.categoryView = [[EYCategoryView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_categoryView];
}

- (void)setlabelmainText:(NSString *)mainText subtext:(NSString *)subText
{
    [self.categoryView setLabelText:mainText headerText:subText middleText:nil bottomText:nil WithVCMode:bannerVC];
}

- (void)setcategoryImage:(UIImage *)image
{
//    [self.categoryView setImgViewImage:image];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    self.categoryView.frame = rect;
}

@end
