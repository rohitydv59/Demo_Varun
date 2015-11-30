//
//  EYUtility.m
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYUtility.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "EDProgress.h"
#import "EYConstant.h"
#import "EYShippingAddressMtlModel.h"
#import "EYWishlistModel.h"
#import "EYCartModel.h"
#import "EYEmptyView.h"

NSString *const kTabbarHideNotification = @"kTabbarHideNotification";
NSString *const kTabbarShowNotification = @"kTabbarShowNotification";
NSString *const kShopMoreButtonTappedNotification = @"kShopMoreButtonTappedNotification";
NSString *const kViewCartButtonTappedNotification = @"kViewCartButtonTappedNotification";

NSString *const kRentalPeriodChangeNotification = @"kRentalPeriodChangeNotification";

@interface EYUtility ()

@property (nonatomic, strong) NSString *letters;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSNumberFormatter *currencyFormatterWithoutDecimal;

@end

@implementation EYUtility

+ (EYUtility *)shared
{
    static dispatch_once_t onceToken;
    static EYUtility *shared = nil;
    
    dispatch_once(&onceToken, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    
    return shared;
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font
{
    if (!font || !string) {
        return CGSizeZero;
    }
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : font}];
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter) {
       return _dateFormatter;
    }
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return _dateFormatter;
}

- (NSCalendar *)calendar
{
    if (_calendar) {
        return _calendar;
    }
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return _calendar;
}

//+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font width:(float)width
//{
//    if (!font || !string) {
//        return CGSizeZero;
//    }
//    
//    CGSize size = [string boundingRectWithSize:(CGSize) {width, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : font} context:nil].size;
//    size.width = ceil(size.width);
//    size.height = ceil(size.height);
//    return size;
//}


+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font width:(float)width
{
    if (!string) {
        string = @"";
    }
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font}];
    return [self sizeForAttributedString:attrString width:width];
}

+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width
{
    CGSize size = [attrString boundingRectWithSize:(CGSize) {width, 300.0} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width height:(float)height
{
    CGSize size = [attrString boundingRectWithSize:(CGSize) {width, height} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (id)instantiateViewWithIdentifier:(NSString *)identifier
{
    if (identifier.length == 0)
    {
        return nil;
    }
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appdel.storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (NSString *)letters
{
    if (!_letters) {
        _letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    }
    return _letters;
}

#pragma mark - HUD

+ (void)showHUDWithTitle:(NSString *)title
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [EDProgress showProgressViewInWindow:delegate.window animated:YES withTitle:title];
}

+ (void)hideHUD
{
    [EDProgress hideProgressViewAnimated:YES];
}

- (NSString *)randomStringWithLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [self.letters characterAtIndex: arc4random_uniform((u_int32_t)[self.letters length])]];
    }
    
    return randomString;
}


- (NSString *)createCheckSumString:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA512(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

+ (void) showAlertView:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Eyvee"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void) showAlertView:(NSString *) title message:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


+ (BOOL) isDeviceGreaterThanSix
{
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    if (mainSize.width > 375)
        return YES;
    
    return NO;
}

+(void)okClicked
{
    
}

//- (BOOL)isUserLoggedIn
//{
//    return [[[NSUserDefaults standardUserDefaults] objectForKey:kUserLoggedInKey] boolValue];
//}

- (NSString *)getCartId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kCartIdKey];
}

- (void )removeCartId
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCartIdKey];
}

-(NSString *)getPinCode
{
     return [[NSUserDefaults standardUserDefaults] objectForKey:kPinCodeKey];
}

- (NSString *)getCookie
{
    NSString * cookie = [[NSUserDefaults standardUserDefaults] objectForKey:kCookieKey];
    if (!cookie)
    {
        cookie = [self randomStringWithLength:8];
        [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:kCookieKey];
    }
    return cookie;
}

- (void)userLoggedOut
{
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:kCartIdKey];
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:kUserTokenKey];
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:kUserIdKey];
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:kCookieKey];
    [[NSUserDefaults standardUserDefaults]  setObject:nil forKey:kPinCodeKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLocalAddressKey];
    EYCartModel * cart = [EYCartModel sharedManager];
    cart.cartModel = nil;
    EYWishlistModel * wishlist = [EYWishlistModel sharedManager];
    wishlist.wishlistModel = nil;
}


- (UIWindow *)getWindow

{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.window;
}

- (NSDate *)dateByAddingDays:(NSInteger)period toDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:period-1];
    return [self.calendar dateByAddingComponents:comp toDate:date options:0];
}

- (NSString *)getStringFromDate:(NSDate *)date
{
    return [self.dateFormatter stringFromDate:date];
}

- (NSDate *)getDateFromString:(NSString *)dateStr
{
    return [self.dateFormatter dateFromString:dateStr];
}
- (NSString *)getCurrencyFormatFromNumber:(float)number
{
    return [self.currencyFormatterWithoutDecimal stringFromNumber:[NSNumber numberWithFloat:number]];
}

- (NSNumberFormatter *)currencyFormatterWithoutDecimal
{
    if (_currencyFormatterWithoutDecimal) {
        return _currencyFormatterWithoutDecimal;
    }

    _currencyFormatterWithoutDecimal = [[NSNumberFormatter alloc] init];
    [_currencyFormatterWithoutDecimal setMaximumFractionDigits:0];
    [_currencyFormatterWithoutDecimal setNumberStyle: NSNumberFormatterCurrencyStyle];
//    [_currencyFormatterWithoutDecimal setCurrencySymbol:@"₹"];
    [_currencyFormatterWithoutDecimal setCurrencySymbol:@"Rs. "];
    return _currencyFormatterWithoutDecimal;
}

- (void)saveUserAddressWithModel:(EYShippingAddressMtlModel *)addressModel
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:addressModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLocalAddressKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (EYShippingAddressMtlModel *)getUserAddressModel
{
    NSData * modelData = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalAddressKey];
    EYShippingAddressMtlModel * aModel = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
    return aModel;
}

- (void)deleteUserAddressModel
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLocalAddressKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)checkAndDeleteUserAddressModelForAddress:(EYShippingAddressMtlModel *)shippingAddress
{
    EYShippingAddressMtlModel * aModel = [self getUserAddressModel];
    if ([aModel.addressId isEqualToNumber:shippingAddress.shippingAddressId]) {
        [self deleteUserAddressModel];
    }
}

//Date like 21st October
-(NSString *)getDateWithSuffix:(NSDate*)date
{
    if (!date) {
        return nil;
    }
    
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    NSString *str = [NSString stringWithFormat:@"%d%@ ",date_day,suffix];
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"MMMM"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
    
    NSString *dateString = [str stringByAppendingString:prefixDateString];
    
    return dateString;
}

//Date like 21st Oct
-(NSString*)getDateWithSuffixShortMonth:(NSDate*)date
{
    if (!date) {
        return nil;
    }
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    NSString *str = [NSString stringWithFormat:@"%d%@ ",date_day,suffix];
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"MMM"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
    
    NSString *dateString = [str stringByAppendingString:prefixDateString];
    
    return dateString;
}

//Date like 21 Oct
-(NSString *)getDateWithoutSuffix:(NSDate*)date
{
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d MMM"];
    NSString *str = [monthDayFormatter stringFromDate:date];
    return str;
}

//Share the app
+ (void)shareApp:(UIViewController *)controller
{
    NSString *string = [NSString stringWithFormat:@"Check out the awesome EazyDiner app!"];
    NSURL *url = [NSURL URLWithString:kAppGenericShareLink];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[controller,string, url] applicationActivities:nil];
   
    
    [controller presentViewController:activityViewController
                             animated:YES
                           completion:^{
                           }];
  
}


#pragma mark - empty view -

- (EYEmptyView *)errorViewWithText:(NSString *)errorText withImage:(UIImage *)image andRetryBtnHidden :(BOOL)hidden
{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EYEmptyView" owner:self options:nil];
    EYEmptyView *errorView = [nibObjects objectAtIndex:0];
    [errorView setMessageText:errorText withImage:image andRetryBtnHidden:hidden];
    return errorView;
}

+ (BOOL)cacheNeedsToBeCleared:(NSString *)timeStamp
{
    NSDate *dateCacheCleared = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000.0];
    
    NSDate *today10am =[NSDate date];
    
    NSInteger seconds = [today10am timeIntervalSinceDate:dateCacheCleared];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
//    if(days)
//        seconds -= days * 3600 * 24;
    
//    NSInteger hours = (int) (floor(seconds / 3600));
//    if(hours) seconds -= hours * 3600;
//    
//    NSInteger minutes = (int) (floor(seconds / 60));
//    if(minutes) seconds -= minutes * 60;
    
    if(days)
        return YES;
    else
        return NO;
}


@end
