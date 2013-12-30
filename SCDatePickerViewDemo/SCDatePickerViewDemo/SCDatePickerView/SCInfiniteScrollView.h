//
//  SCInfiniteScrollView.h
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-2.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTagInfiniteItemView            10

//typedef void(^BuildInfiniteViewBlock)(NSMutableArray *itemsArray);
//typedef void(^FillDataBlock)(NSMutableArray *itemsArray, int index, BOOL isScrollUp);

typedef enum {
    InfiniteScrollTypeUp        =   0,
    InfiniteScrollTypeDown      =   1,
    InfiniteScrollTypeEqual     =   2
} InfiniteScrollType;

@protocol SCInfiniteScrollViewDelegate;


@interface SCInfiniteScrollView : UIScrollView <UIScrollViewDelegate>


@property (nonatomic, assign) id<SCInfiniteScrollViewDelegate> scDelegate;
@property (nonatomic, assign) CGFloat eachItemHeight;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, assign) int itemNum;

- (void)reloadData;

@end




@protocol SCInfiniteScrollViewDelegate <NSObject>

@required
//每个view的高
- (CGFloat)eachItemHeightInSCInfiniteScrollView:(SCInfiniteScrollView*)scrollview;

//给所有view赋值
- (UIView*)SCInfiniteScrollView:(SCInfiniteScrollView*)scrollview viewForItemAtIndex:(NSInteger)index infiniteScrollType:(InfiniteScrollType)infiniteScrollType;

@end
