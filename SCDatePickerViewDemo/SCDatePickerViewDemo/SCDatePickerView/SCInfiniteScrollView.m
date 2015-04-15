//
//  SCInfiniteScrollView.m
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-2.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import "SCInfiniteScrollView.h"


@interface SCInfiniteScrollView ()



@end

@implementation SCInfiniteScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - methods
- (void)setScDelegate:(id<SCInfiniteScrollViewDelegate>)scDelegate {
    if (_scDelegate != scDelegate) {
        _scDelegate = scDelegate;
        [self reloadData];
    }
}

- (BOOL)hasScrollHalfWithOffsetY:(CGFloat)offsetY {
    return ((float)offsetY > 1.5 * (float)_eachItemHeight) || ((float)offsetY < 0.5 * (float)_eachItemHeight);
}

- (BOOL)hasScrollOneItemWithOffsetY:(CGFloat)offsetY {
    return ((offsetY > 2 * _eachItemHeight) || (offsetY < 0));
}

- (BOOL)canUpdateContentWithOffsetY:(CGFloat)offsetY isEndScroll:(BOOL)isEndScroll {
    if (offsetY == _eachItemHeight) {
        return NO;
    }
    BOOL hasScrollOneOrHalfItem = NO;
    if (isEndScroll) {
        hasScrollOneOrHalfItem = [self hasScrollHalfWithOffsetY:offsetY];
    } else {
        hasScrollOneOrHalfItem = [self hasScrollOneItemWithOffsetY:offsetY];
    }
    if (!hasScrollOneOrHalfItem) {
        return NO;
    }
    return YES;
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDetect:scrollView isEndScroll:NO];
    if (scrollView.contentOffset.y != _eachItemHeight) {
        [self setContentOffset:CGPointMake(0, _eachItemHeight) animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollViewDetect:scrollView isEndScroll:NO];
}

//isEndScroll现在不用到，暂时都设为NO
- (void)scrollViewDetect:(UIScrollView*)scrollView isEndScroll:(BOOL)isEndScroll {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ([self canUpdateContentWithOffsetY:(float)offsetY isEndScroll:isEndScroll] == NO) {
        return;
    }
    
    InfiniteScrollType infiniteType = InfiniteScrollTypeEqual;
    if (offsetY > _eachItemHeight) {//向上滑动（手指往上拖）
        
        infiniteType = InfiniteScrollTypeUp;
//        [self loadViewWithTag:0 inPage:_itemNum - 1];
    } else if (offsetY < _eachItemHeight) {//向下滑动（手指往下拖）
        
        infiniteType = InfiniteScrollTypeDown;
//        [self loadViewWithTag:_itemNum - 1 inPage:0];
    }
    
    int firstViewIndex = (infiniteType == InfiniteScrollTypeUp ?  0 : (infiniteType == InfiniteScrollTypeDown ? _itemNum - 1 : -1));
    if (firstViewIndex == -1) {
        return;
    }
    [self setContentOffset:CGPointMake(0, _eachItemHeight) animated:isEndScroll];
    [self updateViewContent:infiniteType];
}

- (void)updateViewContent:(InfiniteScrollType)infiniteScrollType {
    if ([self.scDelegate respondsToSelector:@selector(SCInfiniteScrollView:viewForItemAtIndex:infiniteScrollType:)]) {
        for (int i = 0; i < _itemNum; i++) {
            [self.scDelegate SCInfiniteScrollView:self viewForItemAtIndex:i infiniteScrollType:infiniteScrollType];
        }
    }
}

//- (void)loadViewWithTag:(int)viewTag inPage:(int)page {
//    //    return;
//    //    UIView *view = [_itemsViewArray objectAtIndex:viewIndex];
//    //    [_itemsViewArray removeObjectAtIndex:viewIndex];
//    //    [_itemsViewArray addObject:view];
//    //
//    //    [_itemsViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//    //        UIView *objView = (UIView*)obj;
//    //        CGRect frame = objView.frame;
//    //        frame.origin.y = idx * _eachItemHeight;
//    //        objView.frame = frame;
//    //    }];
//    //    UIView *view = (UIView*)[_itemsViewArray objectAtIndex:viewIndex];
//    UIView *view = (UIView*)[self viewWithTag:viewTag];
//    CGRect frame = view.frame;
//    frame.origin.y = page * _eachItemHeight;
//    view.frame = frame;
//}

#pragma mark - delegate
- (void)reloadData {
    if (!self.scDelegate) {
        NSLog(@"has not set scDelegate");
        return;
    }
    
    if ([self.scDelegate respondsToSelector:@selector(eachItemHeightInSCInfiniteScrollView:)]) {
        self.eachItemHeight = [self.scDelegate eachItemHeightInSCInfiniteScrollView:self];
    }
    _itemNum = floorf(self.frame.size.height / _eachItemHeight) + 2;//2是上下两个
    
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *tmpView = (UIView*)obj;
            if (tmpView.tag >= kTagInfiniteItemView) {
                [tmpView removeFromSuperview];
                tmpView = nil;
            }
        }
    }];
    if ([self.scDelegate respondsToSelector:@selector(SCInfiniteScrollView:viewForItemAtIndex:infiniteScrollType:)]) {
        for (int i = 0; i < _itemNum; i++) {
            UIView *aView = [self.scDelegate SCInfiniteScrollView:self viewForItemAtIndex:i infiniteScrollType:InfiniteScrollTypeEqual];
            aView.frame = CGRectMake(0, i * _eachItemHeight, self.frame.size.width, _eachItemHeight);
            [self addSubview:aView];
            if (i == _itemNum / 2) {//中间的view
                self.centerView = aView;
            }
        }
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, _eachItemHeight * _itemNum);
    [self setContentOffset:CGPointMake(0, _eachItemHeight) animated:NO];
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
