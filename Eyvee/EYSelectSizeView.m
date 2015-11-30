//
//  EYSelectSizeView.m
//  Eyvee
//
//  Created by Disha Jain on 14/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYSelectSizeView.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface EYSelectSizeView()
@property (nonatomic, strong) UIView * headerView;

@property (strong,nonatomic)UILabel *leftLabel;
@property (strong,nonatomic)NSMutableArray *buttonArray;
@property (strong,nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong) UIView * separatorLine;

@property (nonatomic ) BOOL isButtonSelected;

@property (nonatomic, strong) NSString *buttonSizeValueReceived;

@end

@implementation EYSelectSizeView

-(instancetype)initWithFrame:(CGRect)frame andMode:(EYSelectSizeMode)mode andArrayOfValues:(NSArray*)arrayOfValues andArrayOfValues:(NSArray*)arrayOfValueIds
{
    self = [super initWithFrame:frame];

    _sizeMode = mode;
    _valuesArray = arrayOfValues;
    _valuesIdsArray = arrayOfValueIds;
    if (self)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];

        _buttonArray = [[NSMutableArray alloc]init];
        [self addSubview:_scrollView];
        int k = -1;
        for (int i = 0; i < _valuesArray.count; i++)
        {
            NSNumber* sizeId = [_valuesIdsArray objectAtIndex:i];
            if (sizeId.intValue == FreeSizeID)                                  // freesize
            {
                k = i - 1;
                continue;
            }
            else
            {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
                [button setTitle:_valuesArray[i] forState:UIControlStateNormal];
                k++;
                [button setTintColor:[UIColor clearColor]];
                if (_sizeMode == EYSelectSizeForFilter)
                {
                    [button setEnabled:true];
                    [button addTarget:self action:@selector(buttonClickedForFilter:) forControlEvents:UIControlEventTouchUpInside];
                    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
                    [self addSubview:self.headerView];
                }
                else if (_sizeMode == EYSelectSizeForAddToCart || _sizeMode == EYSelectSizeForProductDetail)
                {
                    [button setEnabled:true];
                    [button addTarget:self action:@selector(buttonClickedForProduct:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [button setEnabled:false];
                }
                
                [button.titleLabel setFont:AN_MEDIUM(14)];
                button.clipsToBounds = YES;
                button.layer.cornerRadius = kSizeCell / 2.0f;
                button.layer.borderColor = kBlackTextColor.CGColor;
                button.layer.borderWidth = 1.0f;
                [button setTitleColor:kBlackTextColor forState:UIControlStateNormal];
                [button setTitleColor:kAppGreenColor forState:UIControlStateSelected ];
                
                [self.scrollView addSubview:button];
                
//                [button setTag:kScrollButtonnTag + k];
                [button setTag:[sizeId integerValue]];

                
                [_buttonArray addObject:button];
            }
          
        }
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightButton setTintColor:kBlackTextColor];

        _leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _leftLabel.numberOfLines = 1;
        
        _rightButton.titleLabel.font = AN_REGULAR(11);
        [_rightButton setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _leftLabel.font = AN_BOLD(11);                            // for filter
        [_leftLabel setTextColor:kBlackTextColor];                  // for filter
        [self.rightButton.imageView setContentMode:UIViewContentModeLeft];
        _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
        _separatorLine.backgroundColor = kSeparatorColor;
        
        [self addSubview:_separatorLine];
        [self addSubview:_leftLabel];
        [self addSubview:_rightButton];
        
        [self setUpWithMode:mode];
    }
    return self;
}

//to update selected size in bottom view received from detail view selection

-(void)updateTagReceivedToShowSelectedSize:(NSInteger)tagReceived
{
    _tagReceived=tagReceived;
    
    UIColor *selectedColor = kAppGreenColor;
    UIColor *unSelectedColor = kBlackTextColor;
  
    if (_sizeMode == EYSelectSizeForAddToCart)
    {
        for (UIButton *btn in self.buttonArray) {
            if (btn.tag == _tagReceived) {
                //select the button
                btn.layer.borderColor= selectedColor.CGColor;
                _buttonSizeValueReceived = btn.titleLabel.text; //check here
                btn.selected = 1;
            }
            else
            {
                //unselect the button
                btn.layer.borderColor=unSelectedColor.CGColor;
                btn.selected = 0;
                
            }
        }
    }
}

-(void)setUpWithMode:(EYSelectSizeMode)mode
{
    if (mode == EYSelectSizeForAddToCart)
    {
        //in bottom view
        [_rightButton setTitle:[NSString stringWithFormat:@"%@%@",@"SIZE GUIDE",kRightSymbol] forState:UIControlStateNormal];
        _leftLabel.text = @"SELECT SIZE";
        _leftLabel.textColor = kBlackTextColor;
        _leftLabel.font = AN_BOLD(11.0);
       
    }
    else if (mode == EYSelectSizeForProductDetail)
    {
        [_rightButton setTitle:@"SIZE GUIDE" forState:UIControlStateNormal];
//        [_rightButton setImage:[UIImage imageNamed:@"next_small"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"arrow_next"] forState:UIControlStateNormal];

        _leftLabel.text = @"AVAILABLE SIZES";
       
    }
    else
    {
        _leftLabel.text = @"SELECT SIZE";
        [_rightButton setTitle:@"SIZE GUIDE" forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"arrow_next"] forState:UIControlStateNormal];
//        [_rightButton setImage:[UIImage imageNamed:@"next_small"] forState:UIControlStateNormal];

    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    CGFloat headerHeight = 52;
    CGFloat padding = 18.0;
    CGFloat bottomPadding = 16.0;
    CGFloat paddingImageAndLabel = 10.0;
    CGFloat imageWidth = 12.0;
    
    //Right Button
    
    CGSize sizeOfButton = [EYUtility sizeForString:_rightButton.titleLabel.text font:_rightButton.titleLabel.font];
    
    //Left Label:
    CGFloat availableWForLeftLabel = size.width - padding * 2 - sizeOfButton.width;
    CGSize sizeOfLeftLabel = [EYUtility sizeForString:_leftLabel.text font:_leftLabel.font width:availableWForLeftLabel];
    CGFloat thickness = 1;
    
    if (_sizeMode == EYSelectSizeForFilter)
    {
        self.rightButton.frame = (CGRect){size.width - (sizeOfButton.width) - paddingImageAndLabel - imageWidth - kTableViewLargePadding,headerHeight - (kcellPadding + sizeOfLeftLabel.height - 4),sizeOfButton.width + paddingImageAndLabel + imageWidth, MAX(sizeOfButton.height, imageWidth) };
        [self.headerView setFrame:CGRectMake(0, 0, size.width, headerHeight)];
        [self.headerView setBackgroundColor:kLightGrayBgColor];
        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -paddingImageAndLabel - imageWidth, 0, 0)];
//
        [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0,(self.rightButton.frame.size.width - paddingImageAndLabel) + 1, 0, 0)];
        _leftLabel.frame = (CGRect){kTableViewLargePadding, headerHeight - (kcellPadding + sizeOfLeftLabel.height - 4) ,sizeOfLeftLabel};
    }
    else if (_sizeMode == EYSelectSizeForProductDetail)
    {
        self.rightButton.frame = (CGRect){size.width - (sizeOfButton.width) - paddingImageAndLabel - imageWidth -kTableViewLargePadding,headerHeight - (kcellPadding + sizeOfLeftLabel.height),sizeOfButton.width + paddingImageAndLabel + imageWidth, MAX(sizeOfButton.height, imageWidth) };
        [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -paddingImageAndLabel - imageWidth, 0, 0)];
        [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.rightButton.frame.size.width - paddingImageAndLabel, 0, 0)];
        _leftLabel.frame = (CGRect){kTableViewLargePadding, headerHeight - (kcellPadding + sizeOfLeftLabel.height) ,sizeOfLeftLabel};
    }
    else
    {   //sizeMode == add to cart
        CGRect rectB = CGRectInset(_rightButton.frame, -12, -12);
        _rightButton.frame = rectB;

        self.rightButton.frame = (CGRect){size.width - (sizeOfButton.width)-kProductDescriptionPadding,bottomPadding,sizeOfButton};
        [self.headerView setFrame:CGRectZero];
         _leftLabel.frame = (CGRect){kProductDescriptionPadding, bottomPadding ,sizeOfLeftLabel};
    }
      //Separator
    
    CGFloat yAfterlabel = MAX(CGRectGetMaxY(_leftLabel.frame), CGRectGetMaxY(_rightButton.frame));
   
    if (self.sizeMode == EYSelectSizeForAddToCart)
    {
     _separatorLine.frame = CGRectMake(0, 0.0, size.width, yAfterlabel+bottomPadding);
    }
    else
    {
      _separatorLine.frame = CGRectMake(0, size.height-thickness, size.width, thickness);
    }
    
    //scroll view
    if (self.sizeMode == EYSelectSizeForFilter)
    {
        CGFloat heightForScroll = size.height - (headerHeight + thickness);
        self.scrollView.frame = (CGRect){0, headerHeight, size.width, heightForScroll};
        //buttons
        
        CGSize buttonSize = (CGSize){kSizeCell , kSizeCell};
        
        float reqW = 0.0;
        float o_x = 24;
        // Calculating Required Width for Content Size
        for (UIButton *button in self.buttonArray)
        {
            reqW = kLineAndTextSpacing + kSizeCell;
            button.frame = (CGRect) {o_x, (_scrollView.frame.size.height - buttonSize.height)/2, kSizeCell, kSizeCell};
            
            o_x += reqW;
        }
        self.scrollView.contentSize = (CGSize) {self.buttonArray.count * kSizeCell + (self.buttonArray.count - 1)*kLineAndTextSpacing + 48, buttonSize.height};
    }
    else
    {
        CGFloat heightForScroll = size.height - (16.0 + sizeOfLeftLabel.height + thickness);
        self.scrollView.frame = (CGRect){0, CGRectGetMaxY(self.leftLabel.frame), size.width, heightForScroll};
        //buttons
        
        CGSize buttonSize = (CGSize){kSizeCell , kSizeCell};
        
        float reqW = 0.0;
        float o_x = kProductDescriptionPadding;
        // Calculating Required Width for Content Size
        for (UIButton *button in self.buttonArray)
        {
            reqW = kLineAndTextSpacing + kSizeCell;
            button.frame = (CGRect) {o_x, (_scrollView.frame.size.height - buttonSize.height)/2, kSizeCell, kSizeCell};
            
            o_x += reqW;
        }
        self.scrollView.contentSize = (CGSize) {o_x - kProductDescriptionPadding, buttonSize.height};
    }
//    NSLog(@"self.scrollView.contentSize %@");
}

//to dismiss bottom pop up view on click on the view
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch= [touches anyObject];
    
    if ([touch view] == self)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(viewTouched:andButtonValue:andTag:)])
        {
            [_delegate viewTouched:self andButtonValue:_buttonSizeValueReceived andTag:_tagReceived];
        }
    }
}

-(void) buttonClickedForFilter:(id) sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected)
    {
        button.layer.borderColor = kBlackTextColor.CGColor;
        self.isButtonSelected = 0;
        button.selected = 0;
    }
    else
    {
        button.layer.borderColor = kAppGreenColor.CGColor;
        [button setTitleColor:kAppGreenColor forState:UIControlStateSelected ];

        self.isButtonSelected = 1;
        button.selected = 1;
    }
    
//    NSInteger selectedIndex = (NSInteger)button.tag - kScrollButtonnTag;
    NSNumber *selectedIndex = [NSNumber numberWithInteger:button.tag];

    [_delegate updatingSelectedSizeArray:(BOOL) button.selected andSelectedIndex:selectedIndex];
}

-(void) resettingSizeFiler
{
    for (UIButton *btn in self.buttonArray)
    {
        if (btn.selected)
        {
            btn.selected = 0;
        }
    }
}

-(void)buttonClickedForProduct:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    UIColor *selectedColor = kAppGreenColor;
    UIColor *unSelectedColor = kBlackTextColor;
    for (UIButton *btn in self.buttonArray)
    {
        if (button.tag == btn.tag)
        {
            if (btn.selected)
            {
                btn.layer.borderColor=unSelectedColor.CGColor;
                btn.selected = 0;
               
                   //check here
                    _buttonSizeValueReceived = nil;
                    _tagReceived = 0;
                
                if (self.sizeMode == EYSelectSizeForAddToCart)
                {
                    //update cell middle label value
                    [_delegate viewTouched:self andButtonValue:@"Select" andTag:0];
                }
                else if (self.sizeMode == EYSelectSizeForProductDetail)
                {
                    //to update selected size button from detail view to bottom pop up view and cell in add to cart
                    [_delegate updateSizeButtonValue:@"Select" andButtonTag:0];
                }
               

            }
            else
            {
                btn.layer.borderColor=selectedColor.CGColor;
                btn.selected = 1;
               
                    //check here too
                    _buttonSizeValueReceived = btn.titleLabel.text;
                _tagReceived = btn.tag;
                
                if (self.sizeMode == EYSelectSizeForAddToCart)
                {
                     //update cell middle label value
                    [_delegate viewTouched:self andButtonValue:_buttonSizeValueReceived andTag:button.tag];
                }
                else if (self.sizeMode == EYSelectSizeForProductDetail)
                {
                    //to update selected size button from detail view to bottom pop up view and cell in add to cart
                    [_delegate updateSizeButtonValue:_buttonSizeValueReceived andButtonTag:button.tag];
                }
                
                
            }
        }
        else
        {
            btn.layer.borderColor=unSelectedColor.CGColor;
            btn.selected = 0;
        }
    }
    

}


-(void) updateButtons:(NSMutableArray *)selectedButtonArray
{
    if (selectedButtonArray.count == 0)                 // for resetting
    {
        for (UIButton * button in self.buttonArray)
        {
            {
                button.layer.borderColor = kBlackTextColor.CGColor;
                self.isButtonSelected = 0;
                button.selected = 0;
            }
        }
    }
    else
    {
        for (NSDictionary * dict in selectedButtonArray)
        {
            for (UIButton * button in self.buttonArray)
            {
                if ([[dict objectForKey:@"valueName"] isEqualToString:button.titleLabel.text])
                {
                    button.layer.borderColor = kAppGreenColor.CGColor;
                    self.isButtonSelected = 1;
                    button.selected = 1;
                }
                
            }
        }
    }
    
}
@end