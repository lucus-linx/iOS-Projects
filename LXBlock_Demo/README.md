# LXBlock_Demo
How to use Block? 建议与编程思想一起看：LXProgrammeThought

## 我的博客地址：http://www.jianshu.com/p/02ba71b05ac1

## 一、忘记block格式

快速使用：<br>
![image](http://upload-images.jianshu.io/upload_images/1859399-1691b285b59a116b.png?imageMogr2/auto-orient/strip%7CimageView2/2)<br>
![image](http://upload-images.jianshu.io/upload_images/1859399-dace14ccd574d3e4.png?imageMogr2/auto-orient/strip%7CimageView2/2)<br>

## 二、block简介<br>
返回值类型(^block变量名)(形参列表) = ^(形参列表) {<br>
};<br>

调用Block保存的代码<br>
block变量名(实参);<br>

默认情况下,Block内部不能修改外面的局部变量<br>
Block内部可以修改使用__block修饰的局部变量<br>

Block的模式<br>
1.无参数无返回值的Block<br>
2.有参数无返回值的Block<br>
3.有参数有返回值的Block<br>

eg:<br>
```
* 无参数无返回值的Block
-(void)func1{
    /**
     *  void ：就是无返回值
     *  emptyBlock：就是该block的名字
     *  ()：这里相当于放参数。由于这里是无参数，所以就什么都不写
     */
    void (^emptyBlock)() = ^(){
        NSLog(@"无参数,无返回值的Block");
    };
    emptyBlock();
}
```
```
* 有参数无返回值的Block
/**
     *  调用这个block进行两个参数相加
     *
     *  @param int 参数A
     *  @param int 参数B
     *
     *  @return 无返回值
     */
    void (^sumBlock)(int ,int ) = ^(int a,int b){
        NSLog(@"%d + %d = %d",a,b,a+b);
    };
    /**
     *  调用这个sumBlock的Block，得到的结果是20
     */
    sumBlock(10,10);
```

```
* 有参数有返回值的Block
/**
     *  有参数有返回值
     *
     *  @param NSString 字符串1
     *  @param NSString 字符串2
     *
     *  @return 返回拼接好的字符串3
     */    
    NSString* (^logBlock)(NSString *,NSString *) = ^(NSString * str1,NSString *str2){
        return [NSString stringWithFormat:@"%@%@",str1,str2];
    };
    //调用logBlock,输出的是 我是Block
    NSLog(@"%@", logBlock(@"我是",@"Block"));
```


## 三、block的使用 （具体看demo）

1、block作为对象的属性


2、block作为方法的参数


3、block作为返回值




如有侵权，请联系<br>
邮箱：lionsom_lin@qq.com
