//
//  SCInfiniteScrollView.m
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-2.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import "SCInfiniteScrollView.h"

#define kDefaultItemHeight  44

@interface SCInfiniteScrollView ()

//data
@property (nonatomic, assign) CGFloat currOffsetY;
@property (nonatomic, assign) int itemNum;
//@property (nonatomic, assign) int eachItemHeight;


//view
//@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation SCInfiniteScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemsViewArray = [[NSMutableArray alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setupWithEachItemHeight:(CGFloat)eachItemHeight buildBlock:(BuildInfiniteViewBlock)block {
    self.buildViewBlock = block;
    self.eachItemHeight = eachItemHeight;
    self.contentSize = CGSizeMake(self.frame.size.width, _eachItemHeight * _itemNum);
    [self setContentOffset:CGPointMake(0, _eachItemHeight) animated:NO];
}

#pragma mark - methods
- (void)setScDelegate:(id<SCInfiniteScrollViewDelegate>)scDelegate {
    if (_scDelegate != scDelegate) {
        _scDelegate = scDelegate;
    }
}

- (void)setEachItemHeight:(CGFloat)eachItemHeight {
    if (eachItemHeight != _eachItemHeight) {
        _eachItemHeight = eachItemHeight;
        
        _itemNum = floorf(self.frame.size.height / eachItemHeight) + 2;//2是上下两个
        
        if (self.buildViewBlock) {
            [_itemsViewArray removeAllObjects];
            for (int i = 0; i < _itemNum; i++) {
                self.buildViewBlock(_itemsViewArray);
            }
        }
    }
}

- (BOOL)canUpdateContentWithOffsetY:(CGFloat)offsetY {
    if (offsetY == _eachItemHeight) {
        return NO;
    }
    BOOL hasScrollOneItem = ((offsetY > 2 * _eachItemHeight) || (offsetY <= 0));
    if (!hasScrollOneItem) {
        return NO;
    }
    return YES;
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if ([self canUpdateContentWithOffsetY:offsetY] == NO) {
//        return;
//    }
//    
//    BOOL isScrollUp = (offsetY > _eachItemHeight);
//    [self updateViewContent:isScrollUp];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ([self canUpdateContentWithOffsetY:offsetY] == NO) {
        return;
    }
    
    BOOL isScrollUp = (offsetY > _eachItemHeight);
    if (isScrollUp) {//向上滑动（手指往上拖）
        [self loadView:0 inPage:_itemNum - 1];
    } else {//向下滑动（手指往下拖）
        [self loadView:_itemNum - 1 inPage:0];
    }
    [self setContentOffset:CGPointMake(0, _eachItemHeight) animated:NO];
    [self updateViewContent:isScrollUp];
}

- (void)updateViewContent:(BOOL)isScrollUp {
    [_itemsViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (self.fillDataBlock) {
            self.fillDataBlock(_itemsViewArray, idx, isScrollUp);
        }
    }];
}

- (void)loadView:(int)viewIndex inPage:(int)page {
    UIView *view = (UIView*)[_itemsViewArray objectAtIndex:viewIndex];
    CGRect frame = view.frame;
    frame.origin.y = page * _eachItemHeight;
    view.frame = frame;
}

#pragma mark - delegate
- (void)reloadData {
    if (!self.scDelegate) {
        NSLog(@"has not set scDelegate");
        return;
    }
    
    
//    CGFloat visibleItemsHeight = 0;
//    int visibItemNum = 0;
//    while (visibleItemsHeight < self.frame.size.height) {
//        visibleItemsHeight += [self.scDelegate SCInfiniteScrollView:self heightForItemAtIndex:visibItemNum];
//        visibItemNum++;
//    }
//    
//    CGFloat contenteH = 0;
//    _itemNum = [self.scDelegate numberOfItemsInSCInfiniteScrollView:self];
//    for (int i = 0; i < _itemNum; i++) {
//        CGFloat currItemH = [self.scDelegate SCInfiniteScrollView:self heightForItemAtIndex:i];
//        
//        //item view
//        UIView *itemView = [self.scDelegate SCInfiniteScrollView:self viewForItemAtIndex:i];
//        itemView.frame = CGRectMake(0, contenteH, self.frame.size.width, currItemH);
//        
//        //scrollview content height
//        contenteH += currItemH;
//        
//        [self addSubview:itemView];
//        [_itemsViewArray addObject:itemView];
//    }
//    if (contenteH < self.frame.size.height) {
//        NSLog(@"too short...");
//        return;
//    }
//    self.contentSize = CGSizeMake(self.frame.size.width, contenteH);
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
