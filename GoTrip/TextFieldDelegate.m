//
//  TextFieldDelegate.m
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "TextFieldDelegate.h"
#import "Utility.h"

@implementation EmailTextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [Utility validateEmailWithString:textField.text];
}

@end

@implementation NumberTextFieldDelgate

@end

@implementation IntegerTextFieldDelegate



@end

@implementation PhoneTextFieldDelgate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [Utility validatePhoneNumberWithString:textField.text];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    textField.text = [Utility phoneNumberFormatter] format:textField withLocale:
//    return YES;
//}

@end

@implementation MoneyTextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.text.length > 0)
        textField.text = [textField.text substringFromIndex:1];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.text = [NSString stringWithFormat:@"￥%@", textField.text];
    return YES;
}

@end

@interface TextFieldDelgates()

@end

static EmailTextFieldDelegate *g_emailTextFieldDelegate;

static PhoneTextFieldDelgate *g_phoneTextFieldDelgate;

static MoneyTextFieldDelegate *g_moneyTextFieldDelgate;

@implementation TextFieldDelgates

+(EmailTextFieldDelegate *)emailTextFieldDelgate {
    if (!g_emailTextFieldDelegate) {
        g_emailTextFieldDelegate = [[EmailTextFieldDelegate alloc] init];
    }
    return g_emailTextFieldDelegate;
}

+(PhoneTextFieldDelgate *)phoneTextFieldDelegate {
    if (!g_phoneTextFieldDelgate)
        g_phoneTextFieldDelgate = [[PhoneTextFieldDelgate alloc] init];
    return g_phoneTextFieldDelgate;
}

+(MoneyTextFieldDelegate *)moneyTextFieldDelegate {
    if (!g_moneyTextFieldDelgate)
        g_moneyTextFieldDelgate = [[MoneyTextFieldDelegate alloc] init];
    return g_moneyTextFieldDelgate;
}

@end
