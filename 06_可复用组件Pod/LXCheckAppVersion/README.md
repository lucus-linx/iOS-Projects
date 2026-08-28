# LXCheckAppVersion
检测APP版本从而进行版本更新<br>



## 查询App Store上APP的信息<br>
```
https://itunes.apple.com/lookup?id=APP_ID
```
```
https://itunes.apple.com/cn/lookup?id=APP_ID
```
##### 注意：因为我的APP设置了只在国内，所以resultcount为0;所以必须加上cn才能请求的数据；<br>

## 使用<br>
```
- (IBAction)checkBtn:(id)sender {
    //创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("myueue", DISPATCH_QUEUE_CONCURRENT);
    //创建异步任务
    dispatch_async(queue, ^{
        //点击按钮，开始检测
        [LXCheckAppVersion CheckAppVersion];
    });
}
```


## Add More - 20170417<br>
* 获取设备信息<br>
```
//获取设备信息
UIDevice *device = [[UIDevice alloc] init];
NSString *name = device.name;       //获取设备所有者的名称
NSString *model = device.name;      //获取设备的类别
NSString *type = device.localizedModel; //获取本地化版本
NSString *systemName = device.systemName;   //获取当前运行的系统
NSString *systemVersion = device.systemVersion;//获取当前系统的版本
NSLog(@"----------获取设备信息-----------\n设备所有者名字：%@ \n获取设备的类别：%@ \n获取本地化版本:%@ \n获取当前运行的系统:%@ \n获取当前系统的版本:%@",name,model,type,systemName,systemVersion);
```
* 获取UUID<br>
```
//获取UUID
NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
NSLog(@"----------获取UUID-----------\nUUID:%@",identifier);
```
* 为系统创建一个随机的标示符<br>
```
//为系统创建一个随机的标示符
NSString *identifierNumber = @"";
if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0)
{
    identifierNumber = [[NSUUID UUID] UUIDString];                //ios 6.0 之后可以使用的api
}
else{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);                    //ios6.0之前使用的api
    identifierNumber = [NSString stringWithFormat:@"%@", uuidString];
    CFRelease(uuidString);
    CFRelease(uuid);
}  
NSLog(@"----为系统创建一个随机的标示符----\n标识符：%@",identifierNumber);
```
* 运营商相关<br>
```
//运营商
CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];

CTCarrier *carrier = [info subscriberCellularProvider];
NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];

//获取当前网络
/*
 CTRadioAccessTechnologyGPRS         //介于2G和3G之间，也叫2.5G ,过度技术
 CTRadioAccessTechnologyEdge         //EDGE为GPRS到第三代移动通信的过渡，EDGE俗称2.75G
 CTRadioAccessTechnologyWCDMA
 CTRadioAccessTechnologyHSDPA            //亦称为3.5G(3?G)
 CTRadioAccessTechnologyHSUPA            //3G到4G的过度技术
 CTRadioAccessTechnologyCDMA1x       //3G
 CTRadioAccessTechnologyCDMAEVDORev0    //3G标准
 CTRadioAccessTechnologyCDMAEVDORevA
 CTRadioAccessTechnologyCDMAEVDORevB
 CTRadioAccessTechnologyeHRPD        //电信使用的一种3G到4G的演进技术， 3.75G
 CTRadioAccessTechnologyLTE          //接近4G
 */
NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];

NSLog(@"----------运营商----------\n运营商名字：%@\n获取当前网络:%@",mCarrier,mConnectType);
```

如有侵权，万分抱歉。请联系：<br>
邮箱：lionsom_lin@qq.com
