//
//  ViewController.m
//  UserDataCenterDemo
//
//  Created by ZYY on 16/5/4.
//  Copyright © 2016年 ZYY. All rights reserved.
//

#import "ViewController.h"
#import "ZYCollectDataManager.h"
#import "ZYHistoryDataManager.h"
#import "ZYCollectData.h"
#import "ZYHistoryData.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *historyPageNum;
@property (weak, nonatomic) IBOutlet UITextField *historyProgramNum;
@property (weak, nonatomic) IBOutlet UITextField *historyName;
@property (weak, nonatomic) IBOutlet UITextField *collectPageNum;
@property (weak, nonatomic) IBOutlet UITextField *collectName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];//注意是UITapGestureRecognizer
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.view removeGestureRecognizer:tapGestureRecognizer];}];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getHistoryData:(id)sender {
    NSArray *historyData = [[ZYHistoryDataManager sharedInstance] getDataWithPageNum:[self.historyPageNum.text intValue]];
    NSLog(@"历史数据:%@",historyData);
}

- (IBAction)addHistoryData:(id)sender {
    ZYHistoryData *data = [[ZYHistoryData alloc] init];
    data.programNum = self.historyProgramNum.text;
    data.programName = self.historyName.text;
    [[ZYHistoryDataManager sharedInstance] addData:data];
}

- (IBAction)deleteHistoryData:(id)sender {
    ZYHistoryData *data = [[ZYHistoryData alloc] init];
    data.programNum = self.historyProgramNum.text;
    data.programName = self.historyName.text;
    [[ZYHistoryDataManager sharedInstance] deleteData:data];
}

- (IBAction)getCollectData:(id)sender {
    NSArray *collectData = [[ZYCollectDataManager sharedInstance] getDataWithPageNum:[self.collectPageNum.text intValue]];
    NSLog(@"收藏数据:%@",collectData);
}
- (IBAction)addCollectData:(id)sender {
    ZYCollectData *data = [[ZYCollectData alloc] init];
    data.programName = self.historyName.text;
    [[ZYCollectDataManager sharedInstance] addData:data];
}
- (IBAction)deleteCollectData:(id)sender {
    ZYCollectData *data = [[ZYCollectData alloc] init];
    data.programName = self.historyName.text;
    [[ZYCollectDataManager sharedInstance] deleteData:data];
}

- (void)backgroundTap:(id)sender {
    [self.historyPageNum resignFirstResponder];
    [self.historyProgramNum resignFirstResponder];
    [self.historyName resignFirstResponder];
    [self.collectName resignFirstResponder];
    [self.collectPageNum resignFirstResponder];
}

@end
