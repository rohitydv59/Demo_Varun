//
//  EYConstant.h
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#ifndef Eyvee_EYConstant_h
#define Eyvee_EYConstant_h

typedef enum{
    EDLoaderHeaderMode,
    EDLoaderBottomMode
} EDLoaderMode;

typedef enum{
    comingFromBagMode,
    comingFromReviewMode,
    comingFromMeMode
} EYAllAddressMode;

typedef enum
{
    GetProductsFromBanner,
    GetProductsFromSlider,
    GETProductsFromWishlist
    
}EYProductCategory;

typedef enum
{
    EYCustomAccessoryViewCellTypeDefault,
    EYCustomAccessoryViewCellTypeAddressList,
    EYCustomAccessoryViewCellTypeFromMe,
    EYCustomAccessoryViewCellPromo,
    EYCustomAccessoryViewCellPromoApplied
    
}EYCustomAccessoryViewCellType;

typedef enum
{
    bannerVC,
    sliderVC,
    
}EYVCType;

typedef enum
{
    EYOrderCurrent,
    EYOrderPast
}EYMyOrderType;

#define BASE_URL @"http://52.88.31.116/webservices/"
#define kAuthTokenKey @"auth-token"
#define kUserTokenKey @"user-token"
#define kUserEmailKey @"email"
#define kUserFirstName @"firstName"
#define kUserLastName @"lastName"
#define kUserIdKey @"userid"
#define kContentTypeKey @"Content-Type"
#define kAuthorizationKey @"authorization"
#define kAppAuthToken @"50e1246dcb35daa36fc6949b8947fd2a"
#define kAppGenericShareLink @"http://www.google.com"


#define kGetAllBrandsRequestPath @"getAllBrands.json"
#define kGetAllProductsRequestPath(a) [NSString stringWithFormat:@"getSpecificProducts.json?page=%@",a] //@"getSpecificProducts.json"
#define kBrandSizeChartRequestPath @"getBrandSizeChart.json"
#define kBannersRequestPath @"getAllBanners.json"
#define kSlidersRequestPath @"getAllSliders.json"
#define kSignUpRequestPath @"signUp.json"
#define kSignInRequestPath @"signIn.json"
#define kResetPasswordPath @"resetPassword.json"
#define kUpdatePasswordPath @"updateUserPassword.json"
#define kUpdateUserProfile @"updateUserProfile.json"
#define kGetSiteInfoRequestPath @"getSiteInfo.json"
#define kGetProductIdsInUserWishlist @"getProductIdsInUserWishlists.json"
#define kSyncCartRequestPath @"updateCart.json"
#define kValidateCartRequestPath @"validateCart.json"
#define kConvertCartToOrderRequestPath @"convertCartToOrder.json"
#define kGetAllOrdersRequestPath @"getAllOrdersForUser.json"
#define kGetOrderDetailRequestPath @"getOrderDetails.json"
#define kGetAllOrdersForCartRequestPath @"getAllOrdersForCart.json"
#define kCreateWishlistRequestPath @"createWishList.json"
#define kAddProductsToWishlistRequestPath @"addProductToWishList.json"
#define kGetAllUserWishlistsRequestPath @"getUserWishLists.json"
#define kGetAllProductsOfUserWishList @"getProductsInUserWishlist.json"
#define kDeleteProductsFromWishlist @"removeProductsFromWishList.json"
#define kDeleteAWishlist @"deleteWishList.json"
#define kRemoveSingleProductFromWishlistRequestPath @"removeSingleProductFromWishList.json" 
#define kGetAllUserAddressesRequestPath @"getUserAddresses.json"
#define kAddUserAddressesRequestPath @"addUserAddress.json"

#define kLightFontName @"HelveticaNeue-Light"
#define kRegularFontName @"HelveticaNeue"
#define kMediumFontName @"HelveticaNeue-Medium"
#define kBoldFontName @"HelveticaNeue-Bold"

#define kANLightFontName @"AvenirNext-UltraLight"
#define kANRegularFontName @"AvenirNext-Regular"
#define kANMediumFontName @"AvenirNext-Medium"
#define kANBoldFontName @"AvenirNext-DemiBold"

#define kUserLoggedInKey @"userLoggedIn"
#define kCartIdKey @"CartID"
#define kCookieKey @"cookie"
#define kLocalAddressKey @"addressModl"
#define kPinCodeKey @"pinCode"

//saving cart locally
#define kLocalCartKey @"cartModelLocal"

//saving wishlist locally
#define kLocalWishlistKey @"wishlistLocal"
#define kLocalWishlistProductIdsKey @"wishlistproductIdsLocal"


//login keys
#define kFirstNameKey @"firstName"
#define kLastNameKey @"lastName"
#define kFullNameKey @"fullName"
#define kAuthorizationTokenKey @"authorizationToken"
#define kPhoneNumberKey @"phoneNumber"
#define kContactNoKey @"contactNo"
#define kUserId @"userId"
#define kIsFbLogin @"isFb"
#define kEmailIdKey @"emailId"


#define FreeSizeID 231

// PayU

#define kPayUKey @"gtKFFx"
#define kPayUSalt @"eCwWELxi"
#define kPayUAppTitle @"evyee"

// FOR FILTERS

#define RGB(x, y, z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0]
#define RGBA(x, y, z, a) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:a]
#define GRAY(x) [UIColor colorWithWhite:x alpha:1.0]
#define GRAY_255(x) [UIColor colorWithWhite:x/255.0f alpha:1.0]
#define GRAYA(x, a) [UIColor colorWithWhite:x alpha:a]

#define LIGHT(x) [UIFont fontWithName:kLightFontName size:x]
#define REGULAR(x) [UIFont fontWithName:kRegularFontName size:x]
#define MEDIUM(x) [UIFont fontWithName:kMediumFontName size:x]
#define BOLD(x) [UIFont fontWithName:kBoldFontName size:x]

#define AN_LIGHT(x) [UIFont fontWithName:kANLightFontName size:x]
#define AN_REGULAR(x) [UIFont fontWithName:kANRegularFontName size:x]
#define AN_MEDIUM(x) [UIFont fontWithName:kANMediumFontName size:x]
#define AN_BOLD(x) [UIFont fontWithName:kANBoldFontName size:x]

#define kRedColor RGB(237.0, 28.0, 36.0)
#define kBlueColor RGB(4.0, 169.0, 244.0)
#define kDarkGrayColor GRAY(0.3)
#define kDarkBlueColor RGB(2.0, 119.0, 189.0)
#define kGreenColor RGB(139.0, 195.0, 74.0)
#define kBlueGrayColor RGB(68.0, 74.0, 77.0)
#define kButtonDisabledColor GRAY(0.7)

#define kPageControlHeight 37

#define kFilterCellHeight 48
// tab container

#define kUnderlineViewHeight 3.0
#define kOverlayViewColor [UIColor colorWithWhite:0.0 alpha:0.7]
#define kSideMenuWidth 260.0
#define kTabBarHeight 48.0
#define kTabTintColor RGB(31.0, 210.0, 115.0)

// Table View Generic

#define kTableViewSidePadding 16.0
#define kTableViewVerticalPadding 16.0
#define kTableViewInternalPadding 16.0
#define kTableViewLongListPadding 12.0

#define kButtonAlertPadding 24.0
#define kTableViewUserOTPVerificationFontSize BOLD(20.0)

#define kTableViewPGRegFontSize REGULAR(16.0)
#define kTableViewPGFontSize LIGHT(16.0)
#define kTableViewFirstFont LIGHT(15.0)
#define kTableViewSecondFont LIGHT(14.0)
#define kTableViewThirdFont LIGHT(11.0)
#define kTableViewRightFont REGULAR(15.0)
#define kNavBarTitleFont REGULAR(19.0)
#define kTableSectionHeaderFont REGULAR(14.0)

#define kTableViewCenterRightFont REGULAR(15.0)
#define kTableViewCenterLeftFont LIGHT(15.0)
#define kTableViewCenterRightLargeFont MEDIUM(15.0)
#define kTableViewCenterLeftLargeFont REGULAR(15.0)
#define kTableViewBigFont LIGHT(16.0)

#define kLoaderViewFont LIGHT(16.0)


#define kTableViewLineSpacing 4.0

#define kTableViewSelectionColor GRAY(0.92)
#define kTableViewButtonOutlineWidth 1.0

#define kTableViewSmallPadding 8.0
#define kTableViewMediumPadding 16.0
#define kTableViewLargePadding 24.0

#define kMainSeparatorColor RGB(173.0, 173.0, 173.0)

#define kMainTextFieldHeight 32.0
#define kKeyboardAccessoryHeight 44.0f
#define kPickerDefaultHeight 216.0f

#define kWishListCellHeight 48.0

// home view

#define kHomeViewCellHeight 250.0
#define kGridHeaderHeight 200.0
#define kGridCellHeight 150.0
#define kHeaderButtonHeight 44.0
#define kLabelEdgePadding 20.0

// filter view

#define kOccasionCellTag 1000
#define kOfferCellTag 2000
#define kTopTag 2500
#define kAllDesignerTag 3000

#define kFourDayString @"fourdayrentalprice"
#define kEightDayString @"eightdayrentalprice"
//#define kDeliveryDateString @"deliveryDate"
#define kPriceString @"price"
#define kColorsString @"Color"
#define kSizeString @"Size"
#define kOccasionString @"occasion"
#define kOtherFilter @"otherFilter"
#define kDesignerString @"designer"

//#define kOfferString @"OFFERS"

#define kFourDayType @"fourdayrentalprice"
#define kEightDayType @"eightdayrentalprice"
#define kAttributeType @"attribute"
#define kOccasionType @"occasion"
#define kDesignerType @"designer"


#define kTopDesignerString @"topDesigner"
#define kAllDesignerString @"allDesigner"


#define reverseAspectRatio 1.5

#define kSizeCell 52

#define RGB00 [UIColor colorWithRed:20/255.0f green:40/255.0f blue:200/255.0f alpha:1.0]

// product

#define kProductImageHeight 300.0
//Product Detail View Controller

#define kcellPadding 18.0
#define kdefaultCellPadding 12.0
#define kProductDescriptionPadding 20.0
// calendar

#define kBottomButtonColor RGB(30.0, 34.0, 48.0)
#define kTrailingPadding 20.0

// tick view

#define kTickButtonFont LIGHT(14.0)
#define kTickButtonSecondLineFont LIGHT(12.0)
#define kAcknowledgmentLightColor GRAY(0.4)
#define kAcknowledgmentDarkColor GRAY(0.1)


// loader
#define kLoaderViewTopPadding 24.0
#define kLoaderFont REGULAR(17.0)
#define kLightGrayColor GRAY(0.6)
#define kBigContentWidth 280.0
#define MACenteredOrigin(x, y) floor((x - y)/2.0)


//progressView
#define kDimOutViewColor GRAYA(0.0, 0.3)
#define kItemCornerRadius 4.0
#define kAcknowledgmentGeneralTextFont LIGHT(18.0)

//Product collection view
#define kLineColor RGB(235.0, 239.0, 241.0)
#define kGutterSpace 5.0
#define kfavButtonHeight 36.0 
//Product Detail
#define kRetailLabelColor RGB(114.0, 123.0, 143.0)
//shipping details colours

#define kBlackTextColor RGB(22.0, 37.0, 42.0)
#define kSectionBgColor RGB(246.0, 247.0, 248.0)
#define kRowLeftLabelColor RGB(90.0, 126.0, 140.0)
#define kSeparatorColor RGB(235.0,239.0,241.0)
#define kPlaceholderColor RGB(179.0,202.0,210.0)
#define kRowColorWhileTyping RGB(251, 251, 251)
#define kTextFieldTypingColor RGB(32, 194, 108)
#define kAppGreenColor RGB(31.0, 210.0, 115.0)
#define kAppLightGrayColor RGB(139.0,164.0,175.0)
#define kLightGrayBgColor RGB(242, 246, 248)

#define kBottomBarHeight 48.0
#define kRightSymbol @"❭"

//Payment View Controller
#define KSaveCardText RGB(108.0,117.0,136.0)
#define kPaymentButtonHeight 48.0
#define KSecurePaymentText RGB(132,139,153)

//Me View COntroller
#define kImageTextMargin 5.0
#define KMeSectionImageW 24.0
#define kImageTextPadding 16.0
#define kLineAndTextSpacing 8.0
#define kFooterColor RGB(245.0,245.0,249.0)
#define kProfileAspectRatio 0.4

//Add to cart and bag view
#define spaceBetweenLines 3.0
#define topPaddingInCell 16.0
#define cellProductImageW 64.0
#define cellProductImageH 96.0

#define sortButtonGreenColor RGB(32.0,194.0,108.0)
//Static screen FAQ
#define KFAQTopPadding 26.0
#define kAnswerTextColor RGB(70.0,103.0,115.0)

//Cart Notification
#define kCartUpdatedNotification @"kCartUpdatedNotification"

//wishlist notification
#define kWishListUpdateNotification @"kWishListUpdateNotification"

//calender
# define kDateBackground RGB(247.0,249.0,250.0)


// payment
#define kPaymentFailureString @"failure://eyvee.com?error="
#define kFailureUrl @"http://52.88.31.116/webservices/convertCartToOrderPayu.json?res=300"
#define kSuccessUrl @"http://52.88.31.116/webservices/convertCartToOrderPayu.json?res=200"


// cache clearing
#define kCacheClearedTime @"cachedClearedTimestamp"

//JSON Files
#define kBannersFilePath @"banner"
#define kSlidersFilePath @"sliders"
#define kSiteInfoFilePath @"siteInfo"


#endif
