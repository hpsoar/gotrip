//
//  Utility.h
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Datetime+FormattedString.h"
#import "PhoneNumberFormatter.h"

@interface Utility : NSObject
+ (void)logError:(NSError *)error;

+ (BOOL)validateEmailWithString:(NSString*)email;

+ (BOOL)validatePhoneNumberWithString:(NSString*)phone;

+ (PhoneNumberFormatter *)phoneNumberFormatter;

+ (NSDate *)fullDateFromString:(NSString *)dateString;

//+ (NSNumberFormatter *)currencyFormatter;

+ (NSString *)numberToCurrencyText:(NSNumber *)number;
+ (NSString *)numberToText:(NSNumber *)number;
+ (NSNumber *)currencyTextToNumber:(NSString *)text;
+ (NSString *)numberTextToCurrencyText:(NSString *)text;
+ (NSString *)currencyTextToNumberText:(NSString *)text;

@end
