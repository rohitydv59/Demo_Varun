//
//  EYBadgedBarButtonItem.h
//  Eyvee
//
//  Created by Rohit Yadav on 16/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYBadgedBarButtonItem.h"
#import "EYBadgeButton.h"
#import "EYConstant.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"

@interface EYBadgedBarButtonItem()

@property (nonatomic, strong) EYBadgeButton *button;

@end

@implementation EYBadgedBarButtonItem

- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [self initWithImage:image target:target action:action tintColor:[UIColor blackColor]];
}

- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action tintColor:(UIColor *)color
{
    EYBadgeButton *button = [EYBadgeButton buttonWithType:UIButtonTypeSystem];
    [button setImage:image forState:UIControlStateNormal];
    button.tintColor = color;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    CGSize size = [button requiredSize];
    button.frame = (CGRect) {0.0, 0.0, size.width, size.height};
    
    self = [super initWithCustomView:button];
    if (self) {
        self.button = button;
        //get cart locally to update badge number
        EYSyncCartMtlModel *cart =[[EYCartModel sharedManager]getCartLocally];
        NSInteger count = cart.cartProducts.count;

//        NSInteger count = [[EYCartModel sharedManager].cartModel.cartProducts count];
        [self.button setBadgeText:[NSString stringWithFormat:@"%i", (int) count]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartUpdated:) name:kCartUpdatedNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cartUpdated:(NSNotification *)aNotification
{
    NSDictionary *dict = aNotification.userInfo;
    NSInteger count = [dict[@"count"] integerValue];
    [self setBadge:[NSString stringWithFormat:@"%i", (int)count]];
}

- (void)setBadge:(NSString *)badge
{
    [self.button setBadgeText:badge];
}

@end
