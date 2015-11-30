//
//  EYUtility.h
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class EYEmptyView;
@class EYShippingAddressMtlModel;
extern NSString *const kTabbarHideNotification;
extern NSString *const kTabbarShowNotification;
extern NSString *const kShopMoreButtonTappedNotification;
extern NSString *const kViewCartButtonTappedNotification;
extern NSString *const kRentalPeriodChangeNotification;

typedef enum {
    ProductsSortingWithPriceLowToHigh = 1,
    ProductsSortingWithPriceHighToLow = 2
}ProductsSortingWithPrice;

@interface EYUtility : NSObject

+ (EYUtility *)shared;

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font;
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font width:(float)width;
+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width;
+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width height:(float)height;

+ (id)instantiateViewWithIdentifier:(NSString *)identifier;
+ (void) showAlertView:(NSString *) message;
+ (void) showAlertView:(NSString *) title message:(NSString *) message;

+ (BOOL) isDeviceGreaterThanSix;

- (NSString *)randomStringWithLength:(int)len;
- (NSString *)createCheckSumString:(NSString *)input;

+ (void)showHUDWithTitle:(NSString *)title;
+ (void)hideHUD;

- (UIWindow *)getWindow;
- (void)userLoggedOut;

- (NSString *)getCookie;
- (NSString *)getCartId;
- (void )removeCartId;
- (NSString *)getPinCode;

- (NSString *)getStringFromDate:(NSDate *)date;
- (NSDate *)getDateFromString:(NSString *)dateStr;
- (NSDate *)dateByAddingDays:(NSInteger)period toDate:(NSDate *)date;

- (NSString *)getCurrencyFormatFromNumber:(float)number;
- (void)saveUserAddressWithModel:(EYShippingAddressMtlModel *)addressModel;
- (EYShippingAddressMtlModel *)getUserAddressModel;
- (void)deleteUserAddressModel;
-(NSString*)getDateWithSuffix:(NSDate*)date;
-(NSString*)getDateWithSuffixShortMonth:(NSDate*)date;
-(NSString *)getDateWithoutSuffix:(NSDate*)date;
- (void)checkAndDeleteUserAddressModelForAddress:(EYShippingAddressMtlModel *)shippingAddress;
- (EYEmptyView *)errorViewWithText:(NSString *)errorText withImage:(UIImage *)image andRetryBtnHidden :(BOOL)hidden;

+ (BOOL)cacheNeedsToBeCleared:(NSString *)timeStamp;
+ (void)shareApp:(UIViewController *)controller;

@end
