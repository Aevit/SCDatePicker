//
//  SCListView.h
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-1.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCListViewTypeTableView         =   0,
    SCListViewTypeInfinityScroll    =   1
} SCListViewType;

@protocol SCListViewDelegate;

@interface SCListView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) id<SCListViewDelegate> scDelegate;
@property (nonatomic, assign) SCListViewType type;

- (id)initWithFrame:(CGRect)frame type:(SCListViewType)type;

@end





@protocol SCListViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInSCListView:(SCListView*)listView;
- (UIView*)SCListView:(SCListView*)listView viewForItemAtIndex:(NSInteger)index;

@optional
- (CGFloat)SCListView:(SCListView*)listView heightForItemAtIndex:(NSInteger)index;

@end
