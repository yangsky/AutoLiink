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
#import "Des.h"
#import "ZipUtil.h"

#define kServer @"http://123.56.102.92:80/server/rest/gateway/root"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *isEncryptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *isCompressTextField;
@property (weak, nonatomic) IBOutlet UIButton *logonButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

- (IBAction)doLogon:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 点击屏幕任何地方,收起键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder:)]];
    
    _logonButton.layer.cornerRadius = 5;
    
    // 初始赋值
    _usernameTextField.text = @"JohnMac";
    
    _passwordTextField.text = @"1234qwer";
    
    _isEncryptionTextField.text = @"0";
    _isEncryptionTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _isCompressTextField.text = @"0";
    _isCompressTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (IBAction)doLogon:(UIButton *)sender {
    
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *isEncryption = [_isEncryptionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *isCompress = [_isCompressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (username.length == 0 || password.length ==0) {
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.text = @"用户名、密码不能为空！";
        return;
    }
    if (![isEncryption isEqualToString:@"0"] && ![isEncryption isEqualToString:@"1"]) {
        isEncryption = @"0";
    }
    if (![isCompress isEqualToString:@"0"] && ![isCompress isEqualToString:@"1"]) {
        isCompress = @"0";
    }
    
    NSString *data = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", username, password];
    
    NSString *json = [Payload generateCommomMsgWithFunid:@"Logon" pkgNum:@"1" isEncryption:isEncryption isCompress:isCompress data:data];
    NSLog(@"%@", json);
    
    NSError *error;
    NSDictionary *paramters = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:kServer parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
        _tipLabel.text = [responseObject description];
        NSLog(@"responseObject=%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _tipLabel.text = [error localizedDescription];
        NSLog(@"error=%@", error);
    }];
}

// 点击屏幕任何地方,收起键盘
- (void)resignFirstResponder:(UIGestureRecognizer *)recognizer {
    
    [self.view endEditing:YES];
}

@end
