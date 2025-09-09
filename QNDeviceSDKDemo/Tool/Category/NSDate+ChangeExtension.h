//
//  NSDate+ChangeExtension.h
//  SiDeHuiYi
//
//  Created by Side on 2023/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QNDateFormatter) {
    QNDateFormatter01,    // 20-30-06(时-分-秒)
    QNDateFormatter02,    // 20时-30分-06秒(x时-y分-z秒)
    QNDateFormatter03,    // "1998-08-24 12:15:20" (Y-M-D h:m:s)
    QNDateFormatter04,    // "1998-08-24 12:15:20 星期三" (Y-M-D h:m:s 星期几)
    QNDateFormatter05,    // "2021-02-10 12时" （年-月-日 h时）
    QNDateFormatter06,    // 2023/05/08（周四）18:55
    QNDateFormatter07,    // "1998-08-24 12:15"
    QNDateFormatter08,    // "1998/08/24"
    QNDateFormatter09,    // "1998/08/24 12:15"
    QNDateFormatter10,    // "19980824"
    QNDateFormatter11,    // "1998-08-24 18:00"  年月日时
};

@interface NSDate (ChangeExtension)
-(NSInteger)hour;
-(NSInteger)day;
-(NSInteger)month;
-(NSInteger)year;

/*
 *  @brief   将NSString以format的形式转成NSDate
 *       常用的转换格式为：
 *       yyyy-MM-dd HH:mm:ss.SSS
 *       yyyy-MM-dd HH:mm:ss
 *       yyyy-MM-ddMM dd yyyy
 *
 */
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 *  @brief  比较日期大小
 */
+ (int)compareDate:(NSDate *)date01 withDate:(NSDate *)date02;

/**
 *  @brief  比较两日期是否是同一天
 */
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+(NSString *)convertDateString:(NSString *)dateStr  formatter:(QNDateFormatter)formatter;
-(NSString *)convertStringWithFormatter:(QNDateFormatter)formatter;
/**
 * 获取星期、年、月、日、时、分、秒，并保存在字典里面
 */
-(NSDictionary *)requireDetailDateWithFormatter:(NSString *)format;

+(NSInteger)dayBetweenWithStartDate:(NSDate *)startDate  endDate:(NSDate *)endDate;
+(NSInteger)hourBetweenWithStartDate:(NSDate *)startDate  endDate:(NSDate *)endDate;

/**
 * 通过生日获取年龄
 */
+ (NSInteger)ageWithDateOfBirthday:(NSDate *)date;

/**
 * 获取几小时以后或之前的日期
 */
- (NSDate *)getNewDateToHours:(NSTimeInterval)hours;
/**
 * 获取几秒以后或之前的日期
 */
- (NSDate *)getNewDateToSeconds:(NSTimeInterval)seconds;

@end

NS_ASSUME_NONNULL_END
