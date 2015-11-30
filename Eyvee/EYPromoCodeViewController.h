//
//  EYPromoCodeViewController.h
//  Eyvee
//
//  Created by Disha Jain on 07/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYSyncCartMtlModel.h"

@protocol EYPromoCodeViewControllerDelegate <NSObject>

- (void)promoCodeAppliedAndFinalCartObject:(EYSyncCartMtlModel *)finalModel;

@end

@interface EYPromoCodeViewController : UIViewController

@property (nonatomic, weak) id<EYPromoCodeViewControllerDelegate> delegate;
@property (nonatomic, strong) EYSyncCartMtlModel * cartModelReceived;

@end
