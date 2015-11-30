//
//  NSString+isNumeric.h
//  WynkPay
//
//  Created by Neetika Mittal on 09/02/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (validation)

- (BOOL)isAllDigits;
- (BOOL)isAllDigitsWithHypens;
- (BOOL)isNumeric;
- (BOOL)isAlphaNumericCharacterSet;
- (BOOL)isValidCardNumber;

// Registration validations //

- (BOOL)isValidEmail;
- (BOOL)isValidName;
- (NSInteger)numberOfOccuranceOf:(NSString *)string;

//Registeration Validations

- (BOOL)isValidRegisterationCharacters:(BOOL)withSpace;
- (BOOL)isValidAlphaNumericCharacters;
- (BOOL)isValidWithoutSpaces;
- (BOOL)isValidBankName;
- (NSString *)trimmedFirstAndLastSpace;

@end
