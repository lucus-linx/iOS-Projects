# load_initialize_init_demo
验证OC中load、initialize、init方法之间的区别！！！



--------------------
initialize 与 init 比较
---------------------
简书地址：http://www.jianshu.com/p/e4399b726e3c

| Tables        | -(void)init           | +(void)initialize  |
| -------------   |:-------------:| :-----:|
| 方法类型      | 属于对象方法，-开头 | 属于类方法，+开头 |
| 调用时刻      | 每个对象初始化的时候调用一次      |   每个类初始化的时候调用一次 |
|用NSString类创建了7个NSString对象|调用7次init方法 | 调用了1次initialize方法 |


------------------
initialize 与 load 比较
------------------
简书地址：http://www.jianshu.com/p/73c02ac216c8

| Tables        | +(void)load           | +(void)initialize  |
| ------------- |:-------------:| :-----:|
| 执行时机      | 在程序运行后立即执行 | 在类的方法第一次被调时执行 |
| 若自身未定义，是否沿用父类的方法？      | 否      |   是 |
| 类别中的定义 | 全都执行，但后于类中的方法      |    覆盖类中的方法，只执行一个 |

------------------
initialize、load、init、Category的执行顺序 
------------------




