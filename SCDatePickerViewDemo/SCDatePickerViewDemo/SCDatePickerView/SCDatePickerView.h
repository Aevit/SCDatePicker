//
//  SCDatePickerView.h
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-1.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCDatePickerViewTypeNone                =   -1,
    SCDatePickerViewTypeDateAndTime         =   0,//年-月-日 时:分
    SCDatePickerViewTypeTime                =   1,//时:分
    SCDatePickerViewTypeWeekAndTime         =   2,//周 时:分
    SCDatePickerViewTypeDayAndTime          =   3,//日 时:分
    SCDatePickerViewTypeMonthDayAndTime     =   4,//月-日 时:分
    SCDatePickerViewTypeDate                =   5//年-月-日
} SCDatePickerViewType;

@protocol SCDatePickerViewDelegate;

@interface SCDatePickerView : UIView <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

//delegate
@property (nonatomic, assign) id<SCDatePickerViewDelegate> delegate;

//data
@property (nonatomic, strong) NSDateComponents *dateComponets;
@property (nonatomic, strong) NSDate *date;

//type
@property (nonatomic, assign) SCDatePickerViewType pickerType;


- (id)initWithParentView:(UIView*)parentView;

- (id)initWithParentView:(UIView *)parentView type:(SCDatePickerViewType)type;

- (id)initWithParentView:(UIView*)parentView
                  rowNum:(int)rowNum
                withYear:(BOOL)withYear
               withMonth:(BOOL)withMonth
                 withDay:(BOOL)withDay
             withweekday:(BOOL)withweekday
                withHour:(BOOL)withHour
              withMinute:(BOOL)withMinute
              withSecond:(BOOL)withSecond;

- (void)show;
- (void)dismiss;
- (void)setDateComponents:(NSDateComponents*)components withAnimation:(BOOL)animation;
- (void)setDate:(NSDate*)aDate withAnimation:(BOOL)animation;
@end




@protocol SCDatePickerViewDelegate <NSObject>

@optional
//value change
- (void)SCDatePickerView:(SCDatePickerView*)datePicker dateDidChange:(NSDate*)date;

//cancel
- (void)SCDatePickerView:(SCDatePickerView*)datePicker didCancel:(UIButton*)sender;

//choose the final data
- (void)SCDatePickerView:(SCDatePickerView*)datePicker didValid:(UIButton*)sender date:(NSDate*)date;

@end
