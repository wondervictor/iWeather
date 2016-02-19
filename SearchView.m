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
#import "PMView.h"
#import "LifeView.h"

@interface SearchView()<UITableViewDataSource,UITableViewDelegate>
{
    // Part1
    UILabel *cityName;
    UILabel *dateLabel;
    UILabel *tempLabel;
    UIImageView *imageView;
    UILabel *weatherLabel;
    UILabel *airLabel;
    UILabel *windLabel;
    
    // Part2
    UILabel *infoLabel;  // 标题显示
    UILabel *sunriseLabel;
    UILabel *sunsetLabel;
    UILabel *uvrayLabel;
    UILabel *humidtyLabel;
    
    
}

@property (nonatomic, strong) NSArray *listWeekWeather;
@property (nonatomic, assign) CGFloat proportion;
@property (nonatomic, assign) NSString *city;

@end

@implementation SearchView

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor colorWithRed:53/255.0 green:218/255.0 blue:244/255.0 alpha:1];
        if (DEVICE_WIDTH == 320) {
            _proportion = 1.0;
        }
        else if (DEVICE_WIDTH == 375) {
            _proportion = 375/320.0;
        }
        else if (DEVICE_WIDTH == 414) {
            _proportion = 414/320.0;
        }
        
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 280) style:UITableViewStylePlain ];
        self.tableView.center = CGPointMake(WIDTH/2.0,30+170*_proportion + 140.0);

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
    
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 170*proportion)];
    
    container.backgroundColor = [UIColor colorWithRed:53/255.0 green:218/255.0 blue:244/255.0 alpha:1];
    container.layer.cornerRadius = 5.0f;
    
    RealTimeWeather *realTime = [[RealTimeWeather alloc]init];
    realTime = [dict valueForKey:@"realtime"];
    
    tempLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(20,10, 100, 80) withProportion:proportion]];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:75.0];
    tempLabel.adjustsFontSizeToFitWidth = YES;
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.text = realTime.weatherTemp;
    tempLabel.text = realTime.weatherTemp;
    [container addSubview:tempLabel];       //  addSubView

    cityName = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(20, 120*proportion+10, 80, 40) withProportion:proportion] ];
    cityName.backgroundColor = [UIColor clearColor];
    cityName.textAlignment = NSTextAlignmentCenter;
    cityName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    cityName.textColor = [UIColor blackColor];
    cityName.text = realTime.cityName;
    self.city = realTime.cityName;
    [container addSubview:cityName];
    
    imageView = [[UIImageView alloc]initWithFrame:[self CGRectMake:CGRectMake(WIDTH-100*proportion -40,20,100,100) withProportion:proportion] ];
    imageView.image = [self configureImage:realTime.img];
    [container addSubview:imageView];      //  addSubView
    
    weatherLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(20,80*proportion + 10, 80, 40) withProportion:proportion]];
    weatherLabel.textColor = [UIColor whiteColor];
    weatherLabel.textAlignment = NSTextAlignmentCenter;
    weatherLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    weatherLabel.backgroundColor = [UIColor clearColor];
    weatherLabel.text = realTime.weatherCondition;
    [container addSubview:weatherLabel];       //  addSubView
    
    LifeWeather *life = [dict valueForKey:@"life"];
    NSString *air = [life.pollution objectAtIndex:0];
    airLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(WIDTH-120*proportion-10,80*proportion + 30, 120, 30) withProportion:proportion]];
    airLabel.textAlignment = NSTextAlignmentRight;
    airLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    airLabel.backgroundColor = [UIColor clearColor];
    airLabel.textColor = [UIColor grayColor];
    airLabel.text = [NSString stringWithFormat:@"空气质量： %@",air];
    [container addSubview:airLabel];      //   addSubView
    
    windLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(WIDTH-120*proportion-10, 110*proportion + 30, 120, 30) withProportion:proportion] ];
    windLabel.textAlignment = NSTextAlignmentRight;
    windLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    windLabel.backgroundColor = [UIColor clearColor];
    windLabel.textColor = [UIColor grayColor];
    
    windLabel.text = [NSString stringWithFormat:@"%@,%@",[realTime.windCondition objectForKey:@"power" ],[realTime.windCondition objectForKey:@"direct"]];
    [container addSubview:windLabel];
    
    [self addSubview:container];
    
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 310+170*proportion, WIDTH, 70+40*proportion) ];
    infoView.backgroundColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.9];
    infoView.layer.cornerRadius = 5.0f;
    infoLabel = [[UILabel alloc]initWithFrame:[self CGRectMake:CGRectMake(WIDTH/2-60, 0, 120, 40) withProportion:proportion] ];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.text = @"天气信息";
    infoLabel.textColor = [UIColor orangeColor];
    [infoView addSubview:infoLabel];
    NSDictionary *condition = [dict valueForKey:@"condition"];
    
    sunriseLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-160,40*proportion ,150 , 30) ];
    sunriseLabel.textAlignment = NSTextAlignmentRight;
    sunriseLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
    sunriseLabel.backgroundColor = [UIColor clearColor];
    sunriseLabel.textColor = [UIColor whiteColor];
    sunriseLabel.text = [NSString stringWithFormat:@"日出：%@",[condition valueForKey:@"sunrise"]];
    [infoView addSubview:sunriseLabel];
    
    sunsetLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+10, 40*proportion, 150, 30)];
    sunsetLabel.textAlignment = NSTextAlignmentLeft;
    sunsetLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
    sunsetLabel.backgroundColor = [UIColor clearColor];
    sunsetLabel.textColor = [UIColor whiteColor];
    sunsetLabel.text = [NSString stringWithFormat:@"日落：%@",[condition valueForKey:@"sunset"]];
    [infoView addSubview:sunsetLabel];
    
    humidtyLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-160, 40*proportion+30, 150, 30) ];
    humidtyLabel.textAlignment = NSTextAlignmentRight;
    humidtyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
    humidtyLabel.backgroundColor = [UIColor clearColor];
    humidtyLabel.textColor = [UIColor whiteColor];
    humidtyLabel.text = [NSString stringWithFormat:@"湿度：%@", [condition valueForKey:@"humidty"]];
    [infoView addSubview:humidtyLabel];
    
    
    uvrayLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+10, 40*proportion+30, 150, 30)];
    uvrayLabel.textAlignment = NSTextAlignmentLeft;
    uvrayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
    uvrayLabel.backgroundColor = [UIColor clearColor];
    uvrayLabel.textColor = [UIColor whiteColor];
    uvrayLabel.text = [NSString stringWithFormat:@"紫外线：%@",[condition valueForKey:@"uvray"]];
    [infoView addSubview:uvrayLabel];
    
    [self addSubview:infoView];
    
    
    PMView *pmView = [[PMView alloc]initWithFrame:CGRectMake(0,380+210*proportion ,WIDTH ,180 ) withData:[dict valueForKey:@"pm25"]];
    pmView.layer.cornerRadius = 5.0f;
    pmView.backgroundColor = [UIColor whiteColor];
    [self addSubview:pmView];
    
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
    cell.date.text = weather.date;//  在iPhone4s上模拟有点问题。
    cell.date.textColor = [UIColor grayColor];
    cell.image.image = [self configureImage:[day objectAtIndex:0]];
    cell.temp.text = [NSString stringWithFormat:@"%@°",[day objectAtIndex:2]];
    cell.temp.textColor = [UIColor orangeColor];
    cell.weather.text = [day objectAtIndex:1];
    cell.weather.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    cell.weather.textColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (UIImage *)configureImage:(NSString *)imageNum
{
    NSInteger row = imageNum.integerValue;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ImageList" ofType:@"plist"];
    NSArray *listImage = [[NSArray alloc]initWithContentsOfFile:filePath];
    NSDictionary *dict = [listImage objectAtIndex:row];
    UIImage *image = [UIImage imageNamed:[dict valueForKey:@"Img"]];
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
