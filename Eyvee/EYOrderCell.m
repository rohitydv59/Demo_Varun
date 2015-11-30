//
//  EYOrderCell.m
//  Eyvee
//
//  Created by Disha Jain on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYOrderCell.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYAddToBagHeaderView.h"
#import "EYAllOrdersMtlModel.h"

@interface EYOrderCell()
@property (strong, nonatomic) EYAddToBagHeaderView *orderSummaryView;
@end

@implementation EYOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _orderSummaryView = [[EYAddToBagHeaderView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_orderSummaryView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.bounds;
//    CGFloat heightOfCell = [_orderSummaryView getHeight:rect.size.width]; //check
    _orderSummaryView.frame = (CGRect){0,0,rect.size.width,rect.size.height};
    
}

-(void)updateOrderDetailCell:(EYAllOrdersMtlModel*)orderModel
{
    [_orderSummaryView updateOrderDetailSummaryView:orderModel];
}

+(CGFloat)getHeightForCellWithWidth:(CGFloat)width andProductModel:(EYAllOrdersMtlModel*)model
{
  CGFloat h= [EYAddToBagHeaderView requiredHeightforViewWithWidth:width andProduct:model];
    return h;
}





@end
