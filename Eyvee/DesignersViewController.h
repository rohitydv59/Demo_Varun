//
//  DesignersViewController.h
//  Eyvee
//
//  Created by Varun Kapoor on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYConstant.h"
#import "EYFilterDataModel.h"

typedef enum designerSection
{
    enum_Top,
    enum_allDesigners
} designer_Type;

@interface DesignersViewController : UIViewController
-(void) resettingDesingersFilter;
@property (nonatomic, strong) NSMutableArray *appliedFilerArray_DesignerView;
@property (nonatomic ,strong) EYFilterDataModel *appliedFilterModel;
@property (nonatomic ,strong) NSArray *filterProductModelArray;
@property(nonatomic, strong)  EYFilterDataModel *localFiterModel;
@property (nonatomic ,strong) NSArray *topDesignerModelArray;
@property (nonatomic ,strong) NSArray *allDesignerModelArray;
@end
