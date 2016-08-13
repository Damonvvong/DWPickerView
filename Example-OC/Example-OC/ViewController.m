//
//  ViewController.m
//  DWPickerView
//
//  Created by Damon on 16/3/10.
//  Copyright © 2016年 damonwong. All rights reserved.
//

#import "ViewController.h"

#import "DWPickerView.h"

@interface ViewController () <DWPickerViewDataSource,DWPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;/**<  */
@property (nonatomic, assign) CGFloat rowHeight;/**< 行高 */

@end




@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.rowHeight = 40.0;
	
	DWPickerView *picker = [[DWPickerView alloc] init];
	picker.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 200);
	picker.center = self.view.center;
	picker.delegate = self;
	picker.dataSource = self;
	picker.rowHeight = self.rowHeight;
	picker.backgroundColor = [UIColor lightGrayColor];
	
	
	//TODO:
	// cell 的颜色高度可定制化，包括字体颜色，高亮颜色，
	// 选择器背景和前景色颜色可定制化
	
	
	[self.view addSubview:picker];
	
}

#pragma mark - DWPickerViewDataSource,DWPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(DWPickerView *)pickerView{
	
	return 3;
}

- (NSInteger)pickerView:(DWPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
 
	return component * 10 + 10;
}

- (void)pickerView:(DWPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	
	NSLog(@"%zd -- $%zd",component , row);
}






@end
