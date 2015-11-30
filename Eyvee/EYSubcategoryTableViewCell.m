//
//  EYSubcategoryTableViewCell.m
//  Eyvee
//
//  Created by Disha Jain on 03/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYSubcategoryTableViewCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYSubcategoryTableViewCell () {
    NSInteger _leftBtnId;
    NSInteger _rightBtnId;
    NSString *leftBtnDataPath;
    NSString *rightBtnDataPath;
}

@property (nonatomic,strong) UIView * separatorLine;
@property (nonatomic,strong) UIView *buttonSeparator;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;

@end

@implementation EYSubcategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
    _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_leftButton setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    [_leftButton setTitleColor:RGB(32.0, 192.0, 108.0) forState:UIControlStateHighlighted];
    [self.leftButton.titleLabel setFont:AN_REGULAR(14.0)];
    [self.leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_rightButton setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    [_rightButton setTitleColor:RGB(32.0, 192.0, 108.0) forState:UIControlStateHighlighted];
    [self.rightButton.titleLabel setFont:AN_REGULAR(14.0)];

    [self.rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightButton];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_separatorLine];
    
    _buttonSeparator = [[UIView alloc]initWithFrame:CGRectZero];
    _buttonSeparator.backgroundColor = kSeparatorColor;
    [self.contentView addSubview:_buttonSeparator];
}


-(void)setSliderModelReceived:(EYSlidersMtlModel *)sliderModelReceived
{
    _sliderModelReceived = sliderModelReceived;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
    CGFloat thickness = 2.0/[UIScreen mainScreen].scale;
    _separatorLine.frame = CGRectMake(0, rect.size.height - thickness, rect.size.width, thickness);
    
    _leftButton.frame = (CGRect){0,0,rect.size.width/2-thickness/2,rect.size.height-thickness};
    _buttonSeparator.frame = (CGRect){CGRectGetMaxX(_leftButton.frame),0,thickness,rect.size.height-thickness};
    _rightButton.frame = (CGRect){rect.size.width/2+thickness/2,0,rect.size.width/2-thickness/2,rect.size.height-thickness};


}

- (void)setLeftItem:(NSString *)leftItem setRightItem:(NSString*)rightItem
{
    NSArray* leftArray = [leftItem componentsSeparatedByString: @":"];
    NSArray *rightArray = [rightItem componentsSeparatedByString:@":"];
    
    if (leftArray.count == 3) {
        self.rightButton.hidden = NO;
        _leftBtnId = [leftArray[0] integerValue];
        [_leftButton setTitle:leftArray[1] forState:UIControlStateNormal];
        leftBtnDataPath = leftArray[2];
    }
    else {
        self.leftButton.hidden = YES;
    }
    
    if (rightArray.count == 3)
    {
        _rightBtnId = [rightArray[0] integerValue];
        self.rightButton.hidden = NO;
        [_rightButton setTitle:rightArray[1] forState:UIControlStateNormal];
        rightBtnDataPath = rightArray[2];
    }
    else {
        self.rightButton.hidden = YES;
    }
    
    [self setNeedsLayout];
}

- (void)leftButtonTapped:(id)sender
{
    if ([_delegate respondsToSelector:@selector(leftBtnTapped:withId:andSliderModel:andSubCategoryName:andFilePath:)]) {
        [_delegate leftBtnTapped:sender withId:[NSArray arrayWithObject:[NSNumber numberWithInteger:_leftBtnId]] andSliderModel:self.sliderModelReceived andSubCategoryName:_leftButton.titleLabel.text andFilePath:leftBtnDataPath];
    }

}

- (void)rightButtonTapped:(id)sender
{
    if ((_rightButton.titleLabel.text.length>0))
    {
        if ([_delegate respondsToSelector:@selector(rightBtnTapped:withId:andSliderModel:andSubCategoryName:andFilePath:)]) {
            [_delegate rightBtnTapped:sender withId:[NSArray arrayWithObject:[NSNumber numberWithInteger:_rightBtnId]] andSliderModel:self.sliderModelReceived andSubCategoryName:_rightButton.titleLabel.text andFilePath:rightBtnDataPath];
        }
    }
    
   
}

@end
