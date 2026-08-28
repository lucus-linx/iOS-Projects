//
//  SocketDemoVC.m
//  Socket_Demo
//
//  Created by linxiang on 2017/5/19.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "SocketDemoVC.h"
//socket
#import <sys/socket.h>
//网络相关
#import <netinet/in.h>
#import <arpa/inet.h>

@interface SocketDemoVC ()
@property (weak, nonatomic) IBOutlet UITextField *IPTextField;
@property (weak, nonatomic) IBOutlet UITextField *PortTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *MsgTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *RecvLabel;

//socke
@property (nonatomic, assign) int ClientSocket;

@end

@implementation SocketDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)doConnect:(id)sender {
  
    [self connectToIP:self.IPTextField.text :self.PortTextFeild.text.intValue];
   
}


- (IBAction)doSend:(id)sender {
//    self.RecvLabel.text = [self sendAndRecv:_MsgTextFeild.text];
    
    [self Get_Baidu];
}


/**
 向百度进行网络请求
 */
-(void)Get_Baidu {
    
    NSString * request = @"Get / HTTP/1.1\n""Host:www.baidu.com\n\n";
    
    [self sendAndRecv:request];
}


-(void)connectToIP:(NSString *)IP :(int)port {
    //1、创建socket，若成功，返回socket描述符
    /*
     参数
        1》domain: 协议域 AF_INET -> IPV4
        2》type:   socket类型： SOCK_STREAM（TCP）/ SOCK_DGRAM（报文UDP）
        3》protocol: IP PROTO_TCP,如果写0，则就会自动选择，根据第二个参数
     返回值：
        0 成功
     */
    _ClientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if(_ClientSocket < 0)
    {
        NSLog(@"Create Socket Failed:");
        //关闭socket
        close(_ClientSocket);
        return;
    }
    
/* 非必须
     // 声明并初始化一个客户端的socket地址结构
     struct sockaddr_in client_addr;              //客户端网络地址结构体
     bzero(&client_addr, sizeof(client_addr));    //数据初始化--清零
     client_addr.sin_family = AF_INET;            //设置为IP通信
     client_addr.sin_addr.s_addr = htons(INADDR_ANY);//IP地址--允许连接到所有本地地址上
     client_addr.sin_port = htons(0);             //端口号
     
     // 绑定客户端的socket和客户端的socket地址结构 非必需
     if(-1 == (bind(client_socket_fd, (struct sockaddr*)&client_addr, sizeof(client_addr))))
     {
         NSLog(@"Client Bind Failed:");
         //关闭socket
         close(client_socket_fd);
         return;
     }
 */
    
    //2、声明一个服务器端的socket地址结构，并用服务器那边的IP地址及端口对其进行初始化，用于后面的连接
    struct sockaddr_in server_addr;
    bzero(&server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    /*  更加完善的验证
     if(inet_pton(AF_INET, gatewayIPAddress , &server_addr.sin_addr) == 0)
     {
     NSLog(@"Server IP Address Error:");
     return NO;
     }
     */
    server_addr.sin_addr.s_addr = inet_addr(IP.UTF8String);  //获取网关 IP
    server_addr.sin_port = htons(port);                        //固定端口
    socklen_t server_addr_length = sizeof(server_addr);
    
    //3、向服务器发起连接，连接成功后client_socket_fd代表了客户端和服务器的一个socket连接
    /*
     参数：
        1》客户端socket
        2》指向结构体sockaddr的指针，其中包括目的的端口和IP地址
        3》结构体数据长度
     返回值
        0 成功   其他 错误代码
     */
    int Connect_result = connect(_ClientSocket, (struct sockaddr*)&server_addr, server_addr_length);
    if(Connect_result == 0)
    {
        NSLog(@"Connect Success");
    }else
    {
        NSLog(@"Can Not Connect To Server IP:%d",Connect_result);
        //关闭socket
        close(_ClientSocket);
        return;
    }
    
}


-(NSString *)sendAndRecv:(NSString *)sendMsg {
    
    //发送
    NSString * jsonString = sendMsg;
    const char *msg = [jsonString UTF8String];
    
    //send wifi name password
    if(send(_ClientSocket, msg, strlen(msg), 0) < 0)
    {
        NSLog(@"Send File:%s name ERROR/n", msg);
        
        //关闭socket
        close(_ClientSocket);
    }
    else
    {
        NSLog(@"Send File:%s name success/n", msg);
    }
    
    
    //接收
    uint8_t buffer[1024];   //内存空间，准备存放数据  二进制数
    ssize_t recvLen = recv(_ClientSocket, buffer, sizeof(buffer), 0);
    if (recvLen >= 0) {
        NSLog(@"Received Success ：%zd",recvLen);
        
        //处理数据
        NSData * data = [NSData dataWithBytes:buffer length:recvLen];
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"数据：：%@",str);
        
        return str;
        
    }else {
        NSLog(@"Received Faild !!");
    }

    return nil;
}


-(void)disConnect {
    //关闭socket
    close(_ClientSocket);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
