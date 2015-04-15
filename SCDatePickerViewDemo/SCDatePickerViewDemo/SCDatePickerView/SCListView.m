//
//  SCListView.m
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-1.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import "SCListView.h"

#define kDefaultItemHeight  44

@interface SCListView ()

//data
@property (nonatomic, assign) CGFloat currOffsetY;
@property (nonatomic, assign) int firstVisibleIndex;
@property (nonatomic, assign) int lastVisibleIndex;
@property (nonatomic, assign) int itemsNum;

//view
@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation SCListView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:SCListViewTypeTableView];
}

- (id)initWithFrame:(CGRect)frame type:(SCListViewType)type {
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    self.type = type;
    
    _itemViewArray = [[NSMutableArray alloc] init];
    _firstVisibleIndex = 0;
    
    return self;
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY == _currOffsetY) {
        return;
    }
    BOOL isScrollUp = (offsetY > _currOffsetY ? YES : NO);
    
    int index = (isScrollUp ? _firstVisibleIndex : _lastVisibleIndex);
    CGFloat firstVisibleItemH = [self.scDelegate SCListView:self heightForItemAtIndex:index];
    //计算是否滑动了一行了
    BOOL hasScrollOneItem = fabsf(offsetY - _currOffsetY - firstVisibleItemH > 0);
    _currOffsetY = offsetY;
    
    if (!hasScrollOneItem) {
        return;
    }
    
    
    if (isScrollUp) {//向上滑动（手指往上拖）
        switch (_type) {
            case SCListViewTypeTableView:
            {//to do
                break;
            }
            case SCListViewTypeInfinityScroll:
            {
                _firstVisibleIndex++;
                _firstVisibleIndex = _firstVisibleIndex % _itemsNum;
                _lastVisibleIndex++;
                _lastVisibleIndex = _lastVisibleIndex % _itemsNum;
                [_itemViewArray exchangeObjectAtIndex:0 withObjectAtIndex:([_itemViewArray count] - 1)];
                //                if (<#condition#>) {
                //                    <#statements#>
                //                }
                [self reloadData];
                break;
            }
            default:
                break;
        }
    } else {//向下滑动（手指往下拖）
        switch (_type) {
            case SCListViewTypeTableView:
            {
                break;
            }
            case SCListViewTypeInfinityScroll:
            {
                _firstVisibleIndex--;
                _firstVisibleIndex = _firstVisibleIndex % _itemsNum;
                _lastVisibleIndex--;
                _lastVisibleIndex = _lastVisibleIndex % _itemsNum;
                [_itemViewArray exchangeObjectAtIndex:0 withObjectAtIndex:([_itemViewArray count] - 1)];
                [self reloadData];
                break;
            }
            default:
                break;
        }
    }
    _currOffsetY = offsetY;
}

//- (int)getIndexForScrollViewPosition:(UIScrollView *)scrollView {
//
//    CGFloat offsetContentScrollView = (scrollView.frame.size.height - kSCDatePickerItemHeight) / 2.0;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat index = floorf((offsetY + offsetContentScrollView) / kSCDatePickerItemHeight);
//    //    index = (index - 1);
//    return index;
//}

#pragma mark -
- (void)setScDelegate:(id<SCListViewDelegate>)scDelegate {
    if (_scDelegate != scDelegate) {
        _scDelegate = scDelegate;
        [self reloadData];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
}

#pragma mark - delegate
- (void)reloadData {
    if (!self.scDelegate) {
        NSLog(@"has not set scDelegate");
        return;
    }
    if (_type == SCListViewTypeTableView) {
        //to do
    } else if (_type == SCListViewTypeInfinityScroll) {
        
    }
    _itemsNum = [self.scDelegate numberOfItemsInSCListView:self];
    
    CGFloat visibleItemsHeight = 0;
    int visibleItemNum = 0;
    int visibleItemIndex = _firstVisibleIndex;
    while (visibleItemsHeight < self.frame.size.height) {
        //
        visibleItemNum++;
        //
        visibleItemsHeight += [self.scDelegate SCListView:self heightForItemAtIndex:visibleItemIndex];
        visibleItemIndex++;
        visibleItemIndex = visibleItemIndex % _itemsNum;
    }
    _lastVisibleIndex = visibleItemIndex - 1;
    
    
    //    int index = -1;
    //    if ([self.scDelegate respondsToSelector:@selector(numberOfItemsInSCListView:)]) {
    //        index = [self.scDelegate numberOfItemsInSCListView:self];
    //    }
    //    if (index < 0) {
    //        NSLog(@"boom!! items num < 0");
    //        return;
    //    }
    CGFloat contentH = 0;
    [_itemViewArray removeAllObjects];
    for (int i = _firstVisibleIndex; i < visibleItemNum; i++) {
        
        //content height
        CGFloat currentH = kDefaultItemHeight;
        if ([self.scDelegate respondsToSelector:@selector(SCListView:heightForItemAtIndex:)]) {
            currentH = [self.scDelegate SCListView:self heightForItemAtIndex:i];
        }
        
        //item view
        if ([self.scDelegate respondsToSelector:@selector(SCListView:viewForItemAtIndex:)]) {
            UIView *itemView = [self.scDelegate SCListView:self viewForItemAtIndex:i];
            itemView.frame = CGRectMake(0, contentH, self.frame.size.width, currentH);
            [self addSubview:itemView];
            [_itemViewArray addObject:itemView];
        }
        
        contentH += currentH;
    }
    if (_type == SCListViewTypeTableView) {
        contentH = 0;
        for (int i = 0; i < _itemsNum; i++) {
            CGFloat currentH = kDefaultItemHeight;
            if ([self.scDelegate respondsToSelector:@selector(SCListView:heightForItemAtIndex:)]) {
                currentH = [self.scDelegate SCListView:self heightForItemAtIndex:i];
            }
            contentH += currentH;
        }
    }
    self.contentSize = CGSizeMake(self.frame.size.width, contentH);
}

- (UIView*)dequeueReusableView {
    if (_firstVisibleIndex > 0) {
        UIView *reusableView = [_itemViewArray objectAtIndex:_firstVisibleIndex - 1];
        if (reusableView) {
            [_itemViewArray removeObject:reusableView];
        }
        return reusableView;
    }
    return nil;
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
