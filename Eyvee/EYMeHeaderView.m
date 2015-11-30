//
//  EYMeHeaderView.m
//  Eyvee
//
//  Created by Disha Jain on 19/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYMeHeaderView.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "UIImageView+AFNetworking.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"


@implementation EYMeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.imgBackgroud = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgBackgroud.backgroundColor = GRAYA(0.12, 1.0);
    self.imgBackgroud.contentMode = UIViewContentModeScaleAspectFill;
    self.imgBackgroud.clipsToBounds = YES;
    [self addSubview:self.imgBackgroud];
    
    self.lblName  = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lblName.numberOfLines = 0;
    self.lblName.attributedText = [self attributedString];
    self.lblName.textColor = [UIColor whiteColor];
    [self.imgBackgroud addSubview:self.lblName];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGFloat sidePadding = kProductDescriptionPadding;
    
    self.imgBackgroud.frame = rect;
    
    CGSize lblSize = [EYUtility sizeForAttributedString:self.lblName.attributedText width:rect.size.width - 2*sidePadding];
    
    self.lblName.frame = (CGRect){(self.imgBackgroud.frame.size.width - lblSize.width)/2 , (self.imgBackgroud.frame.size.height-lblSize.height)/2, lblSize};
}

- (void)setTextForLabel
{
    self.lblName.attributedText = [self attributedString];
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attributes = @{NSFontAttributeName:REGULAR(22.0),
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
    NSString *fullName = [EYAccountManager sharedManger].loggedInUser.fullName;
    if (fullName.length == 0) {
        fullName = [EYAccountManager sharedManger].loggedInUser.email;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    if (fullName.length>0) {
        [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",fullName] attributes:attributes]];
    }
    
    return attributedText;
}

@end
