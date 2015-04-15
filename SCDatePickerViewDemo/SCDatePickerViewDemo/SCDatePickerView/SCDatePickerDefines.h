//
//  SCDatePickerDefines.h
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-2.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#ifndef SCDatePickerViewDemo_SCDatePickerDefines_h
#define SCDatePickerViewDemo_SCDatePickerDefines_h

#define SCDatePickerLocalizable     @"SCDatePickerLocalizable"

//tags
#define kTagSCDateTable 1000
#define TAG_YEAR        kTagSCDateTable + 1
#define TAG_MONTH       kTagSCDateTable + 2
#define TAG_DAY         kTagSCDateTable + 3
#define TAG_WEEKDAY     kTagSCDateTable + 4
#define TAG_HOUR        kTagSCDateTable + 5
#define TAG_MINUTE      kTagSCDateTable + 6
#define TAG_SECOND      kTagSCDateTable + 7

#define TAG_CELL_LABEL  kTagSCDateTable + 20

#define TAG_HORIZON_LINE_LABEL_UP        50
#define TAG_HORIZON_LINE_LABEL_DOWN      100

//fonts
#define kSCDatePickerFontTitle [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]
#define kSCDatePickerFontLabel [UIFont fontWithName:@"HelveticaNeue-Regular" size:16.0]
#define kSCDatePickerFontLabelSelected [UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]

//font colors
//#define kSCDatePickerFontColorTitle [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kSCDatePickerFontColorLabel [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kSCDatePickerFontColorLabelSelected [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0]

//colors
#define kSCDatePickerBackgroundColor [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0]
//#define kSCDatePickerBackgroundColorTitle [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0]
//#define kSCDatePickerBackgroundColorButtonValid [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0]
//#define kSCDatePickerBackgroundColorButtonCancel [UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0]
#define kSCDatePickerBackgroundColorListlView [UIColor blackColor]
//#define kSCDatePickerBackgroundColorListlView [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0]
#define kSCDatePickerBackgroundColorLines [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:229.0/255.0 alpha:1.0]


//sizes
#define kSCDatePickerItemNum        5
#define KSCDatePickerWidth          320
#define kSCDatePickerHeight         44 * kSCDatePickerItemNum
#define kSCDatePickerMargin         1
#define kSCDatePickerItemHeight     44

#define kDayAndWeekWidth            53

#define kLineX                      5
#define kLineHeight                 2

//align
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CURRENT_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define ALIGN_CENTER    (CURRENT_SYS_VERSION < 6.0 ? UITextAlignmentCenter : NSTextAlignmentCenter)
#define ALIGN_LEFT      (CURRENT_SYS_VERSION < 6.0 ? UITextAlignmentLeft : NSTextAlignmentLeft)
#define ALIGN_RIGHT     (CURRENT_SYS_VERSION < 6.0 ? UITextAlignmentRIGHT : NSTextAlignmentRIGHT)

//other
#define kStartYear                  1900
#define kMaxYear                    3333

#define kBlankItemNum               2

#endif
