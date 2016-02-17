//
//  SearchView.m
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//
//  iPhone4s/4/5/5s  W:320
//  iPhone6/6s       W:375
//  iPhone6+/6s+     W:414

#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width

#define WIDTH   self.frame.size.width
#define HEIGHT  self.frame.size.height


//  Model
#import "RealTimeWeather.h"
#import "WeekWeather.h"
#import "LifeWeather.h"


//  View
#import "weekViewCell.h"
#import "SearchView.h"

@interface SearchView()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *cityName;
    UILabel *dateLabel;
    UILabel *tempLabel;
    UIImageView *imageView;
    UILabel *weatherLabel;
    UILabel *airLabel;

}

@property (nonatomic, strong) NSArray *listWeekWeather;
@property (nonatomic, assign) CGFloat proportion;
@property (nonatomic, assign) NSString *city;

@end

@implementation SearchView

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict {
    if (self = [super initWithFrame:frame]) {
        if (DEVICE_WIDTH == 320) {
            _proportion = 1.0;
        }
        else if (DEVICE_WIDTH == 375) {
            _proportion = 375/320.0;
        }
        else if (DEVICE_WIDTH == 414) {
            _proportion = 414/320.0;
        }
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 350) style:UITableViewStylePlain ];
        self.tableView.center = CGPointMake(WIDTH/2.0,40 + 160*_proportion + 175.0 );

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.listWeekWeather = [dict valueForKey:@"week"];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([weekViewCell class]) bundle:nil] forCellReuseIdentifier:@"weekCell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        
        [self configureViews:dict withProportion:_proportion];
        
        
        
    }
    return self;
}

- (void)configureViews:(NSDictionary *)dict withProportion:(CGFloat)proportion {
    NSLog(@"%@",dict);
    RealTimeWeather *realTime = [[RealTimeWeather alloc]init];
    realTime = [dict valueForKey:@"realtime"];
    NSLog(@"%@",realTime.cityName);
    cityName = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(10, 10, 70, 40) withProportion:proportion] ];
    cityName.backgroundColor = [UIColor clearColor];
    cityName.textAlignment = NSTextAlignmentLeft;
    cityName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    cityName.textColor = [UIColor whiteColor];
    //cityName.text = @"宜昌" ;
    cityName.text = realTime.cityName;
    self.city = realTime.cityName;
    [self addSubview:cityName];       //  addSubView
    
    self.addBtn = [[UIButton alloc]initWithFrame:[self CGRectMake:CGRectMake(WIDTH - 70,10, 40, 40) withProportion:proportion] ];
    self.addBtn.layer.cornerRadius = 20.0*proportion ;
    self.addBtn.layer.masksToBounds = YES;
    [self.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchDown];   //  touchUpInside   touchDown
    [self addSubview:self.addBtn];  //  addSubView
    
    dateLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(10, 40*proportion+20,200, 40) withProportion:proportion] ];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.text = [NSString stringWithFormat:@"日期：%@",realTime.date];
    [self addSubview:dateLabel];      //  addSubView
    
    tempLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(10, 30+80*proportion, 80, 80) withProportion:proportion]];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:40.0];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.text = realTime.weatherTemp;
    tempLabel.text = realTime.weatherTemp;
    [self addSubview:tempLabel];       //  addSubView
    
    imageView = [[UIImageView alloc]initWithFrame:[self CGRectMake:CGRectMake(15+80*proportion,30 + 80*proportion , 40, 40) withProportion:proportion] ];
    imageView.image = [self configureImage:realTime.img];
    [self addSubview:imageView];      //  addSubView
    
    weatherLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(15+120*proportion, 30 + 80*proportion, 80, 40) withProportion:proportion]];
    weatherLabel.textColor = [UIColor whiteColor];
    weatherLabel.textAlignment = NSTextAlignmentCenter;
    weatherLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    weatherLabel.backgroundColor = [UIColor clearColor];
    weatherLabel.text = realTime.weatherCondition;
    [self addSubview:weatherLabel];       //  addSubView
    
    
    LifeWeather *life = [dict valueForKey:@"life"];
    NSString *air = [life.pollution objectAtIndex:0];
    airLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(15+80*proportion, 30+120*proportion, 120, 40) withProportion:proportion]];
    airLabel.textAlignment = NSTextAlignmentLeft;
    airLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22.0];
    airLabel.backgroundColor = [UIColor clearColor];
    airLabel.textColor = [UIColor whiteColor];
    airLabel.text = [NSString stringWithFormat:@"空气质量： %@",air];
    [self addSubview:airLabel];      //   addSubView
    
    
    
    
    
}

- (void)addBtnClick {
    [_delegate addNewCity:self.city];
}

- (void)configureLabels:(UILabel *)label {
    
    [self addSubview:label];
}

- (CGRect)CGRectMake:(CGRect)rect withProportion:(CGFloat)proportion {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * proportion, rect.size.height * proportion);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    weekViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weekCell" forIndexPath:indexPath];
    
    WeekWeather *weather = [self.listWeekWeather objectAtIndex:indexPath.row];
    NSArray *day = weather.dayWeather;
    cell.backgroundColor = [UIColor clearColor];
    cell.date.text = weather.date;   //  在iPhone4s上模拟有点问题。
    cell.image.image = [self configureImage:[day objectAtIndex:0]];
    cell.temp.text = [day objectAtIndex:2];
    cell.weather.text = [day objectAtIndex:1];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UIImage *)configureImage:(NSString *)imageNum
{
    NSInteger row = imageNum.integerValue;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ImageList" ofType:@"plist"];
    NSArray *listImage = [[NSArray alloc]initWithContentsOfFile:filePath];
    NSDictionary *dict = [listImage objectAtIndex:row];
    UIImage *image = [UIImage imageNamed:[dict valueForKey:@"img"]];
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
