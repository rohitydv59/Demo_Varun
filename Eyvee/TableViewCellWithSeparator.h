//
//  TableViewCellWithSeparator.h
//  Eyvee
//
//  Created by Varun Kapoor on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellWithSeparator : UITableViewCell
-(void) updateTextOfLabel:(NSString *) text;
+(CGFloat)requiredheightForRowWithWidth:(CGFloat)width andText:(NSString*)text;
-(void)updateCellFont:(UIFont *)font;
-(void)updateCellFontColor:(UIColor *)color;

@property(nonatomic) BOOL isFilterMode;
@property(strong,nonatomic)UILabel *productDesc;
@property(strong,nonatomic)UIImageView *imgView;

@end
