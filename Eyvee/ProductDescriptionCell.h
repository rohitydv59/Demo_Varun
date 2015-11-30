//
//  productDescriptionCell.h
//  eyVee
//
//  Created by Disha Jain on 12/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDescriptionCell : UITableViewCell

+ (CGFloat)requiredHeightForRowWith:(CGFloat)width forText:(NSString *)text;
- (void)updateProductDescLabelText:(NSString *)text;

@end
