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

@end
