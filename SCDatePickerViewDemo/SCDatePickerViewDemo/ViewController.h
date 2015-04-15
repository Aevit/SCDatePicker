//
//  ViewController.h
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-1.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDatePickerView.h"

@interface ViewController : UIViewController <SCDatePickerViewDelegate> {
//    int typeNum;
}

@property (nonatomic, strong) SCDatePickerView *datePicker;

@end
