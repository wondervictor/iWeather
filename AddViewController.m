//
//  AddViewController.m
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray *list;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.list = @[@"one",@"two",@"three"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
    
    return cell;
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
