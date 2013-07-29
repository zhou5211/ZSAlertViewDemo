//
//  ZSAlertView.h
//  ZSAlertViewDemo
//
//  Created by 1010@comp on 13-7-20.
//  Copyright (c) 2013年 ZRX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSTextField.h"

typedef NS_ENUM(NSInteger, ZSAlertViewStyle)
{
    ZSAlertViewStyleDefault = 0,
    ZSAlertViewStylePlainTextInput,
    ZSAlertViewStyleLoginAndPasswordInput,
};

typedef NS_ENUM(NSInteger, ZSAlertViewShowStyle)
{
    ZSAlertViewShowStyleDefault = 0,
    ZSAlertViewShowStyleFlyIn,
};

@protocol ZSAlertViewDelegate;

@interface ZSAlertView : UIView

@property (nonatomic, assign) id<ZSAlertViewDelegate> delegate;
@property (nonatomic, assign) ZSAlertViewStyle alertViewStyle;
@property (nonatomic, assign) ZSAlertViewShowStyle alertViewShowStyle;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSMutableArray *textFieldArray;
@property (nonatomic, copy) NSMutableArray *buttonArray;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)addButtonWithTitle:(NSString *)title;

- (void)setTextFieldsCount:(NSInteger)count;

- (void)show;

- (void)dismiss;

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

@end

@protocol ZSAlertViewDelegate <NSObject>

@optional

- (void)alertView:(ZSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)alertViewCancel:(ZSAlertView *)alertView;

@end
