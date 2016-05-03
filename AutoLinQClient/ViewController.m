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
#import "JSONKit.h"

#import "ProtoBufManager.h"

#define kServer  @"http://123.56.102.92:80/server/rest/gateway/root"
#define kServer2 @"http://123.56.102.92:80/server/rest/gateway/protobuffer/common"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *pkgNumUITextField;
@property (weak, nonatomic) IBOutlet UISwitch *isEncryptionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isCompressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isProtocolBufferSwitch;
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
    
    _pkgNumUITextField.text = @"1";
    _pkgNumUITextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _isEncryptionSwitch.on = NO;
    
    _isCompressSwitch.on = NO;
    
    _isProtocolBufferSwitch.on = NO;
}

- (IBAction)doLogon:(UIButton *)sender {
    
    _tipLabel.text = @"";
    
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pkgNum = [_pkgNumUITextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *isEncryption = _isEncryptionSwitch.on?@"1":@"0";
    NSString *isCompress = _isCompressSwitch.on?@"1":@"0";
    NSString *isProtocolBuffer = _isProtocolBufferSwitch.on?@"1":@"0";
    
    if (username.length == 0 || password.length ==0 || [pkgNum integerValue]<=0) {
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.text = @"用户名、密码不能为空！分包数必需大于1！";
        return;
    }
    
    NSString *data = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", username, password];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"Logon" forKey:kFuncID];
    [dict setObject:pkgNum forKey:kPkgNum];
    [dict setObject:isEncryption forKey:kIsEncryption];
    [dict setObject:isCompress forKey:kIsCompress];
    [dict setObject:data forKey:kData];

    if (!isProtocolBuffer) {

        [HttpClient POST:kServer parameters:dict finish:^(id responseObject) {
            _tipLabel.text = [responseObject description];
            NSLog(@"responseObject=%@", responseObject);
        }];
    } else {

        // generate commom message
        NSString *payLoadJson = [Payload generateCommomMsgWithFunid:@"Logon" pkgNum:pkgNum isEncryption:isEncryption isCompress:isCompress data:data];
        // commom message to dictionary
        NSDictionary *payLoadDict = [payLoadJson objectFromJSONString];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager POST:kServer2 parameters:[ProtoBufManager dictionaryToData:payLoadDict] success:^(NSURLSessionDataTask *task, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _tipLabel.text = [responseObject description];
            });
            NSLog(@"response:%@", responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error:%@", error);
        }];
    }
}

// 点击屏幕任何地方,收起键盘
- (void)resignFirstResponder:(UIGestureRecognizer *)recognizer {
    
    [self.view endEditing:YES];
}

@end
