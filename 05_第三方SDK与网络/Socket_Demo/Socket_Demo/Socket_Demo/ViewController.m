//
//  ViewController.m
//  Socket_Demo
//
//  Created by linxiang on 2017/5/18.
//  Copyright © 2017年 minxing. All rights reserved.
//

#import "ViewController.h"
//socket
#import <sys/socket.h>
//网络相关
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self sendWIFINamePASS];
}


-(BOOL)sendWIFINamePASS
{
    // 声明并初始化一个客户端的socket地址结构
    struct sockaddr_in client_addr;              //客户端网络地址结构体
    bzero(&client_addr, sizeof(client_addr));    //数据初始化--清零
    client_addr.sin_family = AF_INET;            //设置为IP通信
    client_addr.sin_addr.s_addr = htons(INADDR_ANY);//IP地址--允许连接到所有本地地址上
    client_addr.sin_port = htons(0);             //端口号
    
    // 创建socket，若成功，返回socket描述符
    int client_socket_fd = socket(AF_INET, SOCK_STREAM, 0);
    if(client_socket_fd < 0)
    {
        NSLog(@"Create Socket Failed:");
        
        //关闭socket
        close(client_socket_fd);
        
        return NO;
    }
    
    // 绑定客户端的socket和客户端的socket地址结构 ***非必需***
    if(-1 == (bind(client_socket_fd, (struct sockaddr*)&client_addr, sizeof(client_addr))))
    {
        NSLog(@"Client Bind Failed:");
        
        //关闭socket
        close(client_socket_fd);
        
        return NO;
    }
    
    // 声明一个服务器端的socket地址结构，并用服务器那边的IP地址及端口对其进行初始化，用于后面的连接
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
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  //获取网关 IP
    server_addr.sin_port = htons(12345);                        //固定端口
    socklen_t server_addr_length = sizeof(server_addr);
    
    // 向服务器发起连接，连接成功后client_socket_fd代表了客户端和服务器的一个socket连接
    if(connect(client_socket_fd, (struct sockaddr*)&server_addr, server_addr_length) == 0)
    {
        NSLog(@"Connect Success");
    }else
    {
        NSLog(@"Can Not Connect To Server IP:");
        //关闭socket
        close(client_socket_fd);
        return NO;
    }
    
    
    //发送
    NSString * jsonString = @"发送数据喽！！";
    const char *msg = [jsonString UTF8String];
    
    //send wifi name password
    if(send(client_socket_fd, msg, strlen(msg), 0) < 0)
    {
        NSLog(@"Send File:%s name ERROR/n", msg);
        
        //关闭socket
        close(client_socket_fd);
        
        return NO;
    }
    else
    {
        NSLog(@"Send File:%s name success/n", msg);
    }
    
    
    //接收
    uint8_t buffer[1024];   //内存空间，准备存放数据  二进制数
    ssize_t recvLen = recv(client_socket_fd, buffer, sizeof(buffer), 0);
    if (recvLen >= 0) {
        NSLog(@"Received Success ：%zd",recvLen);
        
        //处理数据
        NSData * data = [NSData dataWithBytes:buffer length:recvLen];
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"数据：：%@",str);
    
    }else {
        NSLog(@"Received Faild !!");
        return NO;
    }
    
    
    //关闭socket
    close(client_socket_fd);
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
