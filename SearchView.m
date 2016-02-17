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


@property (nonatomic, assign) CGFloat proportion;
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
        
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([weekViewCell class]) bundle:nil] forCellReuseIdentifier:@"weekCell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        
    }
    return self;
}

- (void)configureViews:(NSDictionary *)dict withProportion:(CGFloat)proportion {
    
    
    
    
    
    
    
}

- (CGRect)CGRectMake:(CGRect)rect withProportion:(CGFloat)proportion {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * proportion, rect.size.height * proportion);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
