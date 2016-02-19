//
//  SearchView.h
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SearchView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *addBtn;

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict;

@end
