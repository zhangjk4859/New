//
//  HPSesameVC.m
//  桔子信用
//
//  Created by 张俊凯 on 16/5/18.
//  Copyright © 2016年 禾浦科技. All rights reserved.
//

#import "HPSesameVC.h"

//导入芝麻信用
#import <ZMCreditSDK/ALCreditService.h>


@interface HPSesameVC ()
@property (weak, nonatomic) IBOutlet UIView *topVIew;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;


//芝麻信用需要的三个参数
@property(nonatomic,copy)NSString *appId;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *params;

/**
 *  记录本次是否绑定成功
 */
@property(nonatomic,assign)BOOL isBinded;


@end

@implementation HPSesameVC

// 同意激活按钮
- (IBAction)click:(UIButton *)sender {
    if (sender.selected)
    {
        sender.selected = NO;
        self.bindButton.enabled = NO;
        self.bindButton.alpha = 0.3;
    }
    else
    {
        sender.selected = YES;
        self.bindButton.enabled = YES;
        self.bindButton.alpha = 1;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设定导航栏标题
    self.navigationItem.title = @"芝麻信用";
    self.view.backgroundColor = JKGlobeGrayColor;
    //绑定成功的覆盖界面，默认是隐藏的
    self.topVIew.backgroundColor = JKGlobeGrayColor;
    self.isBinded = NO;
    self.topVIew.hidden = YES;
    //去加载，判断是否绑定
    //[self configBindingInfo];
    
    self.bindButton.enabled = NO;
    self.bindButton.alpha = 0.5;
    self.bindButton.backgroundColor = [UIColor colorWithRed:0.149 green:0.800 blue:0.447 alpha:1.000];
    
    self.navigationController.navigationBar.hidden = NO;
}

//每次界面要出现的时候也去检查是否绑定
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //去加载，判断是否绑定
    //[self configBindingInfo];
}



//检测绑定信息
-(void)configBindingInfo
{
//    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
//    NSString *tableName = @"user_table";
//    // 创建名为user_table的表，如果已存在，则忽略该操作
//    [store createTableWithName:tableName];
//    
//    NSDictionary * dataDic = [store getObjectById:kHomePageInfo fromTable:tableName];
//    NSInteger sesame = [dataDic[@"sesame"] integerValue];
//    if ( sesame == 1 ) {//已经绑定,显示已经绑定
//        //绑定成功，显示对号
//        self.topVIew.hidden = NO;
//        //动画覆盖
//        self.topVIew.alpha = 0;
//        [UIView animateWithDuration:2.0 animations:^{
//            self.topVIew.alpha = 1;
//        }];
//    }
    
}


//绑定芝麻信用授权
-(IBAction)bindClick:(UIButton *)sender
{
    
    //发送默认即可
    NSMutableDictionary *params = [HPUtils getBasicDictionary];
    JKLog(@"芝麻信用发送数据%@",params);
    
    [[HPHttpManager shareManager] postReqWithBaseUrlStr:kBaseURL surfixUrlStr:kZMParamsURL params:params success:^(NSDictionary *responseObject) {
        
        JKLog(@"返回芝麻信用数据%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {//返回数据成功
            
            //存储服务器返回的芝麻信息
            self.appId = responseObject[@"data"][@"appId"];
            self.sign = responseObject[@"data"][@"sign"];
            self.params = responseObject[@"data"][@"params"];
            
            //请求芝麻
            [[ALCreditService sharedService] queryUserAuthReq:self.appId sign:self.sign params:self.params extParams:nil selector:@selector(result:) target:self];
            
            
        }else if(code == 401){//绑定成功，显示对号视图
            self.topVIew.hidden = NO;
            
        }
        
        
    } failure:^(NSError *error) {
        
        JKLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"无网络连接,请检查后网络后再重试"];
        
    }];
    
}


//绑定成功上传本地服务器
- (void)result:(NSMutableDictionary*)dic{
    
    [SVProgressHUD showWithStatus:@"数据加载中,请稍后"];
    JKLog(@"芝麻返回来的字典----%@",dic);
    NSMutableDictionary *params = [HPUtils getBasicDictionary];
    params[@"sign"] = dic[@"sign"];
    params[@"params"] = dic[@"params"];
    
    [[HPHttpManager shareManager] postReqWithBaseUrlStr:kBaseURL surfixUrlStr:kZMSubmitURL params:params success:^(NSDictionary *responseObject) {
        
        JKLog(@"服务器返回来芝麻确认信息字典----%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {//授权成功
            NSString *message = responseObject[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
            
            //更改芝麻信用绑定状态，回到主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
//                [HPUtile changeBindStateWithItem:@"sesame"];
//                [self configBindingInfo];
                self.topVIew.hidden = NO;
            });
            
            

        }else if (code == 402){//芝麻信用服务器授权失败
            NSString *message = responseObject[@"message"];
//            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@%@",message,@"请重新绑定支付宝"]maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@",message,@",请重新绑定支付宝"]];
            //重新绑定支付宝
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//             HPAlipayReCertifyVC *reAlipayVC = [HPAlipayReCertifyVC new];
//                [self.navigationController pushViewController: reAlipayVC animated:YES];
            });
        }else{//其他情况
           // [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"绑定失败，请重试"];
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

//点击查看隐私权政策
- (IBAction)agreenmentButtonClick:(UIButton *)sender {
//    HPAgreenmentVC *agreenVC = [[HPAgreenmentVC alloc]init];
//    agreenVC.code = @"agreement_zmxy";//通讯录协议
//    [self.navigationController pushViewController:agreenVC animated:YES];
}




@end
