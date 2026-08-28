//
//  Created by Colin Eberhardt on 13/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface RWTFlickrSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

// 注意:这是一个弱引用;视图引用视图模型，但不拥有它。
@property (weak, nonatomic) RWTFlickrSearchViewModel *viewModel;

@end

@implementation RWTFlickrSearchViewController


-(instancetype)initWithViewModel:(RWTFlickrSearchViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  
    // 绑定viewmodel
    [self bindViewModel];
}

- (void)bindViewModel {
    self.title = self.viewModel.title;
//    self.searchTextField.text = self.viewModel.searchText;
    
    RAC(self.viewModel, searchText) = self.searchTextField.rac_textSignal;
    
    self.searchButton.rac_command = self.viewModel.executeSearch;
    
    
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.viewModel.executeSearch.executing;
    
    RAC(self.loadingIndicator, hidden) = [self.viewModel.executeSearch.executing not];  // 反转信号的not操作

    // executionSignals 是 信号的信号，每当创建和发出一个新的命令执行信号时，键盘就被隐藏起来。
    [self.viewModel.executeSearch.executionSignals subscribeNext:^(id x) {
        [self.searchTextField resignFirstResponder];
    }];

}




@end
