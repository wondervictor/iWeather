//
//  BarButton.m
//  iWeather
//
//  Created by VicChan on 16/2/13.
//  Copyright © 2016年 VicChan. All rights reserved.
//

#import "BarButton.h"

@implementation BarButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.barLabel.textColor = [UIColor orangeColor];
    if ([_delegate respondsToSelector:@selector(BarButtonPress:)]) {
        [_delegate BarButtonPress:self];

    }
    self.highlighted = YES;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}

- (void)layoutSubviews {

        [super layoutSubviews];
        
        // Center image
        CGPoint center = self.imageView.center;
        center.x = self.frame.size.width/2;
        center.y = self.imageView.frame.size.height/2;
        self.imageView.center = center;
        CGRect frame = self.imageView.frame;
        CGFloat h = frame.size.height;
        frame.size.height = h - 20;
        [self.imageView setFrame:frame];
    
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //Center text
        CGRect newFrame = [self titleLabel].frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.imageView.frame.size.height + 5;
        newFrame.size.width = self.frame.size.width;
        
        self.titleLabel.frame = newFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
