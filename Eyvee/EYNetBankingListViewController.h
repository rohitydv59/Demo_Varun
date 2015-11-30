//
//  EYNetBankingListViewController.h
//  Eyvee
//
//  Created by Disha Jain on 12/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayUData.h"

@interface EYNetBankingListViewController : UIViewController
@property (strong,nonatomic)NSArray *allBanks;
@property (strong,nonatomic)PayUData *dataReceived;
@end
