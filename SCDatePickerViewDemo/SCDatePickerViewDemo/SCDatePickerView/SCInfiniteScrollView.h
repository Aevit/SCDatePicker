//
//  SCInfiniteScrollView.h
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-2.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTagInfiniteItemView            10

typedef void(^BuildInfiniteViewBlock)(NSMutableArray *itemsArray);
typedef void(^FillDataBlock)(NSMutableArray *itemsArray, int index, BOOL isScrollUp);

@protocol SCInfiniteScrollViewDelegate;


@interface SCInfiniteScrollView : UIScrollView <UIScrollViewDelegate>


@property (nonatomic, assign) id<SCInfiniteScrollViewDelegate> scDelegate;
@property (nonatomic, strong) UIView *infiniteView;
@property (nonatomic, assign) CGFloat eachItemHeight;
@property (nonatomic, strong) NSMutableArray *itemsViewArray;

@property (nonatomic, copy) BuildInfiniteViewBlock buildViewBlock;
@property (nonatomic, copy) FillDataBlock fillDataBlock;

@property (nonatomic, strong) NSMutableArray *dataArray;

//- (id)initWithFrame:(CGRect)frame eachItemHeight:(CGFloat)eachItemHeight buildBlock:(BuildInfiniteViewBlock)block;
- (void)setupWithEachItemHeight:(CGFloat)eachItemHeight buildBlock:(BuildInfiniteViewBlock)block;

- (void)setBuildViewBlock:(BuildInfiniteViewBlock)buildViewBlock;
- (void)setFillDataBlock:(FillDataBlock)fillDataBlock;

@end




@protocol SCInfiniteScrollViewDelegate <NSObject>

@required
//- (UIView*)itemViewInScrollView:(SCInfiniteScrollView*)scrollView eachItemHeight:(CGFloat)eachItemHeight;
//- (void)dataOfItemView:(UIView*)itemView SCInfiniteScrollView:(SCInfiniteScrollView*)scrollView isScrollUp:(BOOL)isScrollUp;

//- (CGFloat)eachItemHeightInSCInfiniteScrollView:(SCInfiniteScrollView*)scrollview;
//
//- (NSInteger)numberOfItemsInSCInfiniteScrollView:(SCInfiniteScrollView*)scrollview;
//
//- (UIView*)SCInfiniteScrollView:(SCInfiniteScrollView*)scrollview viewForItemAtIndex:(NSInteger)index;
//
//- (CGFloat)SCInfiniteScrollView:(SCInfiniteScrollView*)scrollview heightForItemAtIndex:(NSInteger)index;

@end
