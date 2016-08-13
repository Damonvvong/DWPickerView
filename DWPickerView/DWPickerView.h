//
//  DWPickerView.h
//  DWPickerView
//
//  Created by Damon on 16/3/13.
//  Copyright © 2016年 damonwong. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol DWPickerViewDataSource;
@protocol DWPickerViewDelegate;


@interface DWPickerView : UIView

@property (nonatomic, assign) CGFloat rowHeight;/**< 选择列表的行高 */
@property (nonatomic, weak) id <DWPickerViewDataSource> dataSource;
@property (nonatomic, weak) id <DWPickerViewDelegate> delegate;
@property (nonatomic, strong) UIColor *highlightColor;/**< 文字选中高亮状态 */
@property (nonatomic, strong) NSString *title;/**< 类型 */
@property (nonatomic, strong) UIView *selectedView;/**< 中心选择视图 */
/**
 *  刷新某一列数据
 *
 *  @param component 列数索引
 */
- (void)reloadComponent:(NSInteger)component;

/**
 *  刷新所有
 *
 */
- (void)reload;

/**
 *  代码控制选中某一行
 *
 *  @param row       要选中的行数
 *  @param component 要选中的列表
 *  @param animated  是否动画
 */
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

/**
 *  某个列表被选中的行数
 *
 *  @param component 列表索引
 *
 *  @return 行数
 */
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end

@protocol DWPickerViewDataSource <NSObject>

@optional

/**
 *  PickerView 的 列表数量
 *
 *  @param pickerView
 *
 *  @return 返回列表数量
 */
- (NSInteger)numberOfComponentsInPickerView:(DWPickerView *)pickerView;

/**
 *  某一个列表中的行数
 *
 *  @param pickerView
 *  @param component  列表索引
 *
 *  @return 返回行数
 */
- (NSInteger)pickerView:(DWPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end


@protocol DWPickerViewDelegate <NSObject>

@optional

/**
 *  自定义列表宽度，默认所有列表等宽
 *
 *  @param pickerView
 *  @param component  列表索引
 *
 *  @return 宽度
 */
- (CGFloat)pickerView:(DWPickerView *)pickerView widthForComponent:(NSInteger)component;

/**
 *  列表的某一行的文字内容
 *
 *  @param pickerView 选择器
 *  @param row        行数
 *  @param component  列表索引
 *
 *  @return 文字内容
 */
- (UIView *)pickerView:(DWPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
/**
 *  停止滚动，选中某行调用
 *
 *  @param pickerView 选择器
 *  @param row        行数
 *  @param component  列表索引
 */
- (void)pickerView:(DWPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

#warning 暂时没用等待开发
- (NSString *)pickerView:(DWPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
@end

