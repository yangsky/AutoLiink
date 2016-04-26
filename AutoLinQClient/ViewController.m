//
//  ViewController.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/9.
//
//

#import "ViewController.h"
#import "QiniuUtil.h"
#import "Payload.h"
#import "HttpClient.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logonButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

- (IBAction)doLogon:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logonButton.layer.cornerRadius = 5;
    
    _usernameTextField.text = @"JohnMac";
    _passwordTextField.text = @"1234qwer";
}

- (IBAction)doLogon:(UIButton *)sender {
    
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (username.length == 0 || password.length ==0) {
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.text = @"用户名、密码不能为空！";
        return;
    }
    
    NSString *data = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", username, password];
    
    NSString *json = [Payload generateCommomMsgWithFunid:@"Logon" pkgNum:@"1" isEncryption:@"0" isCompress:@"0" data:data];
    NSLog(@"%@", json);
    
    NSError *error;
    NSDictionary *paramters = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"http://123.56.102.92:80/server/rest/gateway/root" parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"responseObject=%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
    }];
}

@end
