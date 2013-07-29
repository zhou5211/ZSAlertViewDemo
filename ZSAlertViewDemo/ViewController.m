//
//  ViewController.m
//  ZSAlertViewDemo
//
//  Created by 1010@comp on 13-7-20.
//  Copyright (c) 2013年 ZRX. All rights reserved.
//

#import "ViewController.h"
#import "ZSAlertView.h"

@interface ViewController ()
{
    ZSAlertView *alertView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    int x = 20, y = 60;
    int width = 280;
    int height = 40;
    
    NSArray *titles = [[NSArray alloc] initWithObjects:
                       @"Normal with single button",
                       @"Normal with double button",
                       @"Plain text input",
                       @"Login and password input",
                       @"Show style default",
                       @"Show style fly in",
                       nil];
    
    for (int i = 0; i < [titles count]; i ++) {
        UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [testButton setFrame:CGRectMake(x, y, width, height)];
        [testButton setTag:i];
        [testButton setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [testButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:testButton];
        
        y += height + 10;
    }
    
    alertView = [[ZSAlertView alloc] initWithTitle:@"Title"
                                           message:@"message"
                                          delegate:self
                                 cancelButtonTitle:@"cancel"
                                 otherButtonTitles:nil];
}

- (void)buttonClicked:(id)sender
{
    int tag = [sender tag];
    switch (tag) {
        case 0:
        {
            [alertView show];
        }
            break;
        case 1:
        {
            ZSAlertView *alertView2 = [[ZSAlertView alloc] initWithTitle:@"Title"
                                                                 message:@"message"
                                                                delegate:self
                                                       cancelButtonTitle:@"cancel"
                                                       otherButtonTitles:@"confirm", nil];
            [alertView2 show];
        }
            break;
        case 2:
        {
            alertView.alertViewStyle = ZSAlertViewStylePlainTextInput;
            [alertView setTextFieldsCount:1];
            [alertView show];
        }
            break;
        case 3:
        {
            alertView.alertViewStyle = ZSAlertViewStyleLoginAndPasswordInput;
            [alertView show];
        }
            break;
        case 4:
        {
            alertView.alertViewShowStyle = ZSAlertViewShowStyleDefault;
            [alertView show];
        }
            break;
        case 5:
        {
            alertView.alertViewShowStyle = ZSAlertViewShowStyleFlyIn;
            [alertView show];
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
