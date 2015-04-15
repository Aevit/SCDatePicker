//
//  SCDatePickerView.m
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-1.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import "SCDatePickerView.h"
#import "SCDatePickerDefines.h"



@interface SCDatePickerView ()

//data
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) BOOL isWeekdayPutInDayTable;

//view
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIButton *alphaBtn;
@property (nonatomic, strong) UIView *containerView;


@end


@implementation SCDatePickerView

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithParentView:nil rowNum:0 withYear:NO withMonth:NO withDay:NO withweekday:NO withHour:NO withMinute:NO withSecond:NO];
}


//init 1
- (id)initWithParentView:(UIView*)parentView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.parentView = parentView;
        self.pickerType = SCDatePickerViewTypeNone;
        [self buildBasicView];
    }
    return self;
}


//init 2
- (id)initWithParentView:(UIView *)parentView type:(SCDatePickerViewType)type {
    self.pickerType = type;
    switch (type) {
        case SCDatePickerViewTypeDateAndTime:
        {
            return [self initWithParentView:parentView rowNum:5 withYear:YES withMonth:YES withDay:YES withweekday:NO withHour:YES withMinute:YES withSecond:NO];
            break;
        }
        case SCDatePickerViewTypeTime:
        {
            return [self initWithParentView:parentView rowNum:2 withYear:NO withMonth:NO withDay:NO withweekday:NO withHour:YES withMinute:YES withSecond:NO];
            break;
        }
        case SCDatePickerViewTypeWeekAndTime:
        {
            return [self initWithParentView:parentView rowNum:3 withYear:NO withMonth:NO withDay:NO withweekday:YES withHour:YES withMinute:YES withSecond:NO];
            break;
        }
        case SCDatePickerViewTypeDayAndTime:
        {
            return [self initWithParentView:parentView rowNum:3 withYear:NO withMonth:NO withDay:YES withweekday:NO withHour:YES withMinute:YES withSecond:NO];
            break;
        }
        case SCDatePickerViewTypeMonthDayAndTime:
        {
            return [self initWithParentView:parentView rowNum:4 withYear:NO withMonth:YES withDay:YES withweekday:NO withHour:YES withMinute:YES withSecond:NO];
            break;
        }
        case SCDatePickerViewTypeDate:
        {
            return [self initWithParentView:parentView rowNum:3 withYear:YES withMonth:YES withDay:YES withweekday:NO withHour:NO withMinute:NO withSecond:NO];
            break;
        }
        default:
            break;
    }
    return self;
}

//init 3
- (id)initWithParentView:(UIView*)parentView
                  rowNum:(int)rowNum
                withYear:(BOOL)withYear
               withMonth:(BOOL)withMonth
                 withDay:(BOOL)withDay
             withweekday:(BOOL)withweekday
                withHour:(BOOL)withHour
              withMinute:(BOOL)withMinute
              withSecond:(BOOL)withSecond {
    
    self = [super initWithFrame:CGRectZero];
    if (self == nil) {
        return self;
    }
    if (!parentView) {
        return self;
    }
    
    self.parentView = parentView;
    
    [self buildBasicView];
    
    [self buildTablesWithRowsNum:rowNum withYear:withYear withMonth:withMonth withDay:withDay withweekday:withweekday withHour:withHour withMinute:withMinute withSecond:withSecond];
    
    //默认时间
    [self setDate:_date withAnimation:NO];
    
    return self;
}

- (void)buildBasicView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, _parentView.frame.size.width, _parentView.frame.size.height);
    
    //背景层
    [self buildAlphaButton];
    
    //container
    if (!_containerView) {
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, _parentView.frame.size.height, KSCDatePickerWidth, kSCDatePickerHeight)];
        container.backgroundColor = kSCDatePickerBackgroundColor;
        self.containerView = container;
        [self addSubview:container];
    }
}

- (void)buildAlphaButton {
    if (!_alphaBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, _parentView.frame.size.width, _parentView.frame.size.height);
        btn.backgroundColor = [UIColor blackColor];
        btn.alpha = 0.f;
        [btn addTarget:self action:@selector(alphaBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.alphaBtn = btn;
        [self addSubview:btn];
    }
}

- (void)buildTablesWithRowsNum:(int)rowNum
                     withYear:(BOOL)withYear
                    withMonth:(BOOL)withMonth
                      withDay:(BOOL)withDay
                  withweekday:(BOOL)withweekday
                     withHour:(BOOL)withHour
                   withMinute:(BOOL)withMinute
                   withSecond:(BOOL)withSecond {
    
    [_containerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]] || [obj isKindOfClass:NSClassFromString(@"SCInfiniteScrollView")] || [obj isKindOfClass:[UILabel class]]) {
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
    
    int count = 0;
    _isWeekdayPutInDayTable = ((withYear && withMonth && withDay && withweekday) ? YES : NO);
    CGFloat tableWidth = KSCDatePickerWidth / rowNum;
    if (withYear) {
        [self buildTableViewWithTag:TAG_YEAR frameX:count * tableWidth frameW:tableWidth];
        count++;
    }
    if (withMonth) {
        [self buildTableViewWithTag:TAG_MONTH frameX:count * tableWidth frameW:tableWidth];
        count++;
    }
    if (withDay) {
        CGFloat frameW = (_isWeekdayPutInDayTable ? tableWidth + kDayAndWeekWidth : tableWidth);
        [self buildTableViewWithTag:TAG_DAY frameX:count * tableWidth frameW:frameW];
        count++;
    }
    if (withweekday) {
        //有年月日的话，周根据年月日算出来，并且将 周 合到 日 里
        if (!_isWeekdayPutInDayTable) {
            [self buildTableViewWithTag:TAG_WEEKDAY frameX:count * tableWidth frameW:tableWidth];
        }
        count++;
    }
    if (withHour) {
        [self buildTableViewWithTag:TAG_HOUR frameX:count * tableWidth frameW:tableWidth];
        count++;
    }
    if (withMinute) {
        [self buildTableViewWithTag:TAG_MINUTE frameX:count * tableWidth frameW:tableWidth];
        count++;
    }
    if (withSecond) {
        [self buildTableViewWithTag:TAG_SECOND frameX:count * tableWidth frameW:tableWidth];
        count++;
    }
}

- (void)buildTableViewWithTag:(int)tag frameX:(CGFloat)frameX frameW:(CGFloat)frameW {
    if ([_containerView viewWithTag:tag]) {
        UIView *view = [_containerView viewWithTag:tag];
        [view removeFromSuperview];
        view = nil;
    }
    CGFloat y = (self.containerView ? 0 : _parentView.frame.size.height);
    
    if (frameX +frameW >= _parentView.frame.size.width - 10) {//10是为了防止误差
        frameW += 3;//最后一个table，右边不用空一条线
    }
    
    CGRect tRect = CGRectMake(frameX, y, frameW - 1, kSCDatePickerHeight);
    if (SWITCH_INFINITE_SCROLL) {
        SCInfiniteScrollView *list = [[SCInfiniteScrollView alloc] initWithFrame:tRect];
        list.tag = tag;
        list.delegate = self;
        list.scDelegate = self;
        list.backgroundColor = kSCDatePickerBackgroundColorListlView;
        list.showsVerticalScrollIndicator = NO;
        [self.containerView addSubview:list];
        
        [self buildLineLabelInList:list];
    } else {
        UITableView *table = [[UITableView alloc] initWithFrame:tRect style:UITableViewStylePlain];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        table.backgroundColor = kSCDatePickerBackgroundColorListlView;//kSCDatePickerBackgroundColor;
        table.tag = tag;
        table.delegate = self;
        table.dataSource = self;
        
        [self.containerView addSubview:table];
        
        [self buildLineLabelInList:table];
    }
}

- (void)buildLineLabelInList:(UIView*)listView {
    
    CGFloat otherWidth = (listView.tag == TAG_DAY && _isWeekdayPutInDayTable ? kDayAndWeekWidth : 0);
    
    UILabel *upLbl = [[UILabel alloc] initWithFrame:CGRectMake(listView.frame.origin.x + kLineX, 2 * kSCDatePickerItemHeight, listView.frame.size.width - kLineX * 2 + otherWidth, kLineHeight)];
    upLbl.tag = listView.tag + TAG_HORIZON_LINE_LABEL_UP;
    upLbl.backgroundColor = kSCDatePickerBackgroundColorLines;
    [_containerView addSubview:upLbl];
    
    
    
    UILabel *downLbl = [[UILabel alloc] initWithFrame:CGRectMake(listView.frame.origin.x + kLineX, 3 * kSCDatePickerItemHeight, listView.frame.size.width - kLineX * 2 + otherWidth, kLineHeight)];
    downLbl.tag = listView.tag + TAG_HORIZON_LINE_LABEL_DOWN;
    downLbl.backgroundColor = kSCDatePickerBackgroundColorLines;
    [_containerView addSubview:downLbl];
}

#pragma mark - action(s)
- (void)show {
    if (self.superview) {
        [self removeFromSuperview];
    }
    [_parentView addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        _alphaBtn.alpha = 0.6f;
        
        CGRect frame = self.containerView.frame;
        frame.origin.y = _parentView.frame.size.height - kSCDatePickerHeight;
        self.containerView.frame = frame;
    }];
}

- (void)dismiss {
    [self alphaBtnPressed:_alphaBtn];
}

- (void)alphaBtnPressed:(id)sender {
    if (_parentView != nil) {
        [UIView animateWithDuration:0.3f animations:^{
            _alphaBtn.alpha = 0.f;
            CGRect frame = self.containerView.frame;
            frame.origin.y = _parentView.frame.size.height;
            self.containerView.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(SCDatePickerView:didCancel:)]) {
//                self.date = [_calendar dateFromComponents:_dateComponets];
                [self.delegate SCDatePickerView:self didCancel:sender];
            }
        }];
    }
}

#pragma mark - update
- (void)updateSelectedDateAtIndex:(int)index forScrollView:(UIScrollView*)scrollView justFillTheNum:(BOOL) justFillTheNum {
    index = (justFillTheNum ? index : index - kBlankItemNum + 1);
    switch (scrollView.tag) {
        case TAG_YEAR:
        {
            _dateComponets.year = (justFillTheNum ? index : kStartYear + index);
            break;
        }
        case TAG_MONTH:
        {
            _dateComponets.month = (justFillTheNum ? index : index + 1);
            break;
        }
        case TAG_DAY:
        {
            _dateComponets.day = (justFillTheNum ? index : index + 1);
            break;
        }
        case TAG_WEEKDAY:
        {
            int preWeekday = _dateComponets.weekday;
            _dateComponets.weekday = (justFillTheNum ? index : index + 1);
            int day = _dateComponets.day + (_dateComponets.weekday - preWeekday);
            _dateComponets.day = (justFillTheNum ? day - 1 : day);
            break;
        }
        case TAG_HOUR:
        {
            _dateComponets.hour = index;
            break;
        }
        case TAG_MINUTE:
        {
            _dateComponets.minute = index;
            break;
        }
        case TAG_SECOND:
        {
            _dateComponets.second = index;
            break;
        }
        default:
            break;
    }
}

- (void)detectDate:(NSDate*)date {
    if (_pickerType != SCDatePickerViewTypeDateAndTime) {
        return;
    }
    if (!date) {
        date = [_calendar dateFromComponents:_dateComponets];
    }
    if ([date compare:[NSDate date]] == NSOrderedAscending) {
        NSLog(NSLocalizedStringFromTable(@"timePassed", SCDatePickerLocalizable, nil));
        return;
    }
}

- (int)getSelectedIndexInScrollView:(UIScrollView *)scrollView {
    
    CGFloat offsetContentScrollView = (scrollView.frame.size.height - kSCDatePickerItemHeight) / 2.0;
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat index = floorf((offsetY + offsetContentScrollView) / kSCDatePickerItemHeight);
    return (index - 1);
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (SWITCH_INFINITE_SCROLL) {
        SCInfiniteScrollView *infiniteScrollView = (SCInfiniteScrollView*)scrollView;
        [infiniteScrollView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        
    } else {
        
        int index = [self getSelectedIndexInScrollView:scrollView];
        [self updateSelectedDateAtIndex:index forScrollView:scrollView justFillTheNum:NO];
        [self setScrollView:scrollView atIndex:index animated:YES];
        [self setScrollView:scrollView atIndex:3 animated:YES];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (SWITCH_INFINITE_SCROLL) {
        SCInfiniteScrollView *infiniteScrollView = (SCInfiniteScrollView*)scrollView;
        [infiniteScrollView scrollViewDidEndDecelerating:scrollView];
        
        [self setScrollView:scrollView atIndex:3 animated:YES];
        
    } else {
        
        int index = [self getSelectedIndexInScrollView:scrollView];
        [self updateSelectedDateAtIndex:index forScrollView:scrollView justFillTheNum:NO];
        [self setScrollView:scrollView atIndex:index animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    int index = [self getFirstVisibleIndexInScrollView:scrollView];
    //    [self updateSelectedDateAtIndex:index forScrollView:scrollView];
    
    if (SWITCH_INFINITE_SCROLL) {
        SCInfiniteScrollView *infiniteScrollView = (SCInfiniteScrollView*)scrollView;
        [infiniteScrollView scrollViewDidScroll:scrollView];
    } else {
        [self highlightLabel:scrollView];
    }
}

- (void)highlightLabel:(UIScrollView*)scrollView {
    UITableView *table = (UITableView*)scrollView;
    if ([table respondsToSelector:@selector(reloadData)]) {
        [table reloadData];
    }
}

- (void)setScrollView:(UIScrollView*)scrollView atIndex:(int)index animated:(BOOL)animated {
    
    if (scrollView != nil) {
        
        if (animated) {
            [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        }
        scrollView.contentOffset = CGPointMake(0.0, (index - 1) * kSCDatePickerItemHeight);
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        if (scrollView.tag == TAG_YEAR || scrollView.tag == TAG_MONTH) {//日那一列要根据月、闰年来确定天数
            if ([_containerView viewWithTag:TAG_DAY]) {
                if (SWITCH_INFINITE_SCROLL) {
                    SCInfiniteScrollView *dayList = (SCInfiniteScrollView*)[_containerView viewWithTag:TAG_DAY];
                    [dayList reloadData];
                } else {
                    UITableView *dayTable = (UITableView*)[_containerView viewWithTag:TAG_DAY];
                    [dayTable reloadData];
                }
            }
        }
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(SCDatePickerView:dateDidChange:)]) {
            self.date = [_calendar dateFromComponents:_dateComponets];
            [self detectDate:_date];
            [self.delegate SCDatePickerView:self dateDidChange:_date];
        }
    }
}

#pragma mark - table delegate datesource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSCDatePickerItemHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getRowNumInListWithTag:tableView.tag] + kBlankItemNum * 2;//上下各两个空的lbl
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"SCCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSCDatePickerItemHeight)];
        lbl.textAlignment = ALIGN_CENTER;
        lbl.backgroundColor = kSCDatePickerBackgroundColorListlView;// kSCDatePickerBackgroundColor;
        lbl.tag = TAG_CELL_LABEL;
        [cell.contentView addSubview:lbl];
    }
    
    UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:TAG_CELL_LABEL];
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == numberOfRows - 1 || indexPath.row == numberOfRows - kBlankItemNum) {
        lbl.text = @"";
        return cell;
    }
    int num = indexPath.row - kBlankItemNum;
    [self fillDataWithTag:tableView.tag justFillTheNum:NO andNum:num andLabel:lbl];
    int highlightLblIndex = [self getSelectedIndexInScrollView:tableView];
    if (indexPath.row == highlightLblIndex + 1) {
        lbl.textColor = kSCDatePickerFontColorLabelSelected;
        lbl.font = kSCDatePickerFontLabelSelected;
    } else {
        lbl.textColor = kSCDatePickerFontColorLabel;
        lbl.font = kSCDatePickerFontLabel;
    }
    
    return cell;
}

- (int)getDefaultNumInListWithTag:(int)tag {
    switch (tag) {
        case TAG_YEAR:
        {
            return _dateComponets.year;
            break;
        }
        case TAG_MONTH:
        {
            return _dateComponets.month;
            break;
        }
        case TAG_DAY:
        {
            return _dateComponets.day;
            break;
        }
        case TAG_WEEKDAY:
        {
            return _dateComponets.weekday;
            break;
        }
        case TAG_HOUR:
        {
            return _dateComponets.hour;
            break;
        }
        case TAG_MINUTE:
        {
            return _dateComponets.minute;
            break;
        }
        case TAG_SECOND:
        {
            return _dateComponets.second;
            break;
        }
        default:
            break;
    }
    return 0;
}

//justFillTheNum表示直接将num的值赋给lbl
- (void)fillDataWithTag:(int)tag justFillTheNum:(BOOL)justFillTheNum andNum:(int)num andLabel:(UILabel*)lbl {
    switch (tag) {
        case TAG_YEAR:
        {
            num = (justFillTheNum ? num : kStartYear + num);
            lbl.text = [NSString stringWithFormat:@"%d", num];
            break;
        }
        case TAG_MONTH:
        {
            num = (justFillTheNum ? num : (num + 1));
            lbl.text = [NSString stringWithFormat:@"%d%@", num, NSLocalizedStringFromTable(@"month", SCDatePickerLocalizable, nil)];
            break;
        }
        case TAG_DAY:
        {
            num = (justFillTheNum ? num : (num + 1));
            NSString *str = [NSString stringWithFormat:@"%d%@", num,  NSLocalizedStringFromTable(@"day", SCDatePickerLocalizable, nil)];
            if (_isWeekdayPutInDayTable) {//
                int weekday = [SCDatePickerView getWeekdayWithYear:_dateComponets.year month:_dateComponets.month day:num];
                NSString *weekdayStr = [NSString stringWithFormat:@"weekday%d", weekday];
                str = [NSString stringWithFormat:@"%@ %@", str, NSLocalizedStringFromTable(weekdayStr, SCDatePickerLocalizable, nil)];
            }
            lbl.text = str;
            break;
        }
        case TAG_WEEKDAY:
        {
//            num = (setDefaultData ? num : num);
            NSString *weekdayStr = [NSString stringWithFormat:@"weekday%d", num];
            lbl.text = NSLocalizedStringFromTable(weekdayStr, SCDatePickerLocalizable, nil);
            break;
        }
        case TAG_HOUR:
        {
//            num = (setDefaultData ? num : num);
            lbl.text = [NSString stringWithFormat:@"%d", num];
            break;
        }
        case TAG_MINUTE:
        {
//            num = (setDefaultData ? num : num);
            lbl.text = [NSString stringWithFormat:@"%d", num];
            break;
        }
        case TAG_SECOND:
        {
//            num = (setDefaultData ? num : num);
            lbl.text = [NSString stringWithFormat:@"%d", num];
            break;
        }
        default:
        {
            lbl.text = @"why me here!!";
        }
            break;
    }
}

#pragma mark - SCInfiniteScrollView delegate
- (CGFloat)eachItemHeightInSCInfiniteScrollView:(SCInfiniteScrollView *)scrollview {
    return kSCDatePickerItemHeight;
}

- (UIView*)SCInfiniteScrollView:(SCInfiniteScrollView *)scrollview viewForItemAtIndex:(NSInteger)index infiniteScrollType:(InfiniteScrollType)infiniteScrollType {
    
    int tag = scrollview.tag;
    UILabel *cell = (UILabel*)[scrollview viewWithTag:kTagInfiniteItemView + index];
    
    if (!cell) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, index * kSCDatePickerItemHeight, scrollview.frame.size.width, kSCDatePickerItemHeight)];
        lbl.textAlignment = ALIGN_CENTER;
        int firstData = (tag == TAG_YEAR ? kStartYear : (tag == TAG_MONTH || tag == TAG_DAY || tag == TAG_WEEKDAY ? 1 : 0));
        lbl.text = [NSString stringWithFormat:@"%d", (firstData + index)];
        lbl.backgroundColor = kSCDatePickerBackgroundColorListlView;// kSCDatePickerBackgroundColor;
        lbl.tag = kTagInfiniteItemView + index;
        cell = lbl;
        [scrollview addSubview:lbl];
        
        if (index == scrollview.itemNum / 2) {
            cell.textColor = kSCDatePickerFontColorLabelSelected;
            cell.font = kSCDatePickerFontLabelSelected;
        } else {
            lbl.textColor = kSCDatePickerFontColorLabel;
            lbl.font = kSCDatePickerFontLabel;
        }
    }
    
    int preTextNum = [cell.text intValue];
    
    if (self.dateComponets) {
        NSLog(@"tag:%d", tag);
    }
    if (infiniteScrollType == InfiniteScrollTypeEqual) {
        preTextNum = [self getDefaultNumInListWithTag:tag] + index - 3;
    } else {
        preTextNum = fabsf((infiniteScrollType == InfiniteScrollTypeUp ? preTextNum + 1 : (infiniteScrollType == InfiniteScrollTypeDown ? preTextNum - 1 : preTextNum)));
    }
    BOOL isStartFromZero = (tag == TAG_HOUR || tag == TAG_MINUTE || tag == TAG_SECOND ? YES : NO);
    int allNum = [self getRowNumInListWithTag:tag];
    int maxNum = (tag == TAG_YEAR ? kMaxYear : allNum - (isStartFromZero ? 1 : 0));
    
    if (isStartFromZero) {
        if (preTextNum == -1) {
            preTextNum = maxNum - 1;
        } else if (preTextNum >= maxNum) {
            preTextNum = preTextNum - maxNum + 1;
        }
    } else {
        if (preTextNum == 0) {
            preTextNum = maxNum;
        } else if (preTextNum > maxNum) {
            preTextNum = preTextNum - maxNum;
        }
    }
    [self fillDataWithTag:tag justFillTheNum:YES andNum:preTextNum andLabel:cell];
    
    if (index == scrollview.itemNum / 2) {//中间的
        [self updateSelectedDateAtIndex:preTextNum forScrollView:scrollview justFillTheNum:YES];
    }
    
    return cell;
}

#pragma mark - calculate
- (int)getRowNumInListWithTag:(int)tag {
    NSInteger rowNum = 0;
    switch (tag) {
        case TAG_YEAR:
        {
            rowNum += kMaxYear - kStartYear + 1;
            break;
        }
        case TAG_MONTH:
        {
            rowNum += 12;
            break;
        }
        case TAG_DAY:
        {
            NSInteger year = _dateComponets.year;
            NSInteger month = _dateComponets.month;
            if (month == 1 || month == 3 || month == 5 || month == 8 || month == 10 || month == 12) {
                rowNum += 31;
            } else if (month == 4 || month == 6 || month == 9 || month == 11) {
                rowNum += 30;
            } else if (month == 2) {
                BOOL isLeapYear = ((year % 4 == 0 && year % 100 != 0) || (year % 100 == 0 && year % 400 == 0));//闰年
                NSInteger wholdDaysOfMonth = (isLeapYear ? 28 : 29);
                rowNum += wholdDaysOfMonth;
            }
            break;
        }
        case TAG_WEEKDAY:
        {
            rowNum += 7;
            break;
        }
        case TAG_HOUR:
        {
            rowNum += 24;
            break;
        }
        case TAG_MINUTE:
        {
            rowNum += 60;
            break;
        }
        case TAG_SECOND:
        {
            rowNum += 60;
            break;
        }
        default:
        {
            rowNum += 1;
        }
            break;
    }
    return rowNum;
}

/*******************************************************
 **
 **   两种方法求输入日期是星期几   （0表示星期天，其余为   1-6）
 **   如果你要输出是星期几那就自己去加工一下就OK，很简单的啦！
 **   下面还有两种方法可以计算星期
 **
 ********************************************************/
//方法1
+ (int)getWeekdayWithYear:(int)year month:(int)month day:(int)day {
    int   weekday;
    /*下面的四条语句用来计算输入日期的星期数，是程序的核心部分，缺一不可*/
    weekday = (year > 0 ? (5 + (year + 1) + (year - 1)/4 - (year - 1)/100 + (year - 1)/400) % 7
               : (5 + year + year/4 - year/100 + year/400) % 7);
    
    weekday = (month > 2 ? (weekday + 2*(month + 1) + 3*(month + 1)/5) % 7
               : (weekday + 2*(month + 2) + 3*(month + 2)/5) % 7);
    
    if (((year%4 == 0 && year%100 != 0) || year%400 == 0) && month > 2)
    {
        weekday = (weekday + 1) % 7;
    }
    weekday = (weekday + day) % 7;
    return weekday;
}

//方法2
+ (int)getWeekday:(CFGregorianDate)date {
	CFTimeZoneRef tz = CFTimeZoneCopyDefault();
	CFGregorianDate month_date;
	month_date.year = date.year;
	month_date.month = date.month;
	month_date.day = date.day;
	month_date.hour = 0;
	month_date.minute = 0;
	month_date.second = 1;
	return (int)CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(month_date,tz),tz);
}

#pragma mark - public
#pragma mark - set data
- (void)setDate:(NSDate*)aDate withAnimation:(BOOL)animation {
    self.date = aDate;
    if (self.date == nil) {
        self.date = [NSDate date];
    }
    if (self.calendar == nil) {
        self.calendar = [NSCalendar currentCalendar];
    }
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    self.dateComponets = [_calendar components:unitFlags fromDate:_date];
    
    for (id obj in self.containerView.subviews) {
        if ([obj isKindOfClass:NSClassFromString(@"SCInfiniteScrollView")]) {
            SCInfiniteScrollView *list = (SCInfiniteScrollView*)obj;
            [list reloadData];
        } else 
        if ([obj isKindOfClass:[UITableView class]]) {
            UITableView *table = (UITableView*)obj;
            NSInteger middleRowNum = 2;
            NSInteger minNum = 0;
            switch (table.tag) {
                case TAG_YEAR:
                {
                    middleRowNum = _dateComponets.year - kStartYear;
                    break;
                }
                case TAG_MONTH:
                {
                    middleRowNum = MAX(_dateComponets.month - 1, minNum);
                    break;
                }
                case TAG_DAY:
                {
                    middleRowNum = MAX(_dateComponets.day - 1, minNum);
                    break;
                }
                case TAG_WEEKDAY:
                {
                    middleRowNum = MAX(_dateComponets.weekday - 1, minNum);
                    break;
                }
                case TAG_HOUR:
                {
                    middleRowNum = MAX(_dateComponets.hour, minNum);
                    break;
                }
                case TAG_MINUTE:
                {
                    middleRowNum = MAX(_dateComponets.minute, minNum);
                    break;
                }
                case TAG_SECOND:
                {
                    middleRowNum = MAX(_dateComponets.second, minNum);
                    break;
                }
                default:
                    break;
            }
            [self setScrollView:table atIndex:(middleRowNum + 1) animated:animation];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstRowNum inSection:0];
//            [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animation];
        }
    }
}

- (void)setDateComponents:(NSDateComponents*)components withAnimation:(BOOL)animation {
    if (!self.calendar) {
        self.calendar = [NSCalendar currentCalendar];
    }
    NSDate *date = [_calendar dateFromComponents:components];
    [self setDate:date withAnimation:animation];
}

- (void)setPickerType:(SCDatePickerViewType)pickerType {
    if (_pickerType != pickerType) {
        _pickerType = pickerType;
        switch (pickerType) {
            case SCDatePickerViewTypeDateAndTime:
            {
                [self buildTablesWithRowsNum:5 withYear:YES withMonth:YES withDay:YES withweekday:NO withHour:YES withMinute:YES withSecond:NO];
                break;
            }
            case SCDatePickerViewTypeTime:
            {
                [self buildTablesWithRowsNum:2 withYear:NO withMonth:NO withDay:NO withweekday:NO withHour:YES withMinute:YES withSecond:NO];
                break;
            }
            case SCDatePickerViewTypeWeekAndTime:
            {
                [self buildTablesWithRowsNum:3 withYear:NO withMonth:NO withDay:NO withweekday:YES withHour:YES withMinute:YES withSecond:NO];
                break;
            }
            case SCDatePickerViewTypeDayAndTime:
            {
                [self buildTablesWithRowsNum:3 withYear:NO withMonth:NO withDay:YES withweekday:NO withHour:YES withMinute:YES withSecond:NO];
                break;
            }
            case SCDatePickerViewTypeMonthDayAndTime:
            {
                [self buildTablesWithRowsNum:4 withYear:NO withMonth:YES withDay:YES withweekday:NO withHour:YES withMinute:YES withSecond:NO];
                break;
            }
            case SCDatePickerViewTypeDate:
            {
                [self buildTablesWithRowsNum:3 withYear:YES withMonth:YES withDay:YES withweekday:NO withHour:NO withMinute:NO withSecond:NO];
                break;
            }
            default:
                break;
        }
    }
    [self setDate:_date withAnimation:NO];
}


#pragma makr - dealloc
- (void)dealloc {
    if (_containerView) {
        [_containerView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
        
        self.containerView = nil;
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
