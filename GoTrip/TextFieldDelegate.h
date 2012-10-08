//
//  TextFieldDelegate.h
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailTextFieldDelegate : NSObject <UITextFieldDelegate>

@end

@interface PhoneTextFieldDelgate : NSObject <UITextFieldDelegate>

@end

@interface NumberTextFieldDelgate : NSObject <UITextFieldDelegate>

@end

@interface IntegerTextFieldDelegate : NSObject <UITextFieldDelegate>

@end

@interface MoneyTextFieldDelegate : NSObject <UITextFieldDelegate>
@end

@interface TextFieldDelgates : NSObject

+ (EmailTextFieldDelegate *)emailTextFieldDelgate;

+ (PhoneTextFieldDelgate *)phoneTextFieldDelegate;

+ (MoneyTextFieldDelegate *)moneyTextFieldDelegate;

@end
