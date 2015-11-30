//
//  WishListViewController.h
//  Eyvee
//
//  Created by Varun Kapoor on 20/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYGetAllProductsMTLModel.h"
#import "EYUserWishlistMtlModel.h"
#import "CheckBoxTableViewCell.h"

@class EYAllWishlistMtlModel;
@class EYProductsInfo;
@protocol WishListTableViewCellDelegate <NSObject>
@optional
-(void) wishlistChanged;
-(void) keyBoardShown:(float) keyBoardHeight;
-(void) keyBoardHide:(float) keyBoardHeight;

@end


typedef enum wishlistModes
{
    enum_ViewWithoutTextField,
    enum_ViewWithTextField

} wishlistMode_Type;

typedef enum buttonModes
{
    enum_createWishlist,
    enum_saveWishlist
    
} buttonModes_Type;

@interface WishListViewController : UIViewController <UITextFieldDelegate>
@property (weak,nonatomic)id <WishListTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIButton * createNewWishListBtn;
@property (nonatomic, strong) EYProductsInfo * product;
@property (nonatomic) int wishlistMode;
@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) UIButton * createNewWishListBtn;
//@property(nonatomic ,strong) UITextField *textField;
@property(nonatomic ,strong) UITextField *wishlistTextField;
//@property (nonatomic, strong) NSArray *wishlistModelArray;
@property (nonatomic, strong) EYAllWishlistMtlModel * wishlistModel;
@end
