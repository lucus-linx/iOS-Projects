//
//  LXNineBoxVC.m
//  TodayNews
//
//  Created by 林祥 on 2018/3/11.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXNineBoxVC.h"
#import "KMNineBoxView.h"
#import "KMUIKitMacro.h"

@interface LXNineBoxVC ()<KMNineBoxViewDelegate>

@property (strong, nonatomic)KMNineBoxView *nineBoxView;

@end

@implementation LXNineBoxVC

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.nineBoxView];
}

-(KMNineBoxView *)nineBoxView {
    if (_nineBoxView) {
        [_nineBoxView removeFromSuperview];
        _nineBoxView = nil;
    }
    
    _nineBoxView = [[KMNineBoxView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _nineBoxView.center = self.view.center;

    _nineBoxView.delegate = self;
    _nineBoxView.predefinedPassSeq = @"123456";
    _nineBoxView.backgroundColor = [UIColor grayColor];
    
    
    return _nineBoxView;
}

- (void)nineBoxDidFinishWithState:(KMNineBoxState)state passSequence:(NSString *)passSequence;
{
    switch (state) {
        case KMNineBoxStatePassed: {
//            self.titlelabel.text = @"Passed!";
//            self.titlelabel.textColor = [UIColor greenColor];
//            self.passSeqLabel.text = [NSString stringWithFormat:@"Steps: %@", passSequence];
            
            LXLog(@"SUCCESS");
            
            break;
        }
            
        case KMNineBoxStateFailed: {
//            self.titlelabel.text = @"Incorrect!";
//            self.titlelabel.textColor = [UIColor redColor];
//            self.passSeqLabel.text = [NSString stringWithFormat:@"Steps: %@", passSequence];
            
            LXLog(@"Fail");
            break;
        }
            
        default:
            break;
    }
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
