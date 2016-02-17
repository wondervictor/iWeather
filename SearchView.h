//
//  SearchView.h
//  iWeather
//
//  Created by VicChan on 16/2/17.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

- (void)addNewCity:(NSString *)cityName;

@end

@interface SearchView : UIView

@property (nonatomic, weak) id<SearchViewDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *addBtn;

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)dict;

@end
