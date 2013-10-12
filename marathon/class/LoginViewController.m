//
//  LoginViewController.m
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *codeField;

@end

@implementation LoginViewController
@synthesize codeField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = BASE_PAGE_BG_COLOR;
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(60, 40, 200, 40)];
    codeField.textAlignment = NSTextAlignmentCenter;
    codeField.borderStyle = UITextBorderStyleLine;
    codeField.delegate = self;
    codeField.font = HEI_(26);
    codeField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:codeField];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(60, 100, 200, 40);
    submitBtn.titleLabel.font = HEI_(16);
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor grayColor]];
    [submitBtn addTarget:self action:@selector(submit_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)submit_click:(id)sender{
    NSString *code = codeField.text;
    
    NSString *loginStr = kLoginURL(code);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:loginStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] intValue] == 1) {
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DMLog(@"Error: %@", error);
        
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self submit_click:nil];
    return YES;
}
@end
