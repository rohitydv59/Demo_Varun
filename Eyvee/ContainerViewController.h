//
//  ContainerViewController.h
//  Eyvee
//
//  Created by Varun Kapoor on 14/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"
#import "EYGetAllProductsMTLModel.h"
@class EYFilterDataModel;
@protocol ContainerViewControllerDelegate <NSObject>
-(void) passingNewAppliedFilters:(EYFilterDataModel *)filterModel;
-(void) resettingPageCount;

@end

@interface ContainerViewController : UIViewController
@property (nonatomic ,strong) EYFilterDataModel *appliedFilterModel;
@property (nonatomic ,strong) EYGetAllProductsMTLModel * allProductsWithFilterModel;

@property (nonatomic ,weak) id  <ContainerViewControllerDelegate> delegate;
@property (nonatomic ,strong) EYGetAllProductsMTLModel *productsFilterArray;

@end
