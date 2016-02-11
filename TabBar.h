//
//  TabBar.h
//  iWeather
//
//  Created by VicChan on 16/2/10.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "subButton.h"

#import <UIKit/UIKit.h>

@protocol TabBarDelegate <NSObject>
- (void)touchAtIndex:(NSInteger)index;

- (void)centerButtonClick;
- (void)subButton_0_Action;     // 搜索
- (void)subButton_1_Action;     // 整理
- (void)subButton_2_Action;     // about me

@end


@interface TabBar : UIView<subButtonDelegate>
{
    CGPoint kSubButtonBirthLocation;
    CGPoint kSubButtonFinalLocation;
    CGPoint kSubButton_0_AppearLocation;
    CGPoint kSubButton_1_AppearLocation;
    CGPoint kSubButton_2_AppearLocation;

}

@property (nonatomic, weak) id<TabBarDelegate> delegate;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) subButton *subBtn;
@property (nonatomic, strong) NSMutableArray *subButtons;
@property (nonatomic, strong) NSMutableArray *tabButtons;

@property (nonatomic, getter = isExpanded) BOOL expanded;
@property (nonatomic) CGFloat totalRadius;
@property (nonatomic) CGFloat centerRadius;
@property (nonatomic) CGFloat subRadius;
@property (nonatomic) CGFloat centerLocationX;
@property (nonatomic) CGFloat centerLocationY;
@property (nonatomic) NSString *centerImage;


- (id)initTabBarWithFrame:(CGRect)frame
          withTotalRadius:(CGFloat)totalRadius
             centerRadius:(CGFloat)centerRadius
                subRadius:(CGFloat)subRadius
              centerImage:(NSString *)centerImage
                subImages:(void(^)(TabBar *))imageBlock
                locationX:(CGFloat)locationXAxis
                locationY:(CGFloat)locationYAxis;

- (void)subButtonImage:(NSString *)imageName withTag:(NSInteger)tag;



@end
