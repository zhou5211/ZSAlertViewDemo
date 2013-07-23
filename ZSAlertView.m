//
//  ZSAlertView.m
//  ZSAlertViewDemo
//
//  Created by 1010@comp on 13-7-20.
//  Copyright (c) 2013年 ZRX. All rights reserved.
//

#import "ZSAlertView.h"

#define applicationFrameWidth [[UIScreen mainScreen] applicationFrame].size.width
#define applicationFrameHeight [[UIScreen mainScreen] applicationFrame].size.height
#define MAX_VIEW_HEIGHT (applicationFrameHeight * 0.9)
#define MIN_VIEW_HEIGHT (TOP_INSETS + BOTTOM_INSETS + BUTTON_HEIGHT)

const static int DIALOGVIEW_WIDTH = 280;

const static int VIEW_INTERVAL_V = 5;
const static int VIEW_INTERVAL_H = 10;
const static int TITLE_HEIGHT = 30;
const static int TEXTFIELD_HEIGHT = 40;
const static int BUTTON_HEIGHT = 40;

const static int TOP_INSETS = 10;
const static int BOTTOM_INSETS = 5;
const static int EDGE_INSETS = 5;

@interface ZSAlertView ()
{
    CGFloat dialog_x;
    CGFloat dialog_y;
    CGFloat dialog_height;
    CGFloat view_width;
    CGFloat message_height;
    CGFloat button_width;
    
    UIImageView *_dialogView;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
}

@end

@implementation ZSAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _buttonArray = [[NSMutableArray alloc] init];
        _textFieldArray = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        
        view_width = DIALOGVIEW_WIDTH - 2 * EDGE_INSETS;
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:UITextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setTextAlignment:UITextAlignmentCenter];
        [_messageLabel setTextColor:[UIColor whiteColor]];
        [_messageLabel setFont:[UIFont systemFontOfSize:20]];
        [_messageLabel setBackgroundColor:[UIColor clearColor]];
        [_messageLabel setNumberOfLines:0];
        [_messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"alertview_background.png"];
        UIEdgeInsets imgInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        backgroundImage = [backgroundImage resizableImageWithCapInsets:imgInsets];
        _dialogView = [[UIImageView alloc] initWithImage:backgroundImage];
        
        [_dialogView setUserInteractionEnabled:YES];
        
        [_dialogView addSubview:_titleLabel];
        [_dialogView addSubview:_messageLabel];
        [self addSubview:_dialogView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [self initWithFrame:CGRectMake(0, 0, applicationFrameWidth, applicationFrameHeight)];
    if (self) {
        _title = title;
        _message = message;
        
        [self setDelegate:delegate];
        [self setAlertViewStyle:ZSAlertViewStyleDefault];
        [self setAlertViewShowStyle:ZSAlertViewShowStyleDefault];
        
        UIEdgeInsets imageInsets = UIEdgeInsetsMake(25, 25, 25, 25);
        
        if (cancelButtonTitle) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[[UIImage imageNamed:@"cancel_button01.png"] resizableImageWithCapInsets:imageInsets]
                              forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"cancel_button02.png"] resizableImageWithCapInsets:imageInsets]
                              forState:UIControlStateHighlighted];
            [button setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [button setTag:0];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonArray addObject:button];
            [_dialogView addSubview:button];
        }
        
        va_list list;
        va_start(list, otherButtonTitles);
        
        NSString *otherButtonTitle = otherButtonTitles;
        int tag = 1;
        while (otherButtonTitle) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[[UIImage imageNamed:@"normal_button01.png"] resizableImageWithCapInsets:imageInsets]
                              forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"normal_button02.png"] resizableImageWithCapInsets:imageInsets]
                              forState:UIControlStateHighlighted];
            [button setTitle:otherButtonTitle forState:UIControlStateNormal];
            [button setTag:tag++];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonArray addObject:button];
            [_dialogView addSubview:button];
            
            otherButtonTitle = va_arg(list, NSString *);
        }
        
        va_end(list);
    }
    return self;
}

-(void) buttonClicked:(id)sender
{
    UIButton *button = (UIButton *) sender;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self.delegate alertView:self clickedButtonAtIndex:button.tag];
        }
    }
    
    [self dismiss];

}

- (void)getDialogHeight
{
    dialog_height = MIN_VIEW_HEIGHT;
    
    if (_title) {
        dialog_height += TITLE_HEIGHT;
    }
    if (_message) {
        CGSize size = CGSizeMake(view_width, MAX_VIEW_HEIGHT - MIN_VIEW_HEIGHT);
        CGSize labelSize = [_message sizeWithFont:[_messageLabel font]
                                constrainedToSize:size
                                    lineBreakMode:NSLineBreakByWordWrapping];
        message_height = labelSize.height;
        dialog_height += message_height + VIEW_INTERVAL_V;
    }
    if (_alertViewStyle == ZSAlertViewStylePlainTextInput) {
        for (UITextField *textField in _textFieldArray) {
            dialog_height += TEXTFIELD_HEIGHT + VIEW_INTERVAL_V;
        }
    }
    if (_alertViewStyle == ZSAlertViewStyleLoginAndPasswordInput) {
        dialog_height += 2 * (TEXTFIELD_HEIGHT + VIEW_INTERVAL_V);
    }
    if ([_buttonArray count] > 2) {
        for (int i = 1; i < [_buttonArray count]; i ++) {
            dialog_height += BUTTON_HEIGHT + VIEW_INTERVAL_V;
        }
        dialog_height += VIEW_INTERVAL_V;
    }
    
    dialog_x = (applicationFrameWidth - DIALOGVIEW_WIDTH) / 2;
    if (_alertViewStyle == ZSAlertViewStyleDefault) {
        if (dialog_height > MAX_VIEW_HEIGHT) {
            dialog_height = MAX_VIEW_HEIGHT;
        }
        dialog_y = (applicationFrameHeight - dialog_height) / 2;
    } else {
        if (dialog_height > MAX_VIEW_HEIGHT / 2) {
            dialog_height = MAX_VIEW_HEIGHT / 2;
        }
        dialog_y = (applicationFrameHeight / 2 - dialog_height) / 2;
    }
}

- (void)initDialogLayout
{
    [_dialogView setFrame:CGRectMake(dialog_x,
                                     dialog_y,
                                     DIALOGVIEW_WIDTH,
                                     dialog_height)];
    
    int y = dialog_height - BOTTOM_INSETS - BUTTON_HEIGHT;
    
    int buttonCount = [_buttonArray count];
    if (buttonCount == 2) {
        button_width = (view_width - VIEW_INTERVAL_H) / 2;
        CGRect buttonFrame1 = CGRectMake(EDGE_INSETS,
                                         y,
                                         button_width,
                                         BUTTON_HEIGHT);
        UIButton *button1 = [_buttonArray objectAtIndex:0];
        [button1 setFrame:buttonFrame1];
        
        CGRect buttonFrame2 = CGRectMake(EDGE_INSETS + button_width + VIEW_INTERVAL_H,
                                         y,
                                         button_width,
                                         BUTTON_HEIGHT);
        UIButton *button2 = [_buttonArray objectAtIndex:1];
        [button2 setFrame:buttonFrame2];
    } else {
        button_width = view_width;
        CGRect buttonFrame1 = CGRectMake(EDGE_INSETS,
                                         y,
                                         button_width,
                                         BUTTON_HEIGHT);
        UIButton *button1 = [_buttonArray objectAtIndex:0];
        [button1 setFrame:buttonFrame1];
        
        y -= VIEW_INTERVAL_V;
        for (int i = buttonCount - 1; i > 0; i --) {
            y -= VIEW_INTERVAL_V + BUTTON_HEIGHT;
            CGRect buttonFrame = CGRectMake(EDGE_INSETS,
                                            y,
                                            button_width,
                                            BUTTON_HEIGHT);
            UIButton *button = [_buttonArray objectAtIndex:i];
            [button setFrame:buttonFrame];
        }
    }
    
    if (_alertViewStyle == ZSAlertViewStylePlainTextInput) {
        int textFieldCount = [_textFieldArray count];
        for (int i = textFieldCount - 1; i >= 0; i --) {
            y -= VIEW_INTERVAL_V + TEXTFIELD_HEIGHT;
            CGRect textFieldFrame = CGRectMake(EDGE_INSETS,
                                               y,
                                               view_width,
                                               TEXTFIELD_HEIGHT);
            ZSTextField *textField = [_textFieldArray objectAtIndex:i];
            [textField setFrame:textFieldFrame];
        }
        [[_textFieldArray objectAtIndex:0] becomeFirstResponder];
    }
    
    if (_alertViewStyle == ZSAlertViewStyleLoginAndPasswordInput) {
        for (ZSTextField *textField in _textFieldArray) {
            [textField removeFromSuperview];
        }
        [_textFieldArray removeAllObjects];
        
        y -= VIEW_INTERVAL_V + TEXTFIELD_HEIGHT;
        ZSTextField *passwordField = [[ZSTextField alloc] initWithFrame:CGRectMake(EDGE_INSETS,
                                                                                   y,
                                                                                   view_width,
                                                                                   TEXTFIELD_HEIGHT)];
        [passwordField setSecureTextEntry:YES];
        [passwordField setPlaceholder:@"Password"];
        [_textFieldArray addObject:passwordField];
        [_dialogView addSubview:passwordField];
        
        y -= VIEW_INTERVAL_V + TEXTFIELD_HEIGHT;
        ZSTextField *accountField = [[ZSTextField alloc] initWithFrame:CGRectMake(EDGE_INSETS,
                                                                                  y,
                                                                                  view_width,
                                                                                  TEXTFIELD_HEIGHT)];
        [accountField setPlaceholder:@"Account"];
        [accountField becomeFirstResponder];
        [accountField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_textFieldArray addObject:accountField];
        [_dialogView addSubview:accountField];
    }
    
    y -= message_height + VIEW_INTERVAL_V;
    CGRect messageFrame = CGRectMake(EDGE_INSETS,
                                     y,
                                     view_width,
                                     message_height);
    [_messageLabel setFrame:messageFrame];
    [_messageLabel setText:_message];
    
    y -= TITLE_HEIGHT;
    CGRect titleFrame = CGRectMake(EDGE_INSETS,
                                   y,
                                   view_width,
                                   TITLE_HEIGHT);
    [_titleLabel setFrame:titleFrame];
    [_titleLabel setText:_title];
}

- (void)setTextFieldsCount:(NSInteger)count
{
    if (_alertViewStyle != ZSAlertViewStylePlainTextInput) {
        return;
    }
    
    for (ZSTextField *textField in _textFieldArray) {
        [textField removeFromSuperview];
    }
    [_textFieldArray removeAllObjects];
    for (int i = 0; i < count; i ++) {
        ZSTextField *textField = [[ZSTextField alloc] init];
        [_dialogView addSubview:textField];
        [_textFieldArray addObject:textField];
    }
}

- (void)show
{
    [self getDialogHeight];
    [self initDialogLayout];
    
    UIViewController *viewController = (UIViewController *)self.delegate;
    [viewController.view addSubview:self];
    
    if (_alertViewShowStyle == ZSAlertViewShowStyleDefault) {
        [self setAlpha:0];
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             [self setAlpha:1];
                         }];
    }
    if (_alertViewShowStyle == ZSAlertViewShowStyleFlyIn) {
        [self setAlpha:1];
        
        CGFloat distance = applicationFrameWidth;
        CGPoint dialogCenter = CGPointMake(applicationFrameWidth * 1.5f, _dialogView.center.y);
        [_dialogView setCenter:dialogCenter];
        dialogCenter.x -= distance;
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [_dialogView setCenter:dialogCenter];
                         }];
    }
}

- (void)dismiss
{
    if (_alertViewShowStyle == ZSAlertViewShowStyleDefault) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             [self setAlpha:0];
                         } completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }];
    }
    if (_alertViewShowStyle == ZSAlertViewShowStyleFlyIn) {
        CGFloat distance = applicationFrameWidth;
        CGPoint dialogCenter = _dialogView.center;
        dialogCenter.x -= distance;
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [_dialogView setCenter:dialogCenter];
                         } completion:^(BOOL finished){
                             [self removeFromSuperview];
                         }];
    }
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    return [_textFieldArray objectAtIndex:textFieldIndex];
}

@end
