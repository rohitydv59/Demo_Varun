//
//  NSString+isNumeric.m
//  WynkPay
//
//  Created by Neetika Mittal on 09/02/15.
//  Copyright (c) 2015 BSB. All rights reserved.
//

#import "NSString+validation.h"
#import "EYUtility.h"

@implementation NSString (validation)

- (BOOL)isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

- (BOOL)isAllDigitsWithHypens
{
    NSMutableCharacterSet *numbers = [NSMutableCharacterSet decimalDigitCharacterSet];
    [numbers formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    return [numbers isSupersetOfSet:myStringSet];
}

- (BOOL)isNumeric
{
    NSScanner *sc = [NSScanner scannerWithString: self];
    if ( [sc scanInteger:NULL] )
    {
        return [sc isAtEnd];
    }
    return NO;
}

- (BOOL)isAlphaNumericCharacterSet
{
    NSMutableCharacterSet *alphanumericCharacterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [alphanumericCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:self];

    return [alphanumericCharacterSet isSupersetOfSet:myStringSet];
}

#pragma mark - Registration validations

- (BOOL)isValidEmail
{
    NSRange positionOfAtSymbol = [self rangeOfString:@"@"];
    
    if (positionOfAtSymbol.location == NSNotFound) {
        return NO;
    }
    
    NSString *domainString = [self substringFromIndex:(positionOfAtSymbol.location + positionOfAtSymbol.length)];
    
    if ([domainString rangeOfString:@"."].location == NSNotFound || [domainString rangeOfString:@".."].location != NSNotFound || [domainString rangeOfString:@"@"].location != NSNotFound) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidName
{
    BOOL isValid = YES;
    
    NSCharacterSet *acceptableSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.- "];
 
    acceptableSet = [acceptableSet invertedSet];
    
    NSRange range = [self rangeOfCharacterFromSet:acceptableSet];
    
    if (range.location != NSNotFound)
        isValid = NO;
    
    return isValid;
}

- (NSInteger)numberOfOccuranceOf:(NSString *)string
{
    NSUInteger numberOfOccurrences = [[self componentsSeparatedByString:string] count] - 1;
    
    return numberOfOccurrences;
}

- (NSMutableArray *)toCharArray
{
    
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
    for (int i=0; i < [self length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
        [characters addObject:ichar];
    }
    
    return characters;
}

- (BOOL)isValidCardNumber
{
    NSMutableArray *stringAsChars = [self toCharArray];
    
    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;
    
    for (int i = (int)[self length] - 1; i >= 0; i--) {
        
        int digit = [(NSString *)[stringAsChars objectAtIndex:i] intValue];
        
        if (isOdd)
            oddSum += digit;
        else
            evenSum += digit/5 + (2*digit) % 10;
        
        isOdd = !isOdd;
    }
    
    return ((oddSum + evenSum) % 10 == 0);
}

- (BOOL)isValidRegisterationCharacters:(BOOL)withSpace
{
    BOOL isValid = YES;
    
    NSCharacterSet *acceptableSet;
    
    if (withSpace) {
        acceptableSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];
    }
    else
        acceptableSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
    acceptableSet = [acceptableSet invertedSet];
    
    NSRange range = [self rangeOfCharacterFromSet:acceptableSet];
    
    if (range.location != NSNotFound)
        isValid = NO;
    
    return isValid;
}

- (BOOL)isValidAlphaNumericCharacters
{
    BOOL isValid = YES;
    
    NSCharacterSet *acceptableSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
    
    acceptableSet = [acceptableSet invertedSet];
    
    NSRange range = [self rangeOfCharacterFromSet:acceptableSet];
    
    if (range.location != NSNotFound)
        isValid = NO;
    
    return isValid;
}

- (BOOL)isValidWithoutSpaces
{
    BOOL isValid = NO;
    NSString *textWithoutSpace = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([textWithoutSpace isEqualToString:self]) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidBankName
{
    BOOL isValid = YES;
    
    NSCharacterSet *acceptableSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.'- "];
    
    acceptableSet = [acceptableSet invertedSet];
    
    NSRange range = [self rangeOfCharacterFromSet:acceptableSet];
    
    if (range.location != NSNotFound)
        isValid = NO;
    
    return isValid;
}


- (NSString *)trimmedFirstAndLastSpace
{
    NSString *trimmedText = [self stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    return trimmedText;
}

@end
