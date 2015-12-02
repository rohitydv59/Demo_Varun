//
//  EYPromoCodeViewController.m
//  Eyvee
//
//  Created by Disha Jain on 07/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYPromoCodeViewController.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYBottomButton.h"
#import "EYAllAPICallsManager.h"
#import "EYError.h"
#import "EYTextFieldCell.h"
#import "EYUserInfo.h"
#import "EYAccountManager.h"

#import "PVToast.h"

@interface EYPromoCodeViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITextField *promoCodeField;
@property (strong,nonatomic) EYBottomButton *bottomView;
@property (strong,nonatomic) NSString *promoCodeEntered;
@property (nonatomic, strong) UITableView * tableView;
//FooterView
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)UILabel *footerLabel;

@end

@implementation EYPromoCodeViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        self.title = @"Offer";
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kSectionBgColor;
    [self.view addSubview:_tableView];
    //Table Footer View
    _footerView = [[UIView alloc]initWithFrame:CGRectZero];
    _footerView.backgroundColor = kSectionBgColor;
    
    _footerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _footerLabel.numberOfLines = 0;
    _footerLabel.textColor = kAppLightGrayColor;
    _footerLabel.attributedText = [EYPromoCodeViewController getAttrStr:@"You can apply multiple coupons upto 40% total discount value. This help text is optional."];
    
    [_footerView addSubview:_footerLabel];

    _bottomView = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"next_btn_large" ButtonText:@"APPLY CODE" andFont:AN_BOLD(13.0)];
    [self.view addSubview:_bottomView];
    
    [_bottomView addTarget:self action:@selector(applyCode:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    _tableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height - _bottomView.frame.size.height);
     _bottomView.frame = (CGRect){0,rect.size.height - kBottomBarHeight,rect.size.width,kBottomBarHeight};
    
    CGFloat availableWForFooterLabel = rect.size.width - kProductDescriptionPadding*2;
    CGSize sizeOfFooterLabel = [EYUtility sizeForAttributedString:_footerLabel.attributedText width:availableWForFooterLabel];
    _footerView.frame = (CGRect){0,0,rect.size.width,sizeOfFooterLabel.height + kProductDescriptionPadding};
    _tableView.tableFooterView = _footerView;
    _footerLabel.frame = (CGRect){kProductDescriptionPadding,(_footerView.frame.size.height - sizeOfFooterLabel.height)/2,sizeOfFooterLabel};
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = kSectionBgColor;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectZero];
    lbl.font = AN_BOLD(12.0);
    [view addSubview:lbl];
    
    view.frame = CGRectMake(0, 0, self.view.frame.size.width-kProductDescriptionPadding, 44.0);
    lbl.text = @"TYPE YOUR CODE";
    lbl.textColor = kBlackTextColor;
    CGSize lblSize = lbl.intrinsicContentSize;
    lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height)/2,lblSize};
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
    if (!cell)
    {
        cell = [[EYTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
        
    }
    cell.textfield.delegate = self;
    [cell updateTextFieldMode:addPromoCode];
    [cell setLabelText:@"" andPlaceholderText:@"Required"];

    return cell;
}

-(void)applyCode:(id)sender
{
    [[PVToast shared]showToastMessage:@"Disabled For Demo Version"];

//    if (self.promoCodeEntered.length>0)
//    {
//        //update Cart Api
//         NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
//        NSString * userId = userIdStr ? userIdStr : @"-1";
//        NSString * cartId = [[EYUtility shared] getCartId]?[[EYUtility shared] getCartId]:@"-1";
//        
//         NSDictionary * payload = @{@"userId":userId,@"cartId":cartId};
//        [EYUtility showHUDWithTitle:@"Please wait"];
//        NSDictionary *params = @{@"eventId" : @(1),@"promoCode" : self.promoCodeEntered};
//        [[EYAllAPICallsManager sharedManager] syncCartRequestWithParameters:params withRequestPath:kSyncCartRequestPath cache:NO payload:payload withCompletionBlock:^(id responseObject, EYError *error)
//         {
//             [EYUtility hideHUD];
//            if (error)
//            {
//                [EYUtility showAlertView:error.errorMessage];
//            }
//            else
//            {
//                _cartModelReceived = (EYSyncCartMtlModel *)responseObject;
//                if ([_delegate respondsToSelector:@selector(promoCodeAppliedAndFinalCartObject:)])
//                {
//                    [_delegate promoCodeAppliedAndFinalCartObject:_cartModelReceived];
//            }
//                [self.view endEditing:YES];
//                [self.navigationController popViewControllerAnimated:YES];
//              
//            }
//        }];
//
//        
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Please Enter some code" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//    }
}

#pragma mark Text Field Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.promoCodeEntered = text;
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor = kTextFieldTypingColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = kRowColorWhileTyping;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.font = AN_REGULAR(15.0);
    textField.textColor =kBlackTextColor;
    EYTextFieldCell *cell = (EYTextFieldCell*)textField.superview;
    cell.backgroundColor = [UIColor whiteColor];
}

+ (NSAttributedString *)getAttrStr:(NSString *)mainText
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.paragraphSpacingBefore = 1.0;
    
    if (mainText.length > 0) {
        attr = [[NSAttributedString alloc] initWithString:mainText attributes:@{
                                                                                NSFontAttributeName: AN_REGULAR(12.0),
                                                                                NSForegroundColorAttributeName : kAppLightGrayColor,
                                                                                NSParagraphStyleAttributeName : style
                                                                                }];
        [mutAttr appendAttributedString:attr];
    }
    
    
    return mutAttr;
}

@end
