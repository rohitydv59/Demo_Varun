//
//  EYSelectSizeView.h
//  Eyvee
//
//  Created by Disha Jain on 14/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  kScrollButtonnTag 890

@class EYSelectSizeView;
@protocol EYSelectSizeViewDelegate <NSObject>

@optional

-(void)viewTouched:(EYSelectSizeView*)view andButtonValue:(NSString*)buttonValue andTag:(NSInteger)buttonTag;

@optional
-(void)updateSizeButtonValue:(NSString *)buttonValue andButtonTag:(NSInteger)buttonTag;
-(void) updatingSelectedSizeArray:(BOOL) isButtonSelected andSelectedIndex:(NSNumber*)selectedSizeId;
@end

typedef enum
{
    EYSelectSizeForFilter,
    EYSelectSizeForProductDetail,
    EYSelectSizeForAddToCart
}EYSelectSizeMode;

@interface EYSelectSizeView : UIView
@property (weak,nonatomic)id <EYSelectSizeViewDelegate> delegate;
@property (strong,nonatomic)UIButton *rightButton;

@property (nonatomic,assign)EYSelectSizeMode sizeMode;

@property (nonatomic,strong)NSArray *valuesArray;
@property (nonatomic,strong)NSArray *valuesIdsArray;

-(instancetype)initWithFrame:(CGRect)frame andMode:(EYSelectSizeMode)mode andArrayOfValues:(NSArray*)arrayOfValues andArrayOfValues:(NSArray*)arrayOfValueIds;

@property (assign,nonatomic)NSInteger tagReceived;

-(void)updateTagReceivedToShowSelectedSize:(NSInteger)tagReceived;

-(void) resettingSizeFiler;
-(void) updateButtons:(NSMutableArray *)selectedButton;
@end
