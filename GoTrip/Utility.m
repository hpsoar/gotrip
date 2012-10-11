//
//  Utility.m
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+ (void)logError:(NSError *)error {
    NSLog(@"Error: %@, %@ atFile:%s atLine:%d", error, error.userInfo, __FILE__, __LINE__);
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

static PhoneNumberFormatter *g_phoneNumberFormatter;

+ (PhoneNumberFormatter *)phoneNumberFormatter {
    if (!g_phoneNumberFormatter) {
        g_phoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    }
    return g_phoneNumberFormatter;
}

+ (BOOL)validatePhoneNumberWithString:(NSString*)phone {
    NSString *phoneRegex = @"^+(?:[0-9] ?){6,14}[0-9]$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];

    return [phoneTest evaluateWithObject:phone];
}

+ (NSDate *)fullDateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:dateString];
}

static NSNumberFormatter *g_currencyFormatter;

+ (NSNumberFormatter *)currencyFormatter {
    if (g_currencyFormatter == nil) {
        g_currencyFormatter = [[NSNumberFormatter alloc] init];
        g_currencyFormatter.currencySymbol = @"￥";
        g_currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    return g_currencyFormatter;
}

+ (NSString *)numberToCurrencyText:(NSNumber *)number {
    if (number == nil) return [NSString stringWithFormat:@"%@0.00", [Utility currencyFormatter].currencySymbol];
    return [[Utility currencyFormatter] stringFromNumber:number];
}

+ (NSString *)numberToText:(NSNumber *)number {
    if (number == nil || number.floatValue == 0) return @"";
    return [NSString stringWithFormat:@"%@", number];
}

+ (BOOL)textContainsCurrencySymbol:(NSString *)text {
    return  [text rangeOfString:[Utility currencyFormatter].currencySymbol].location == 0;
}

+ (NSNumber *)currencyTextToNumber:(NSString *)text {
    if ([Utility textContainsCurrencySymbol:text])
        return [[Utility currencyFormatter] numberFromString:text];
    else return [NSNumber numberWithFloat:text.floatValue];
}

+ (NSString *)numberTextToCurrencyText:(NSString *)text {
    return [Utility numberToCurrencyText:[Utility currencyTextToNumber:text]];
}

+ (NSString *)currencyTextToNumberText:(NSString *)text {
    return [Utility numberToText: [Utility currencyTextToNumber:text]];
}

@end
