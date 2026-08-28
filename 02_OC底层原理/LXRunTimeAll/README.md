# LXRunTimeAll
runtime各类问题的探究，都在这！！！

-------------------------
简书地址：http://www.jianshu.com/p/bebd89bd7ca8 <br>
        http://www.jianshu.com/p/f48ce7225cf8 <br>

-------------------------
demo_001
```
//普通写法
Person * p = [[Person alloc]init];

//runtime
NSObject * p = objc_msgSend(objc_getRequiredClass("Person"), @selector(alloc));
objc_msgSend(p, @selector(init));
```
```
//普通写法
[p eat];

//runtime
objc_msgSend(p, @selector(eat));
```

demo_002 <br>
将OC代码 转换成 C语言进行对面，从而验证Runtime <br>


demo_003 <br>
目的：给系统NSURL这个类的URLWithString 方法添加一个功能，创建URL又能判断是否为空
解决方案：
```
//交换我们的URLWithString和LX_URLWithString方法
//第一步：拿到这两个方法
//class_getClassMethod     获取类方法
//class_getInstanceMethod  获取对象方法
Method URLWithStr = class_getClassMethod(self, @selector(URLWithString:));
Method LXURLWithStr = class_getClassMethod(self, @selector(LX_URLWithString:));
//第二步：交换方法
method_exchangeImplementations(URLWithStr, LXURLWithStr);
```

demo_4 <br>
归档解档
```
unsigned int count = 0;
Ivar * ivars = class_copyIvarList([Person class], &count);

//for 搞定
for (int i = 0; i < count; i++) {
//拿个每一个ivar
Ivar ivar = ivars[i];
//ivar对应的名称
const char * name = ivar_getName(ivar);
//转成 OC
NSString * key = [NSString stringWithUTF8String:name];
//解档
id value = [coder decodeObjectForKey:key];

//设置到属性 -- KVC
[self setValue:value forKey:key];

NSLog(@"BBBBB == %@",key);
}

free(ivars);
```


demo_005 <br>
类似于demo_003是一个方法交换的验证。

demo_006 <br>
Class_isa对象模型及类与元类的探究，也就是metaClass <br>
可看图 /Pic/demo_006_001.jpg <br>
参考文档：http://zziking.github.io/ios/2016/02/08/Objective-C_Runtime_1_The_object_model.html <br>


RuntimeDemo_008 <br>
利用Runtime减少应用崩溃-例如数组越界 <br>





