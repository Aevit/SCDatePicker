//
//  ViewController.m
//  SCDatePickerViewDemo
//
//  Created by Aevitx on 13-12-1.
//  Copyright (c) 2013年 Aevitx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = (CGRect){.origin.x = 120, .origin.y = 100, .size.width = 80, .size.height = 40};
    [btn setTitle:@"to picker0" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 SCDatePickerViewTypeDateAndTime         =   0,
 SCDatePickerViewTypeTime                =   1,
 SCDatePickerViewTypeWeekAndTime         =   2,
 SCDatePickerViewTypeDayAndTime          =   3,
 SCDatePickerViewTypeMonthDayAndTime     =   4,
 SCDatePickerViewTypeDate                =   5
 */
- (void)btnPressed:(UIButton*)sender {
    if (self.datePicker) {
        self.datePicker.pickerType++;
        self.datePicker.pickerType = (self.datePicker.pickerType % 6);
    } else {
        [self buildPicker];
    }
    [sender setTitle:[NSString stringWithFormat:@"to picker%d", self.datePicker.pickerType % 6 + 1] forState:UIControlStateNormal];
    [_datePicker show];
    
    switch (self.datePicker.pickerType % 6) {
        case 0:
            NSLog(@"年-月-日 时:分 SCDatePickerViewTypeDateAndTime");
            break;
        case 1:
            NSLog(@"时:分 SCDatePickerViewTypeTime");
            break;
        case 2:
            NSLog(@"周 时:分 SCDatePickerViewTypeWeekAndTime");
            break;
        case 3:
            NSLog(@"日 时:分 SCDatePickerViewTypeDayAndTime");
            break;
        case 4:
            NSLog(@"月-日 时:分 SCDatePickerViewTypeMonthDayAndTime");
            break;
        case 5:
            NSLog(@"年-月-日 SCDatePickerViewTypeDate");
            break;
        default:
            break;
    }
}

- (void)buildPicker {
    //init 1
    SCDatePickerView *picker = [[SCDatePickerView alloc] initWithParentView:self.view];
    picker.pickerType = SCDatePickerViewTypeDateAndTime;
    
    //init 2
//    SCDatePickerView *picker = [[SCDatePickerView alloc] initWithParentView:self.view type:SCDatePickerViewTypeDateAndTime];
    
    //init 3
//    SCDatePickerView *picker = [[SCDatePickerView alloc] initWithParentView:self.view rowNum:6 withYear:YES withMonth:YES withDay:YES withweekday:YES withHour:YES withMinute:YES withSecond:NO];
    
    picker.delegate = self;
    self.datePicker = picker;
    [self.datePicker show];
}

#pragma mark - SCDatePickerView delegate
- (void)SCDatePickerView:(SCDatePickerView *)datePicker dateDidChange:(NSDate *)date {
    NSLog(@"date:%@", date);
}

- (void)SCDatePickerView:(SCDatePickerView *)datePicker didCancel:(UIButton *)sender {
    NSLog(@"cancel");
}

- (void)SCDatePickerView:(SCDatePickerView *)datePicker didValid:(UIButton *)sender date:(NSDate *)date {
    NSLog(@"date:%@", date);
}

@end
