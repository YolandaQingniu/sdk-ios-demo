//
// Created by 黄敦仁 on 17/6/5.
//

#ifndef QNCALAC_ALGORITHM_H
#define QNCALAC_ALGORITHM_H

#define MAX_BODYFAT_VALUE 70.0

#define WEIGHT_SCALE 1
#define SINGLE_FREQUENCY 2
#define DOUBLE_FREQUENCY_V1 3
#define DOUBLE_FREQUENCY_V2 4
#define SINGLE_FREQUENCY_V2 5
#define SINGLE_FREQUENCY_V3 6


#define HERBALIFE_MAX_OFFSET  24

#define ZERO_SCORE  80
#define ZERO_AGE 40
#define ZERO_SCORE_MIN  78
#define ZERO_SCORE_MAX  90


//Herbalife
#define HERBALIFE_AGE_MAX 70
#define HERBALIFE_AGE_MIN 16
#define HERBALIFE_ZERO_SCORE  85

#include <stdlib.h>


#define BODY_SHAPE_1  1 //隐形肥胖型
#define BODY_SHAPE_2  2 //运动不足型
#define BODY_SHAPE_3  3 //偏瘦型
#define BODY_SHAPE_4  4 //标准型
#define BODY_SHAPE_5  5 //偏瘦肌肉型
#define BODY_SHAPE_6  6 //肥胖型
#define BODY_SHAPE_7  7 //偏胖型
#define BODY_SHAPE_8  8 //标准肌肉型
#define BODY_SHAPE_9  9 //非常肌肉型


#ifdef jint

typedef jint qint;
typedef jdouble qdouble;

#else

typedef int qint;
typedef double qdouble;
typedef long double BigFloat;

#endif

typedef struct {
    qdouble weight;//体重
    qdouble bmi;
    qdouble bodyfat;//体脂率
    qdouble lbm;//去脂体重
    qdouble subfat;//皮下脂肪
    qdouble visfat;//内脏脂肪
    qdouble water;//体水分
    qint bmr;//基础代谢率
    qdouble muscle;//骨骼肌率
    qdouble muscleMass;//肌肉量
    qdouble bone;//骨量'
    qdouble protein;//蛋白质
    qdouble score; //分数
    qint bodyAge; //体年龄
    qint bodyShape; //体型
    qint heartRate; //心率
    qdouble heartIndex; //心脏指数
    qdouble muscleRH;//右上肢肌肉重量
    qdouble muscleLH;//左上肢肌肉重量
    qdouble muscleT;//躯干肌肉重量
    qdouble muscleRF;//右下肌肉重量
    qdouble muscleLF;//左下肌肉重量
    qdouble fatRH;//右上肢脂肪
    qdouble fatLH;//左上肢脂肪
    qdouble fatT;//躯干脂肪
    qdouble fatRF;//右下脂肪
    qdouble fatLF;//左下脂肪
    qdouble paunch;//腹围
} QNData;

#ifdef __cplusplus
extern "C" {
#endif

/**
 * 算法入口，默认不是运动
 * @param version 算法版本，2 ：两电极算法 3 ：四电极V1 4 ：四电极V2
 * @param height 身高 cm
 * @param age 年龄
 * @param gender 性别 0 ：女 1 ：男
 * @param weight 体重 kg
 * @param resistance 50khz的电阻 低频
 * @param resistance500 500khz的电阻 高频
 * @return
 */
QNData *algorithm(qint version, qint height, qint age, qint gender, qdouble weight,
        qint resistance, qint resistance500);

/**
 * 算法入口
 * @param version 算法版本，2 ：两电极算法 3 ：四电极V1 4 ：四电极V2
 * @param height 身高 cm
 * @param age 年龄
 * @param gender 性别 0 ：女 1 ：男
 * @param weight 体重 kg
 * @param resistance 50khz的电阻 低频
 * @param resistance500 500khz的电阻 高频
 * @param isAthlete 是否为运动员，0为否，1是运动
 * @return
 */
QNData *algorithmWithAthlete(qint version, qint height, qint age, qint gender, qdouble weight,
        qint resistance, qint resistance500, qint isAthlete);

/**
 * 专为康宝莱提供的算法库方法
 */
QNData *algorithmForHerbalife(qint version, qint height, qint age, qint gender, qdouble weight,
        qint resistance, qint resistance500);

/*
 * 根据心率以及身体资料计算心脏指数
 * @param height 身高 cm
 * @param age 年龄
 * @param gender 性别 0 ：女 1 ：男
 * @param weight 体重 kg
 * @param heartRate 心率
 * @return 返回心脏指数，单位是  L/min/m^2
 */
qdouble calcHeartIndex(qint height, qint age, qint gender, qdouble weight, qint heartRate);


/**
 * 根据体脂率、BMI、性别计算体型
 */
qint calcBodyShape(qdouble bodyfat, qdouble bmi, qint gender);

/**
 * 对两个阻抗值进行加密
 * @param weight
 * @param resistance50
 * @param resistance500
 * @return 返回一个字符串，是加密后的两个阻抗，第一个是50khz的，第二个是500khz的
 */
char *encryptResistance(qdouble weight, qint resistance50, qint resistance500);

/**
 * 对两个阻抗值进行解密
 * @param weight
 * @param resistance50
 * @param resistance500
 * @return 返回一个字符串，是解密后的两个阻抗，第一个是50khz的，第二个是500khz的
 */
char *decryptResistance(qdouble weight, qint resistance50, qint resistance500);

/**
 * 计算BMI
 */
qdouble calcBmi(qint height, qdouble weight);

/**
 * 计算专业秤数据
 * @param height 身高，cm
 * @param gender 性别 0 女 1 男
 * @param age 年龄
 * @param weight 体重，kg
 * @param RH_20K 右上肢 20khz
 * @param LH_20K 左上肢 20khz
 * @param T_20K 躯干 20khz
 * @param RF_20K 右下肢 20khz
 * @param LF_20K 左下肢 20khz
 * @param RH_100K 右上肢 100khz
 * @param LH_100K 左上肢 100khz
 * @param T_100K 躯干 100khz
 * @param RF_100K 右下肢 100khz
 * @param LF_100K 左下肢 100khz
 * @return 数据
 */
QNData *calcSpecialtyBodyData(qint height, qint gender, qint age, qdouble weight, BigFloat RH_20K, BigFloat LH_20K,
        BigFloat T_20K, BigFloat RF_20K, BigFloat LF_20K, BigFloat RH_100K, BigFloat LH_100K,
        BigFloat T_100K, BigFloat RF_100K, BigFloat LF_100K);

/**
 * 晨北广播秤算法库方法
 * @param height 身高 cm
 * @param age 年龄
 * @param gender 性别 0 女 1 男
 * @param weight 体重，kg
 * @param impedance 阻抗值，请把秤端的阻抗转成正整数
 */
char *algorithmForEtekcity(qint height, qint age, qint gender, qdouble weight,
        qint impedance);


/**
 * 晨北蓝牙秤算法库方法
 * @param height 身高 cm
 * @param age 年龄
 * @param gender 性别 0 女 1 男
 * @param weight 体重，kg
 * @param impedance 阻抗值，请把秤端的阻抗转成正整数
 */
char *algorithmForEtekcityBleScale(qint height, qint age, qint gender, qdouble weight,
        qint resistance50, qint resistance500);


#ifdef __cplusplus
}
#endif
#endif //QNCALAC_ALGORITHM_H
