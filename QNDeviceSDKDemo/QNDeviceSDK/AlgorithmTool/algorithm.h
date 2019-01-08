//
// Created by 黄敦仁 on 17/6/5.
//

#ifndef QNCALAC_ALGORITHM_H
#define QNCALAC_ALGORITHM_H

#define MAX_BODYFAT_VALUE 70.0


#define SINGLE_FREQUENCY 2
#define DOUBLE_FREQUENCY_V1 3
#define DOUBLE_FREQUENCY_V2 4
#define SINGLE_FREQUENCY_V2 5

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
    qdouble bone;//骨量
    qdouble protein;//蛋白质
    qdouble score; //分数
    qint bodyAge; //体年龄
    qint bodyShape; //体型
} QNData;

    
    
    /**
     * 算法入口
     * @param version 算法版本，2 ：两电极算法 3 ：四电极V1 4 ：四电极V2
     * @param height 身高 cm
     * @param age 年龄
     * @param gender 性别 0 ：女 1 ：男
     * @param weight 体重 kg
     * @param resistance 50khz的电阻 低频
     * @param resistance500 500khz的电阻 高频
     * @return QNData
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
     * @return QNData
     */
    QNData *algorithmWithAthlete(qint version, qint height, qint age, qint gender, qdouble weight,
                                 qint resistance, qint resistance500,qint isAthlete);
    
    /**
     * 根据心率以及身体资料计算心脏指数
     * @param height 身高 cm
     * @param age 年龄
     * @param gender 性别 0 ：女 1 ：男
     * @param weight 体重 kg
     * @param heartRate 心率
     * @return 返回心脏指数，单位是  L/min/m^2
     */
    qdouble calcHeartIndex(qint height, qint age, qint gender, qdouble weight, qint heartRate);
    
    
    qint calcBodyShape(qdouble bodyfat,qdouble bmi,qint gender);
    
    qdouble calcBmi(qint height, qdouble weight);

#endif //QNCALAC_ALGORITHM_H
