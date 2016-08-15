//
//  HPAlipayCertifyVC.m
//  桔子信用
//
//  Created by 张俊凯 on 16/6/17.
//  Copyright © 2016年 禾浦科技. All rights reserved.
//

#import "HPAlipayCertifyVC.h"
//导入芝麻信用
#import <ZMCreditSDK/ALCreditService.h>

@interface HPAlipayCertifyVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/**
 *  键盘动画时间
 */
@property(nonatomic,assign)CGFloat aniTime;

/**
 *  导航背景图
 */
@property(nonatomic,strong)UIView *backgroundView;
/**
 *  拿到本地数据账户ID
 */
@property(nonatomic,copy)NSString *accountId;

@end

@implementation HPAlipayCertifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认按钮不可用
    self.loginButton.enabled = NO;
    
    [self getLineView];
    //先设置背景色
    [self.view insertSubview:[HPUtils creatSystemThemeImageViewWithFrame:[UIScreen mainScreen].bounds] atIndex:0];
    //设置验证码按钮样式
    [self configCodeBtn];
    //设置登录按钮样式
    [self configLoginBtn];
    
    //增加键盘的监听
    //当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   
    //拿到accountID
    HPLoginData *loginData = [HPUtils getLoginData];
    self.accountId = loginData.accountId;
    
}

-(void)configLoginBtn
{
    //生成三张图片
    UIImage *normalImage = [HPUtils imageFromColor:[UIColor colorWithWhite:1.000 alpha:0.300] andSize:self.loginButton.size];
    UIImage *highlightImage = [HPUtils imageFromColor:[UIColor colorWithWhite:1.000 alpha:0.700] andSize:self.loginButton.size];
    UIImage *disableImage = [HPUtils imageFromColor:[UIColor colorWithWhite:0.500 alpha:0.500] andSize:self.loginButton.size];
    
    
    //设置三种状态背景图
    [self.loginButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:disableImage forState:UIControlStateDisabled];
    
    //切割圆角
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
}

-(void)configCodeBtn
{
    //三种图片
    UIImage *normalImage = [HPUtils imageFromColor:[UIColor colorWithWhite:1.000 alpha:0.300] andSize:self.codeButton.size];
    UIImage *highlightImage = [HPUtils imageFromColor:[UIColor colorWithWhite:1.000 alpha:0.700] andSize:self.codeButton.size];
    UIImage *disableImage = [HPUtils imageFromColor:[UIColor colorWithWhite:0.500 alpha:0.500] andSize:self.codeButton.size];
    //三种状态
    [self.codeButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.codeButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [self.codeButton setBackgroundImage:disableImage forState:UIControlStateDisabled];
    
    self.codeButton.layer.cornerRadius = 5;
    self.codeButton.layer.masksToBounds = YES;
    
    //名字长度大于等于2  身份证号长度等于18  手机号长度等于11
    RAC(_codeButton,enabled) =[RACSignal combineLatest:@[_nameTextField.rac_textSignal, _cardTextField.rac_textSignal,_phoneTextField.rac_textSignal,] reduce:^id(NSString *name, NSString * cardNumber,NSString * phone){
        return @(name.length >= 2 && cardNumber.length == 18 && phone.length == 11);
    }];
}





//did load 调用，获取顶部 底部黑线
-(void)getLineView
{
    //去除阻挡导航视图
    for(UIView *v in self.navigationController.navigationBar.subviews)
    {
        if(v.class == NSClassFromString(@"_UINavigationBarBackground"))
        {
            self.backgroundView = v;
            v.hidden = YES;
        }
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backgroundView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.backgroundView.hidden = NO;
}


//同意打钩提交
- (IBAction)agreeClick:(UIButton *)sender {
    if (sender.selected)
    {
        sender.selected = NO;
        self.loginButton.enabled = NO;
        
    }
    else
    {
        sender.selected = YES;
        self.loginButton.enabled = YES;
    }
    
}


//验证码按钮点击
- (IBAction)codeButtonClick:(UIButton *)sender
{
    //首先要进行正则表达式判断
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:self.phoneTextField.text];
    
    if (!isMatch) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
    }else{//是手机号码就可以发送
        
        //发送验证码
        [SVProgressHUD showWithStatus:@"准备发送中，请稍后" maskType:SVProgressHUDMaskTypeGradient];
        
        
        NSMutableDictionary *params = [HPUtils getBasicDictionary];
        //标明注册才能发送验证码 让注册
        params[@"mobile"] =self.phoneTextField.text;
        params[@"reg"] =@"true";  //reg是要注册
        JKLog(@"注册界面获取验证码发送数据%@",params);
        
        [[HPHttpManager shareManager] postReqWithBaseUrlStr:kBaseURL surfixUrlStr:kVcodeURL params:params success:^(NSDictionary *responseObject) {
            
            JKLog(@"注册界面获取验证码返回数据%@",responseObject);
            NSInteger code = [responseObject[@"code"] intValue];
            
            if (code == 0) {//发送成功
                [SVProgressHUD showInfoWithStatus:@"发送成功"];
                [self startCount];
            }else {//错误信息
                NSString * errorMessage = responseObject[@"message"];
                [SVProgressHUD showInfoWithStatus:errorMessage];
            }
            
        } failure:^(NSError *error) {
            
            JKLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"无网络连接,请检查后网络后再重试"];
            
        }];
        
    }//判断手机号结尾
    
}

//短信验证码开始倒计时
-(void)startCount
{
    __block int timeout=30; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                //
                //                _codeButton.backgroundColor = [UIColor orangeColor];
                
                _codeButton.enabled = YES;
                
            });
            
        }else{
            
            
            
            int seconds = timeout % 59;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_codeButton setTitle:[NSString stringWithFormat:@"%@秒后重试",strTime] forState:UIControlStateNormal];
                
                //_codeButton.backgroundColor = [UIColor grayColor];
                
                _codeButton.enabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
}



//同意账户服务协议点击
- (IBAction)agreenmentClick:(UIButton *)sender {
   
//    HPAgreenmentVC *agreenVC = [[HPAgreenmentVC alloc]init];
//    agreenVC.code = @"agreement_reg";//注册协议
//    HPSingleNavController *nav = [[HPSingleNavController alloc]initWithRootViewController:agreenVC];
//    
//    [self presentViewController:nav animated:YES completion:nil];
    
    
}


//点击提交  成功后自身消失，并且发通知
- (IBAction)loginClick:(UIButton *)sender {
 
    
#warning 这里面的逻辑是身份验证的逻辑，目前是拷贝注册的逻辑，适当的地方改一下
    //有验证码才能登陆
    if (self.codeTextField.text.length == 6) {
        
        [SVProgressHUD showWithStatus:@"验证中，请稍后" maskType:SVProgressHUDMaskTypeNone];
        
        NSMutableDictionary *params = [HPUtils getBasicDictionary];
        params[@"paramsType"] = @"1";
        params[@"phone"] = self.phoneTextField.text ;
        params[@"realName"] = self.nameTextField.text;
        params[@"idcard"] = self.cardTextField.text ;
        params[@"vcode"] = self.codeTextField.text ;
        JKLog(@"支付宝验证页面发送的数据%@",params);
        
        [[HPHttpManager shareManager] postReqWithBaseUrlStr:kBaseURL surfixUrlStr:@"zmxy/prames.json" params:params success:^(NSDictionary *responseObject) {
            
            JKLog(@"支付宝验证页面返回数据%@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {//注册成功
                //这里上传芝麻信用
                NSString * appId = responseObject[@"data"][@"appId"];
                NSString * sign = responseObject[@"data"][@"sign"];
                NSString * params = responseObject[@"data"][@"params"];
                
                //请求芝麻
                [[ALCreditService sharedService] queryUserAuthReq:appId sign:sign params:params extParams:nil selector:@selector(result:) target:self];
                [SVProgressHUD dismiss];
                
            }else{//注册失败，显示失败信息
                NSString *message = responseObject[@"message"];
                [SVProgressHUD showInfoWithStatus:message];
            }
            
            
        } failure:^(NSError *error) {
            
            JKLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"无网络连接,请检查后网络后再重试"];
          
            
            
        }];
        
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"注册资料必须填写完整,验证码为六位数字"];
    }

}



//绑定成功上传本地服务器
- (void)result:(NSMutableDictionary*)dic{
    
    JKLog(@"芝麻返回来的字典----%@",dic);
    NSMutableDictionary *params = [HPUtils getBasicDictionary];
    params[@"sign"] = dic[@"sign"];
    params[@"params"] = dic[@"params"];
    params[@"accountId"] = self.accountId;
    params[@"login"] = @"true";
    params[@"phone"] = self.phoneTextField.text ;
    params[@"realName"] = self.nameTextField.text;
    params[@"idcard"] = self.cardTextField.text ;
    
    [[HPHttpManager shareManager] postReqWithBaseUrlStr:kBaseURL surfixUrlStr:@"zmxy/submit.json" params:params success:^(NSDictionary *responseObject) {
        
        JKLog(@"服务器返回来芝麻确认信息字典----%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {//授权成功
            NSString *message = responseObject[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
            
            
            NSDictionary * data = responseObject[@"data"];
            //建立一个模型存储数据
            HPLoginData *loginData = [HPLoginData mj_objectWithKeyValues:data];
            //模型转换成数据
            NSData * loginDataBinary = [NSKeyedArchiver archivedDataWithRootObject: loginData];
            
            [HPUtils storeObjects:@[  responseObject[@"id"],
                                      loginData.license,
                                      loginDataBinary
                                      ]
                         withKeys:@[  kUserID,
                                      kUserLicence,
                                      kLoginData
                                      ]];
            
            //发送一个通知给四个主界面登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:kStartLoadDataNotifications object:nil];
            
            //延迟一秒再消失
            DelayExecute(1.0, [self dismissViewControllerAnimated:YES completion:nil];);
            
            
            
            
        }else if (code == 402){//芝麻信用服务器授权失败
            NSString *message = responseObject[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
        }
        
        
    } failure:^(NSError *error) {
        
        JKLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"无网络连接,请检查后网络后再重试"];
        
    }];
    
    
    //大于7.0  设置导航颜色不给芝麻信用影响
    NSString* system  = [[UIDevice currentDevice] systemVersion];
    if([system intValue]>=7){
        self.navigationController.navigationBar.barTintColor =  JKNavBarColor;
    }
    
}



//原注册成功的代码处理逻辑
-(void)test
{
    //                [SVProgressHUD showInfoWithStatus:@"登录成功" maskType:SVProgressHUDMaskTypeBlack];
    //                //登录成功存储信息，暂且和登录成功处理方式一样
    //                NSDictionary * data = responseObject[@"data"];
    //                //建立一个模型存储数据
    //                HPLoginData *loginData = [HPLoginData mj_objectWithKeyValues:data];
    //                //模型转换成数据
    //                NSData * loginDataBinary = [NSKeyedArchiver archivedDataWithRootObject: loginData];
    //
    //                [HPUtils storeObjects:@[  responseObject[@"id"],
    //                                          loginData.license,
    //                                          loginDataBinary
    //                                          ]
    //                             withKeys:@[  kUserID,
    //                                          kUserLicence,
    //                                          kLoginData
    //                                          ]];
    //
    //                //发送一个通知给四个主界面注册好并登录成功
    //                [[NSNotificationCenter defaultCenter] postNotificationName:kStartLoadDataNotification object:nil];
    //
    //                //延迟一秒再消失
    //                DelayExecute(1.0, [self dismissViewControllerAnimated:YES completion:nil];);
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *frameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameValue CGRectValue];
    CGFloat keyboardY = keyboardRect.origin.y;
    
    //获取动画时间
    NSString *timeStr = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat aniTime = [timeStr floatValue];
    self.aniTime = aniTime;
    
    //算法思想，让底部按钮 始终在键盘上面
    //拿出按钮的最大值
    CGFloat btnMaxY = CGRectGetMaxY(self.loginButton.frame) + 4;
    //如果遮住按钮
    if (keyboardY < btnMaxY) {
        
        [UIView animateWithDuration:aniTime animations:^{
            self.view.y =  -(btnMaxY - keyboardY + 5);
        }];
        
        
    }
    
    
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:self.aniTime animations:^{
        
        self.view.y =  0;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
