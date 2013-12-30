//
//  NSDate+ext.h
//  Family
//
//  Created by Aevitx on 13-12-30.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ext)

-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(int)numDaysInMonth;
-(int)firstWeekDayInMonth;
-(int)year;
-(int)month;
-(int)day;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;

@end
