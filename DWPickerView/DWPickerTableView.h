//
//  DWPickerTableView.h
//  DWPickerView
//
//  Created by Damon on 16/3/11.
//  Copyright © 2016年 damonwong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWPickerTableViewDataSource;
@protocol DWPickerTableViewDelegate;

@interface DWPickerTableView : UIView

@property (nonatomic, assign) CGFloat rowHeight;/**< 选择列表的行高 */

@property (nonatomic, assign) CGFloat indexOfComponents;/**< 从左到右排序索引 */

@property (nonatomic, assign, readonly) NSInteger selectRow;/**< 被选中的行 */

@property (nonatomic, weak) id <DWPickerTableViewDataSource> dataSource;

@property (nonatomic, weak) id <DWPickerTableViewDelegate> delegate;

@property (nonatomic, strong) UIColor *highlightColor;/**< 文字选中高亮状态 */

- (void)selectRow:(NSInteger)row animated:(BOOL)animated;

/**
 *  刷新列表
 */
- (void)reload;

@end


@protocol DWPickerTableViewDataSource <NSObject>

@required
/**
 *  列表数量
 *
 *  @param pickerTableView 选择列表
 *
 *  @return 列表数量
 */
- (NSInteger)numberOfRowsInpickerTableView:(DWPickerTableView *)pickerTableView;

@end


@protocol DWPickerTableViewDelegate <NSObject>
@optional

/**
 *  默认加载一个只有一个 Label 的 Cell，本方法是将 title 设置给相对应的 Label
 *
 *  @param pickerTableView 选择列表
 *  @param row             需要被设置的行
 *
 *  @return 返回需要设置的标题
 */
- (NSString *)pickerTableView:(DWPickerTableView *)pickerTableView titleForRow:(NSInteger)row;
/**
 *  停止滚动，选中某行调用
 *
 *  @param pickerTableView 选择列表
 *  @param row             被选中的行数
 */
- (void)pickerTableView:(DWPickerTableView *)pickerTableView didSelectRow:(NSInteger)row;


#warning 暂时没用等待开发
- (UIView *)pickerTableView:(DWPickerTableView *)pickerTableView viewForRow:(NSInteger)row reusingView:(UIView *)view;

@end
