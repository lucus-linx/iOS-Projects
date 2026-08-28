//
//  LXAFNetwork.m
//  TodayNews
//
//  Created by linxiang on 2018/4/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXAFNetwork.h"

#import "AFAppDotNetAPIClient.h"

@implementation LXAFNetwork

+(NSURLSessionDataTask *)LXAFNetwork_POST:(NSString *)URLString
                               parameters:(id)parameters
                                 progress:(void (^)(NSProgress *))uploadProgress
                                  success:(void (^)(NSURLSessionDataTask *, id))success
                                  failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    // get AFHTTPSessionManager
    AFAppDotNetAPIClient * manager = [AFAppDotNetAPIClient sharedClient];

    /* Serializer
     请求格式
     AFHTTPRequestSerializer            二进制格式
     AFJSONRequestSerializer            JSON
     AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
     
     返回格式
     AFHTTPResponseSerializer           二进制格式
     AFJSONResponseSerializer           JSON
     AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
     AFXMLDocumentResponseSerializer (Mac OS X)
     AFPropertyListResponseSerializer   PList
     AFImageResponseSerializer          Image
     AFCompoundResponseSerializer       组合
     */
    manager.requestSerializer = [AFJSONRequestSerializer serializer];   // 申明请求的数据是 json 类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];  //以JSON格式返回
    // timeout
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    // remove respinse null values
    AFJSONResponseSerializer * responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    
    
    // security policy
    manager.securityPolicy = [self customSecurityPolicy];
    
    // task init
    NSURLSessionDataTask * task = [manager POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
    // tast start
    [task resume];
    
    return task;
}


/**
 HTTPS证书配置

 @return AFSecurityPolicy
 */
+ (AFSecurityPolicy *)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"Certificate_Name" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];

    /*
     AFSecurityPolicy分三种验证模式：

     AFSSLPinningModeNone
     这个模式表示不做SSL pinning，
     只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书就不会通过。

     AFSSLPinningModeCertificate
     这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。

     AFSSLPinningModePublicKey
     这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，
     只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。
     */
    // AFSSLPinningModeCertificate 使用证书验证模式
    //方式一：
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    NSSet *certSet = [NSSet setWithObject:certData];
    securityPolicy.pinnedCertificates = certSet;
    //方式二:
    // AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];

    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;   // 是否允许自建证书或无效证书（重要！！！）

    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;

    return securityPolicy;
}


@end
