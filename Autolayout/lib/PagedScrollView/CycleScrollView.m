//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"
#import "UIView+Category.h"
#import "UIView+PPCategory.h"
#import "StyledPageControl.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;
@property(nonatomic , strong)StyledPageControl * pag;
@property(nonatomic , strong)UILabel * pageLabel;
@property(nonatomic, strong)UIImageView * cahceImageView;

@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView


- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        if (self.pag) {
            self.pag.numberOfPages = (int)_totalPageCount;
        }
        if (self.pageLabel) {
            self.pageLabel.text = [NSString stringWithFormat:@"1 / %ld",(long)_totalPageCount];
        }
        if (_totalPageCount > 1) {
            [self configContentViews];
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        }
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration Style:(CycleStyle)Style andImageCount:(NSInteger)count
{
    self = [self initWithFrame:frame animationDuration:animationDuration];
    [self initScrollView_Count:count];
    
    if (Style == PageStyle) {
        self.pag = [[StyledPageControl alloc] initWithFrame:CGRectMake(self.x + 85, self.height - 30, 14*count, 10)];
        [self.pag setPageControlStyle:PageControlStyleThumb];
        self.pag.selectedThumbImage = [UIImage imageNamed:@"首页－活动banner上的当前轮播点"];
        self.pag.thumbImage = [UIImage imageNamed:@"首页－活动banner上的轮播点"];
        self.pag.center = CGPointMake(self.width/2, frame.size.height - 15);
        self.pag.right = frame.size.width-15;
        [self addSubview:self.pag];
    }else
    {
        self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
        self.pageLabel.right = self.width - 10;
        self.pageLabel.textAlignment = NSTextAlignmentRight;
        self.pageLabel.bottom = self.height - 10;
        self.pageLabel.textColor = [UIColor whiteColor];
        self.pageLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
        self.pageLabel.text = @"1 / 1";
        [self addSubview:self.pageLabel];
    }
    
    return self;
}

-(void)initScrollView_Count:(NSInteger)count
{
    self.autoresizesSubviews = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.autoresizingMask = 0xFF;
    self.scrollView.contentMode = UIViewContentModeCenter;
    if (count > 1) {
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    }else
    {
        self.scrollView.contentSize = CGSizeMake(count * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = nil;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initImageData];
        });
    }
    
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    self.currentPageIndex = 0;
}

//3张以下的图片的初始化
-(void)initImageData
{
    self.contentViews = [NSMutableArray array];
    for (int i = 0 ; i < self.totalPageCount; i++) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(i)];
    }
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * counter, 0);
        counter++;
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    if (self.pageLabel) {
        self.pageLabel.text = [NSString stringWithFormat:@"%ld / %ld",(long)self.currentPageIndex+1,(long)_totalPageCount];
    }
    if (self.pag) {
        self.pag.currentPage = self.currentPageIndex;
    }
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    if (self.totalPageCount == 2) {
        NSInteger counter = 0;
        for (UIView *contentView in self.contentViews) {
            CGRect rightRect = contentView.frame;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            if (self.cahceImageView == nil) {
                self.cahceImageView = [[UIImageView alloc] initWithFrame:rightRect];
                self.cahceImageView.userInteractionEnabled = YES;
            }
            if (counter == 0) {
                self.cahceImageView.image = [(UIImageView *)contentView image];
                [self.cahceImageView addGestureRecognizer:tapGesture];
                rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
                self.cahceImageView.frame = rightRect;
                [self.scrollView addSubview:self.cahceImageView];
            }else
            {
                contentView.userInteractionEnabled = YES;
                [contentView addGestureRecognizer:tapGesture];
                rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
                contentView.frame = rightRect;
                [self.scrollView addSubview:contentView];
            }
        }
    }else
    {
        NSInteger counter = 0;
        for (UIView *contentView in self.contentViews) {
            contentView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
            [contentView addGestureRecognizer:tapGesture];
            CGRect rightRect = contentView.frame;
            rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
            contentView.frame = rightRect;
            [self.scrollView addSubview:contentView];
        }
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        if (self.fetchContentViewAtIndex(previousPageIndex)) {
            [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        }
        if (self.fetchContentViewAtIndex(_currentPageIndex)) {
            [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        }
        if (self.fetchContentViewAtIndex(rearPageIndex)) {
            [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
        }
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
