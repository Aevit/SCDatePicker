SCDatePicker
============

扁平化的日期选择器，可定制化程序比较高（可定制显示年、月、日、周、时、分、秒中的部分）


用法（两种构造方法）：

    //init 1
    SCDatePickerView *picker = [[SCDatePickerView alloc] initWithParentView:self.view];
    picker.pickerType = SCDatePickerViewTypeDateAndTime;
    //init 2
    //SCDatePickerView *picker = [[SCDatePickerView alloc] initWithParentView:self.view rowNum:6 withYear:YES withMonth:YES withDay:YES withweekday:YES withHour:YES withMinute:YES withSecond:NO];
    picker.delegate = self;
    self.datePicker = picker;
    [self.datePicker show];
    



//delegate方法
- (void)SCDatePickerView:(SCDatePickerView *)datePicker dateDidChange:(NSDate *)date {
    NSLog(@"date:%@", date);
}

- (void)SCDatePickerView:(SCDatePickerView *)datePicker didCancel:(UIButton *)sender {
    NSLog(@"cancel");
}


To do：

1、更改为可循环滚动

2、增加白色风格主题

3、增加创建普通pickervView功能
