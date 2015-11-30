//
//  WishListViewController.m
//  Eyvee
//
//  Created by Varun Kapoor on 20/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//
#import "WishListViewController.h"
#import "CheckBoxTableViewCell.h"
#import "EYConstant.h"
#import "EYAllAPICallsManager.h"
#import "EYWishlistModel.h"
#import "EYGetAllProductsMTLModel.h"
#import "EYError.h"

@interface WishListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    int buttonMode;
    int selectedWishListCount;
}

@property(nonatomic ,strong) NSMutableArray *selectedWishlistCellArray;
@property(nonatomic ,strong) NSMutableArray *wishlistRowsArray;
@property(nonatomic , strong) UIView * containerView;
@property(nonatomic , strong) UIView * textFieldView;

@end

@implementation WishListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    selectedWishListCount = 0;
    
    _selectedWishlistCellArray = [[NSMutableArray alloc] init];
    _wishlistRowsArray = [[NSMutableArray alloc] init];
    
    _wishlistMode = enum_ViewWithoutTextField;
    buttonMode = enum_createWishlist;
    
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_containerView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_containerView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_containerView addSubview:_tableView];

    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    
    _textFieldView = [[UIView alloc] initWithFrame:CGRectZero];
    [_textFieldView setBackgroundColor:[UIColor grayColor]];
    [_containerView addSubview:_textFieldView];
    
    _wishlistTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _wishlistTextField.adjustsFontSizeToFitWidth = YES;
    _wishlistTextField.textColor = [UIColor blackColor];
    [_wishlistTextField setDelegate:self];
    _wishlistTextField.placeholder = @"Title for new list";
    _wishlistTextField.keyboardType = UIKeyboardTypeDefault;
    _wishlistTextField.returnKeyType = UIReturnKeyGo;
    _wishlistTextField.autocorrectionType = UITextAutocorrectionTypeNo;         // no auto correction support
    [_textFieldView addSubview:_wishlistTextField];
    
    _createNewWishListBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_createNewWishListBtn setBackgroundColor:[UIColor blackColor]];
    _createNewWishListBtn.tintColor = [UIColor whiteColor];
    [_createNewWishListBtn setTitle:@"CREATE A NEW LIST +" forState:UIControlStateNormal];
    [_createNewWishListBtn addTarget:self action:@selector(createNewlistClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createNewWishListBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self getWishlistsForProduct];
}

- (UIView *)loader
{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"PVLoaderView" owner:self options:nil];
    UIView *loaderView = [nibObjects objectAtIndex:0];
    return loaderView;
}

- (void)getWishlistsForProduct
{
    [_tableView setTableHeaderView:[self loader]];
    _wishlistModel = nil;
    [_tableView reloadData];
    
    [[EYAllAPICallsManager sharedManager] getWishlistsForProductRequestWithParameters:@{@"productId":_product.productId} withRequestPath:@"getWishListsForProduct.json" cache:nil withCompletionBlock:^(id responseObject, EYError *error)
    {
        if (!error)
        {
            _wishlistModel = (EYAllWishlistMtlModel *)responseObject;
            if (_wishlistModel.allWishlists.count > 0)
            {
                [_tableView setTableHeaderView:nil];
                [self setCheckedWishlistCount];
                [_tableView reloadData];
            }
            else
            {
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"dd/MM/YYYY"];
                NSString *date_String=[dateformate stringFromDate:[NSDate date]];
                
                [[EYAllAPICallsManager sharedManager]createWishlistRequestWithParameters:@{@"wishlistName" : @"My FirstWishlist", @"eventDate" : date_String} withRequestPath:kCreateWishlistRequestPath withCompletionBlock:^(id responseObject, EYError *error) {

                    [_tableView setTableHeaderView:nil];
                    if (responseObject && !error)
                    {
                        _wishlistModel = (EYAllWishlistMtlModel *)responseObject;
                        [[EYWishlistModel sharedManager] updateWishListModelWithCompletionBlock:^(id responseObject, EYError *error) {
                            NSLog(@"firat wishlisttt %@",responseObject);
                            if (!error && responseObject)
                            {
                                _wishlistModel = (EYAllWishlistMtlModel *)responseObject;
                                [self.tableView reloadData];

                            }
                        }];
                        [self setCheckedWishlistCount];
                        [self.tableView reloadData];
                    }
                    else
                    {
                        [EYUtility showAlertView:error.errorMessage];
                    }
                }];

            }
        }
        else
        {
            [_tableView setTableHeaderView:nil];
            [EYUtility showAlertView:error.errorMessage];


        }
    }];
}


- (void)setCheckedWishlistCount
{
    for (EYUserWishlistMtlModel * wishlist in _wishlistModel.allWishlists) {
        if ([wishlist.userId isEqualToNumber:_product.productId]) {
            selectedWishListCount ++;
        }
    }
    NSLog(@"count - %d",selectedWishListCount);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    cellIdentifier = @"CheckBoxTableViewCellIdentifier";
    EYUserWishlistMtlModel * currentWishlist = [_wishlistModel.allWishlists objectAtIndex:indexPath.row];
    CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckBoxTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setTag:100 + indexPath.row];
    [cell.label setText:currentWishlist.wishlistName];

    if ([currentWishlist.userId isEqualToNumber:_product.productId])
    {
        [cell.checkBoxButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [cell.checkBoxButton setSelected:YES];
    }
    else
    {
        [cell.checkBoxButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [cell.checkBoxButton setSelected:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    EYUserWishlistMtlModel * currentWishlist = [_wishlistModel.allWishlists objectAtIndex:indexPath.row];
    if (cell.checkBoxButton.isSelected)
    {
        [self deleteFromWishlist:currentWishlist];
    }
    else
    {
        [self addIntoWishlist:currentWishlist];
    }
    
  
}

- (void)addIntoWishlist:(EYUserWishlistMtlModel *)wishList
{
    [EYUtility showHUDWithTitle:@"Adding"];
    
    [[EYAllAPICallsManager sharedManager] addProductToWishlistRequestWithParameters:@{@"productId" : self.product.productId, @"wishListId" : wishList.userWishlistId } withRequestPath:kAddProductsToWishlistRequestPath cache:NO withCompletionBlock:^(id responseObject,EYError *error) {
            [EYUtility hideHUD];
            if (!error)
            {
                wishList.userId = _product.productId;
                selectedWishListCount ++;
                [self addProductIntoProductIds];
                [_tableView reloadData];
                if (_delegate && [_delegate respondsToSelector:@selector(wishlistChanged)]) {
                    [_delegate wishlistChanged];
                }
            }
            else
            {
                [EYUtility showAlertView:error.errorMessage];
            }
        }];

}

- (void)deleteFromWishlist:(EYUserWishlistMtlModel *)wishList
{
    [EYUtility showHUDWithTitle:@"Deleting"];
    
    [[EYAllAPICallsManager sharedManager] deleteProductsFromWishlistWithParameters:@{@"productIds":_product.productId,@"wishListId":wishList.userWishlistId} withRequestPath:kDeleteProductsFromWishlist cache:nil withCompletionBlock:^(BOOL responseSuccess, EYError *error)
     {
        [EYUtility hideHUD];
        if (!error)
        {
            wishList.userId = [NSNumber numberWithInt:0];
            selectedWishListCount --;
            [self deleteProductFromProductIds];
            [_tableView reloadData];

            if (_delegate && [_delegate respondsToSelector:@selector(wishlistChanged)]) {
                [_delegate wishlistChanged];
            }
        }
         
        else
        {
            [EYUtility showAlertView:error.errorMessage];
        }
    }];
    
}

- (void)addProductIntoProductIds
{
    EYWishlistModel * manager = [EYWishlistModel sharedManager];
    NSMutableArray * productIds = [[NSMutableArray alloc] initWithArray:manager.productIdsArray];
    if (![productIds containsObject:_product.productId]) {
        [productIds addObject:_product.productId];
    }
    manager.productIdsArray = [[NSArray alloc] initWithArray:productIds];
}

- (void)deleteProductFromProductIds
{
    if (selectedWishListCount != 0) {
        return;
    }
    EYWishlistModel * manager = [EYWishlistModel sharedManager];
    NSMutableArray * productIds = [[NSMutableArray alloc] initWithArray:manager.productIdsArray];
    if ([productIds containsObject:_product.productId]) {
        [productIds removeObject:_product.productId];
    }
    manager.productIdsArray = [[NSArray alloc] initWithArray:productIds];
}

-(void) createNewlistClicked:(id) sender
{
    if (buttonMode == enum_createWishlist)
    {
        [_wishlistTextField setText:@""];
        [_wishlistTextField becomeFirstResponder];
        [_createNewWishListBtn setTitle:@"SAVE NEW LIST" forState:UIControlStateNormal];

        buttonMode = enum_saveWishlist;
        _wishlistMode = enum_ViewWithTextField;
        [self.tableView reloadData];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    else                                                    // save wishlist
    {
        [self savingWishList];
    }
    
}

-(void) savingWishList
{
    NSLog(@"_wishlistTextField.text.length %lu",(unsigned long)_wishlistTextField.text.length);
    if (_wishlistTextField.text.length > 0)
    {
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"dd/MM/YYYY"];
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        [EYUtility showHUDWithTitle:@"Loading..."];
        
        [[EYAllAPICallsManager sharedManager]createWishlistRequestWithParameters:@{@"wishlistName" : _wishlistTextField.text , @"eventDate" : date_String} withRequestPath:kCreateWishlistRequestPath withCompletionBlock:^(id responseObject, EYError *error) {
            [EYUtility hideHUD];
            NSLog(@"resp %@",responseObject);               // getting all
            if (responseObject && !error)
            {
//                _wishlistModel = (EYAllWishlistMtlModel *)responseObject;
                NSLog(@"textFieldShouldReturn savingWishList");

                [_wishlistTextField resignFirstResponder];
                [_createNewWishListBtn setTitle:@"CREATE A NEW LIST +" forState:UIControlStateNormal];
                buttonMode = enum_createWishlist;
                _wishlistMode = enum_ViewWithoutTextField;

                [EYUtility showAlertView:@"Wishlist Created"];
                [[EYWishlistModel sharedManager] updateWishListModelWithCompletionBlock:^(id responseObject, EYError *error)
                {
                    NSLog(@"savedd wishlisttt %@",responseObject);
                    if (!error && responseObject)
                    {
                        _wishlistModel = (EYAllWishlistMtlModel *)responseObject;
                        [self.tableView reloadData];

                    }
                }];
                [self.tableView reloadData];
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }
            else
            {
                [EYUtility showAlertView:@"Wishlist Not Created"];
            }
        }];
    }
    else
    {
        [EYUtility showAlertView:@"textfield name canot be empty"];
    }

}

- (void)keyboardWillShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [_delegate keyBoardShown:keyboardSize.height];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (_wishlistMode == enum_ViewWithoutTextField)
    {
        [_containerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [_tableView setFrame:CGRectMake(0, 0 , _containerView.frame.size.width, _containerView.frame.size.height - kWishListCellHeight)];

        if (_textFieldView)
        {
            [_textFieldView setFrame:CGRectMake(0, _containerView.frame.size.height - kWishListCellHeight, _containerView.frame.size.width, kWishListCellHeight)];
        }
        if (_wishlistTextField)
        {
            [_wishlistTextField setFrame:CGRectMake(0, 0, _textFieldView.frame.size.width, _textFieldView.frame.size.height)];
        }

        [_createNewWishListBtn setFrame:CGRectMake(0, self.view.frame.size.height - kTabBarHeight, self.view.frame.size.width, kTabBarHeight)];
    }
    else
    {
        [_containerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _containerView.backgroundColor = [UIColor redColor];
        [_tableView setFrame:CGRectMake(0, 0 , _containerView.frame.size.width, _containerView.frame.size.height - 2*kWishListCellHeight)];
        
        if (_textFieldView)
        {
            [_textFieldView setFrame:CGRectMake(0, _containerView.frame.size.height - 2*kWishListCellHeight, _containerView.frame.size.width, kWishListCellHeight)];
        }
        if (_wishlistTextField)
        {
            [_wishlistTextField setFrame:CGRectMake(0, 0, _textFieldView.frame.size.width, _textFieldView.frame.size.height)];
        }
        
        [_createNewWishListBtn setFrame:CGRectMake(0, self.view.frame.size.height - kTabBarHeight, self.view.frame.size.width, kTabBarHeight)];
    }

}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSLog(@"textFieldShouldReturn keyboardWillHide");
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [_wishlistTextField resignFirstResponder];
    
    [_delegate keyBoardHide:keyboardSize.height];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn ");
    [_wishlistTextField resignFirstResponder];
    [self savingWishList];
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _wishlistModel.allWishlists.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWishListCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .001;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"textFieldShouldReturn viewDidDisappear");

    [_wishlistTextField resignFirstResponder];
}
/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
