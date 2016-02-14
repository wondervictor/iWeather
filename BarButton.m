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
        _touched = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touched == NO) {
        if ([_delegate respondsToSelector:@selector(barButtonFirstPress:)]) {
            [_delegate barButtonFirstPress:self];
        }
    }
    else if (_touched == YES) {
        if ([_delegate respondsToSelector:@selector(barButtonSecondPress:)]) {
            [_delegate barButtonSecondPress:self];
        }
    }

    self.highlighted = YES;
}

- (BOOL)isTouched {
    return _touched;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touched) {
        _touched = NO;
        self.highlighted = NO;
    }
    else if (_touched == NO) {
        _touched = YES;
         self.titleLabel.textColor = [UIColor orangeColor];
    }
    
}
    
/*
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

*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
