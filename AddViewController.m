//
//  AddViewController.m
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#define WIDTH   self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height
#define DEFAULT_COLOR [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]



#import "AddViewController.h"
#import "SearchViewController.h"


@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) NSMutableArray *cityList;
@property (nonatomic, strong) SearchViewController *searchViewController;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DEFAULT_COLOR;
    self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0,WIDTH , 64)];
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@""];
    self.navigationBar.tintColor = [UIColor orangeColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addItems:)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItems:)];
    [[UINavigationBar appearance]setBarTintColor:DEFAULT_COLOR];
    [item setTitle:@"iWeather城市列表"];
    [item setLeftBarButtonItem:leftBtn];
    [item setRightBarButtonItem:rightBtn];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    [self.navigationBar pushNavigationItem:item animated:YES];
    [self.view addSubview:self.navigationBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addItemsToArray:) name:@"GetNewCityNotification_1" object:nil];
    
    //NSArray *list = @[@"one",@"two",@"three"];
    self.cityList = [[NSMutableArray alloc]init];
    [self.cityList addObjectsFromArray:self.list];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    [self.view addSubview:self.tableView];
    self.searchViewController = [[SearchViewController alloc]init];
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH-60)/2.0,HEIGHT-60,60 , 60)];
    cancelBtn.backgroundColor = [UIColor cyanColor];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 30.0f;
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)cancelButtonClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"search view controller back to master view controller");
    }];
    
}

- (void)addItems:(id)sender {
    
    [self presentViewController:self.searchViewController animated:YES completion:nil];
    
}

- (void)deleteItems:(UIBarButtonItem *)sender {
    if (self.tableView.editing == YES) {
        [UIView animateWithDuration:0.4f animations:^{
            self.tableView.editing = NO;
            sender.title = @"删除";
            
        }];
    }
    else if (self.tableView.editing == NO) {
        
        [UIView animateWithDuration:0.4f animations:^{
            self.tableView.editing = YES;
            sender.title = @"取消";

        }];
    }
}

- (void)addItemsToArray:(NSNotification *)notification {
    NSString *cityName = notification.object;
    [self.cityList addObject:cityName];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.cityList objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableViewDelegate 

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DidDeleteCityNotification" object:[self.cityList objectAtIndex:indexPath.row]];
        [self.cityList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
