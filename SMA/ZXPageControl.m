//
//  ZXPageControl.m
//  AAAA
//
//  Created by 有限公司 深圳市 on 2016/10/19.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "ZXPageControl.h"

//static const CGFloat    ZXAutoRollTimeIntervalDefault       = 3.f;
//static const CGFloat    ZXAutoRollTimeIntervalMin           = 1.599999f;
//static const CGFloat    ZXAutoRollTimeIntervalMax           = 6.000001f;
//static const CGFloat    ZXInteritemSpacingDefault           = 8.f;
//static const CGFloat    ZXIndicatorToBottomSpacingDefault   = 8.f;
//static const CGFloat    ZXSystemIndicatorSide               = 7.f;
//static const CGFloat    ZXTimerCycle                        = 0.2f;
//
//// only for indicatorImage
//static const CGFloat    ZXIndicatorSideMin                  = 4.f;
//static const CGFloat    ZXIndicatorSideMax                  = 18.f;
static const CGFloat    ZXIndicatorInteritemSpacing         = 8.f;

typedef NS_ENUM(NSUInteger, ZXRollViewIndicatorStyle) {
    ZXRollViewIndicatorStyleColor = 1,
    ZXRollViewIndicatorStyleImage,
};

@implementation ZXPageControl
- (ZXPageControl *)initWithPageIndicatorImage:(UIImage *)pageIndicatorImage currentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        _imgViews = [[NSMutableArray alloc] init];
        _pageIndicatorImage = pageIndicatorImage;
        _currentPageIndicatorImage = currentPageIndicatorImage;
    }
    return self;
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    if (self.numberOfPages < numberOfPages) {
        for (NSInteger i = self.numberOfPages; i < numberOfPages; i ++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            [self addSubview:imgView];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [self.imgViews addObject:imgView];
        }
    }
    else {
        for (NSInteger i = 0; i < self.numberOfPages - numberOfPages; i ++) {
            [[self.imgViews lastObject] removeFromSuperview];
            [self.imgViews removeLastObject];
        }
    }
    _numberOfPages = numberOfPages;
    
    CGFloat wIndicator = self.numberOfPages * (ZXIndicatorInteritemSpacing + self.frame.size.height) - ZXIndicatorInteritemSpacing;
    CGFloat xLocFirstImgView = (self.frame.size.width - wIndicator) / 2;
    for (NSInteger i = 0; i < self.numberOfPages; i ++) {
        self.imgViews[i].frame = CGRectMake(xLocFirstImgView + i * (ZXIndicatorInteritemSpacing + self.frame.size.height),
                                            0,
                                            self.frame.size.height,
                                            self.frame.size.height);
        self.imgViews[i].image = i == self.currentPage ? self.currentPageIndicatorImage : self.pageIndicatorImage;
    }
    self.hidden = (self.hidesForSinglePage && self.numberOfPages == 1) || self.numberOfPages == 0;
    
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    if (self.numberOfPages > 0) {
        if (_currentPage < self.imgViews.count) {
            self.imgViews[_currentPage].image = self.pageIndicatorImage;
        }
        self.imgViews[currentPage].image = self.currentPageIndicatorImage;
        _currentPage = currentPage;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
