//
//  TabBar.h
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate <NSObject>
- (void)touchAtInde:(NSInteger)index;
@end



@interface TabBar : UIView

@end
