//
//  SortByRelevenceView.h
//  Eyvee
//
//  Created by Disha Jain on 18/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortByRelevanceViewDelegate <NSObject>

-(void)tableRowSelectedWithIndex:(NSInteger)index andValue:(NSString*)value;

@end

@interface SortByRelevenceView : UIView

@property(weak,nonatomic)id <SortByRelevanceViewDelegate> delegate ;

@property (strong,nonatomic)NSIndexPath *indexPathSelected;
@end
