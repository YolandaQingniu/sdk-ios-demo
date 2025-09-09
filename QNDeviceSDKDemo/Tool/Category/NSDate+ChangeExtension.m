//
//  NSDate+ChangeExtension.m
//  SiDeHuiYi
//
//  Created by Side on 2023/3/12.
//

#import "NSDate+ChangeExtension.h"

@implementation NSDate (ChangeExtension)

/*
 *  @brief   将NSString以format的形式转成NSDate
 *       常用的转换格式为：
 *       yyyy-MM-dd HH:mm:ss.SSS
 *       yyyy-MM-dd HH:mm:ss
 *       yyyy-MM-ddMM dd yyyy
 *
 */
+(NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:format];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}


/**
 *  date01 > date02
 */
+(NSTimeInterval)Date01:(NSDate *)date01 betweenDate:(NSDate *)date02{
    return [date01 timeIntervalSinceDate:date02];
}

+(int)compareDate:(NSDate *)date01 withDate:(NSDate *)date02{
    int ci;
    NSComparisonResult result = [date01 compare:date02];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default:NSLog(@"erorr dates %@, %@", date01, date02); break;
    }
    return ci;
}

/**
 *  是否为同一天
 */
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+(NSString *)convertDateString:(NSString *)dateStr  formatter:(QNDateFormatter)formatter {
    NSDate *date = [NSDate dateWithString:dateStr format:@"yyyy-MM-dd HH:mm:ss"];
    return [date  convertStringWithFormatter:formatter];
}

-(NSString *)convertStringWithFormatter:(QNDateFormatter)formatter{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:self];
    long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    long day=[comps day];//获取日期对应的长整形字符串
    long year=[comps year];//获取年对应的长整形字符串
    long month=[comps month];//获取月对应的长整形字符串
    long hour=[comps hour];//获取小时对应的长整形字符串
    long minute=[comps minute];//获取月对应的长整形字符串
    long second=[comps second];//获取秒对应的长整形字符串
    NSString *riQi = @"";
    switch (formatter) {
        case QNDateFormatter01:
            riQi =[NSString stringWithFormat:@"%02ld-%02ld-%02ld",hour,minute,second];
            break;
        case QNDateFormatter02:
            riQi =[NSString stringWithFormat:@"%02ld时-%02ld分-%02ld秒",hour,minute,second];
            break;
        case QNDateFormatter03:
            riQi =[NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",year,month,day,hour,minute,second];
            break;
        case QNDateFormatter04:
            riQi =[NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld 星期%ld",year,month,day,hour,minute,second,weekNumber];
            break;
        case QNDateFormatter05:
            riQi =[NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld时",year,month,day,hour];
            break;
        case QNDateFormatter06:
            riQi =[NSString stringWithFormat:@"%ld/%02ld/%02ld (周%@) %02ld:%02ld",year,month,day,[self weekStringFromWeekNumber:weekNumber],hour,minute];
            break;
        case QNDateFormatter07:
            riQi =[NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",year,month,day,hour,minute];
            break;
        case QNDateFormatter08:
            riQi =[NSString stringWithFormat:@"%ld/%02ld/%02ld",year,month,day];
            break;
        case QNDateFormatter09:
            riQi =[NSString stringWithFormat:@"%ld/%02ld/%02ld %02ld:%02ld",year,month,day,hour,minute];
            break;
        case QNDateFormatter10:
            riQi =[NSString stringWithFormat:@"%ld%02ld%02ld",year,month,day];
            break;
        case QNDateFormatter11:
            riQi =[NSString stringWithFormat:@"%ld%02ld%02ld %ld:00",year,month,day,hour];
            break;
        default:
            break;
    }
    
    return riQi;
}


-(NSDictionary *)requireDetailDateWithFormatter:(NSString *)format{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:self];
    long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    long day=[comps day];//获取日期对应的长整形字符串
    long year=[comps year];//获取年对应的长整形字符串
    long month=[comps month];//获取月对应的长整形字符串
    long hour=[comps hour];//获取小时对应的长整形字符串
    long minute=[comps minute];//获取月对应的长整形字符串
    long second=[comps second];//获取秒对应的长整形字符串
    return @{
        @"weak":@(weekNumber),
        @"year":@(year),
        @"month":@(month),
        @"day":@(day),
        @"hour":@(hour),
        @"minute":@(minute),
        @"second":@(second)
    };
}

// 两个日期相差多少天
+(NSInteger)dayBetweenWithStartDate:(NSDate *)startDate  endDate:(NSDate *)endDate{
    //利用NSCalendar比较日期的差异
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
        return  (endDate.day - startDate.day);
    }else{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
        //比较的结果是NSDateComponents类对象
        NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
        return delta.day;
    }
}

+(NSInteger)hourBetweenWithStartDate:(NSDate *)startDate  endDate:(NSDate *)endDate{
    if (startDate.year == endDate.year && (startDate.month == endDate.month) && (startDate.day == endDate.day)) {
        return  (endDate.hour - startDate.hour);
    }else{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitHour;//只比较天数差异
        //比较的结果是NSDateComponents类对象
        NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
//        NSLog(@"两个日期的小时数：%ld",delta.hour);
        return delta.hour;
    }
}

- (NSInteger)hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return components.hour;
}

- (NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return components.day;
}

- (NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return components.month;
}

- (NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

+ (NSInteger)ageWithDateOfBirthday:(NSDate *)date {
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}


- (NSDate *)getNewDateToHours:(NSTimeInterval)hours {
    // days 为正数时，表示几小时之后的日期；负数表示几小时之前的日期
    return [self dateByAddingTimeInterval:60 * 60 * hours];
}

- (NSDate *)getNewDateToSeconds:(NSTimeInterval)seconds {
    // days 为正数时，表示几秒之后的日期；负数表示几秒之前的日期
    return [self dateByAddingTimeInterval: seconds];
}

#pragma mark - private Method
- (NSString *)weekStringFromWeekNumber:(NSInteger)weekNumber {
    NSString *weekStr = nil;
    switch (weekNumber) {
        case 1:
            weekStr = @"一";
            break;
        case 2:
            weekStr = @"二";
            break;
        case 3:
            weekStr = @"三";
            break;
        case 4:
            weekStr = @"四";
            break;
        case 5:
            weekStr = @"五";
            break;
        case 6:
            weekStr = @"六";
            break;
        case 7:
            weekStr = @"日";
            break;
        default:
            break;
    }
    return weekStr;
}



@end
