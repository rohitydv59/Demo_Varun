//
//  EYTabbar.m
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYTabbar.h"
#import "EYTabButton.h"
#import "EYConstant.h"
#import "EYWishlistModel.h"
#import "EYUserWishlistMtlModel.h"

@interface EYTabbar ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation EYTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [self addSubview:_toolbar];
    
    NSMutableArray *btnsMutableArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        EYTabButton *btn = [[EYTabButton alloc] initWithFrame:CGRectZero];
        [btn setUnSelectedImage:[self getImageForIndex:i] tintColor:kTabTintColor];
        
        btn.isBtnSelected = (i == 0) ? YES : NO;
        btn.tag = i;
        if ( i == 3) {
            NSInteger count = [EYWishlistModel sharedManager].wishlistModel.allWishlists.count;
            [btn setBadgeText:[NSString stringWithFormat:@"%li",(long)count]];
        }
        [self addSubview:btn];
        [btnsMutableArr addObject:btn];
    }
    self.btns = [NSArray arrayWithArray:btnsMutableArr];
}

- (UIImage *)getImageForIndex:(int)index
{
    NSString *imageName = @"";
    switch (index) {
        case 0: imageName = @"nav_home";
            break;
        
        case 1: imageName = @"nav_explore";
            break;
        
        case 2: imageName = @"nav_user";
            break;
        
        case 3: imageName = @"nav_recommendation";
            break;
            
        default: imageName = @"Me_tabbar";
            break;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    
    self.toolbar.frame = rect;
    
    if (self.btns.count > 0) {
        CGFloat w = rect.size.width/self.btns.count;
        int x = 0.0;
        for (EYTabButton *tabbarBtn in self.btns) {
            tabbarBtn.frame = (CGRect) {x, 0.0, w, rect.size.height};
            x += w;
        }
    }
}

@end
