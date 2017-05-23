//
//  ViewController.m
//  ClueExampleApp
//
//  Created by Ahmed Sulaiman on 4/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "ViewController.h"
#import <Clue/Clue.h>

@interface ViewController ()

@end

@implementation ViewController

// Handle shake gesture to start/stop recording
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [[ClueController shared] handleShake:motion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *backgroundColor = [UIColor colorWithRed:126.0/255.0 green:239.0/255.0 blue:204.0/255.0 alpha:1.000];
    [self.view setBackgroundColor:backgroundColor];
    
    [self setupLoginForm];
    [self setupButton];
    [self setupInputFields];
    [self setupIcons];
    [self setupLogo];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Setup UI

- (void)setupLoginForm {
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    UIView *loginFormBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, viewSize.height/2 - 30, viewSize.width, viewSize.height/2 + 30)];
    [loginFormBackgroundView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:loginFormBackgroundView];
}

- (void)setupButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(35.00, 539.00, 305.00, 55.00)];
    [button setBackgroundColor:[UIColor colorWithRed:184.0/255.0 green:166.0/255.0 blue:228.0/255.0 alpha:1.000]];
    [button setTitle:@"Get Started" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Karla-Bold" size:13.0]];
    [button addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(loginButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(loginButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:button];
}

- (void)setupInputFields {
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 455, 230.00, 45)];
    [passwordTextField setTextColor:[UIColor whiteColor]];
    [passwordTextField setSecureTextEntry:YES];
    [passwordTextField setFont:[UIFont fontWithName:@"Karla-Regular" size:13.0]];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, passwordTextField.frame.size.height - 1, passwordTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2].CGColor;
    [passwordTextField.layer addSublayer:bottomBorder];
    [self.view addSubview:passwordTextField];
    
    UITextField *emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.00, 374.00, 230, 45)];
    [emailTextField setTextColor:[UIColor whiteColor]];
    [emailTextField setFont:[UIFont fontWithName:@"Karla-Regular" size:13.0]];
    CALayer *emailBottomBorder = [CALayer layer];
    emailBottomBorder.frame = CGRectMake(0.0f, emailTextField.frame.size.height - 1, emailTextField.frame.size.width, 1.0f);
    emailBottomBorder.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2].CGColor;
    [emailTextField.layer addSublayer:emailBottomBorder];
    
    [self.view addSubview:emailTextField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110.00, 446.50, 62.50, 11.50)];
    [label setText:@"PASSWORD"];
    [label setFont:[UIFont fontWithName:@"Karla-Bold" size:10.0]];
    [label setTextColor:[UIColor colorWithRed:184.0/255.0 green:166.0/255.0 blue:228.0/255.0 alpha:1.000]];
    [self.view addSubview:label];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.00, 364.00, 62.00, 11.50)];
    [userLabel setText:@"USERNAME"];
    [userLabel setFont:[UIFont fontWithName:@"Karla-Bold" size:10.0]];
    [userLabel setTextColor:[UIColor colorWithRed:184.0/255.0 green:166.0/255.0 blue:228.0/255.0 alpha:1.000]];
    [self.view addSubview:userLabel];
}

- (void)setupIcons {
    UIImageView *usernameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35.00, 364.00, 16.00, 15.00)];
    [usernameImageView setImage:[UIImage imageNamed:@"username"]];
    [self.view addSubview:usernameImageView];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35.00, 446.50, 15.00, 16.5)];
    [passwordImageView setImage:[UIImage imageNamed:@"password"]];
    [self.view addSubview:passwordImageView];
}

- (void)setupLogo {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(83.00, 108.00, 209.00, 116.50)];
    [label setText:@"Chat"];
    [label setFont:[UIFont fontWithName:@"Karla-Bold" size:93.0]];
    [label setTextColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.000]];
    [self.view addSubview:label];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(232.00, 73.00, [UIImage imageNamed:@"logo"].size.width/2, [UIImage imageNamed:@"logo"].size.height/2)];
    [logoImageView setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logoImageView];
}

- (void)loginButtonClick:(UIButton *)sender {
    [self restoreLoginButtonStyle:sender];
    NSURLRequest *request = [self requestWithPath:@"http://apple.com" HTTPMethod:@"GET" andData:nil];
    [self performRequest:request completion:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        // Do something
    }];
}

- (void)loginButtonTouchDown:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor colorWithRed:184.0/255.0 green:166.0/255.0 blue:228.0/255.0 alpha:0.7]];
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];
}

- (void)loginButtonTouchUpOutside:(UIButton *)sender {
    [self restoreLoginButtonStyle:sender];
}

- (void)restoreLoginButtonStyle:(UIButton *)button {
    [button setBackgroundColor:[UIColor colorWithRed:184.0/255.0 green:166.0/255.0 blue:228.0/255.0 alpha:1.000]];
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (NSURLRequest *)requestWithPath:(NSString *)path
                       HTTPMethod:(NSString *)httpMethod
                          andData:(NSData *)data {
    NSURL *URL = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:httpMethod];
    if (data) {
        NSString *length = [[NSNumber numberWithFloat:[data length]] stringValue];
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:data];
    }
    return request;
}

- (void)performRequest:(NSURLRequest *)request completion:(void (^)(NSData *, NSHTTPURLResponse *, NSError *))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        completion(data, httpResponse, error);
    }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
