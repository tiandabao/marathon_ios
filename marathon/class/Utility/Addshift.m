//
//  addshift.m
//  AccuMap
//
//  Created by Acamar on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddShift.h"

@implementation AddShift

/*
 * Get offset in meters between real and fake coordinates
 */
- (GPoint) fakeLocation:(GPoint) realP
{
	GPoint offsetMeters;
	GPoint coord;
	
	coord.lat = realP.lat;
	coord.lon = realP.lon;
	
	offsetMeters = [self fakeOffset: coord];
	
	return offsetMeters;
}

/**
 * Converts latitudinal distance from meters to degrees.
 * 
 * @param meters    latitudinal distance in meters
 * 
 * @return          returns latitudinal distance in degrees
 */
- (double) convLatMeterstoDegrees:(double) meters 
{
	return meters / 111132.95;
}

/**
 * Converts longitudinal distance from meters to degrees. The desired
 * latitude is necessary for making the calculation.
 * 
 * @param meters    longitudinal distance in meters
 * @param latitude  desired latitude for distance calculation
 * 
 * @return          returns longitudinal distance in degrees
 */
- (double) convLongMeterstoDegrees:(double) meters  withLat:(double) latitude
{
	double radlat = M_PI / 180 * latitude;
	
	return 180 / M_PI * acos((cos(meters/EarthRadius) - pow(sin(radlat), 2)) / pow(cos(radlat),2));
}

- (GPoint) fakeToReal:(GPoint) fakeP
{
	GPoint realP;
	
	GPoint fakeFakeP;
	
	fakeFakeP = [self fakeLocation:fakeP];
	if(fakeFakeP.lat==0 && fakeFakeP.lon==0) 
		return fakeP;	
	
	double diffLat = [self convLatMeterstoDegrees:fakeFakeP.lat];
    double diffLon = [self convLongMeterstoDegrees:fakeFakeP.lon withLat:fakeP.lat];
	
	realP.lat = fakeP.lat - diffLat;
	realP.lon = fakeP.lon - diffLon;
	
	return realP;
}

- (GPoint) realToFake:(GPoint) ori
{
	GPoint offset = [self fakeLocation:ori];
	if(offset.lat==0.0 && offset.lon==0.0)
		return ori;
	
	GPoint fakeP;
	//Ut.dd("Offset=" + LatMMToDeg(offset.getLat()) + ", " + LonMMToDeg(offset.getLon()));
	if(offset.lat!=0 || offset.lon!=0)
	{
		double latDeg;
		double lonDeg;
		
		latDeg = [self convLatMeterstoDegrees:offset.lat];
        lonDeg = [self convLongMeterstoDegrees:offset.lon withLat:ori.lat];
		
		fakeP.lat = ori.lat + latDeg;
		fakeP.lon = ori.lon + lonDeg;
	}
	else fakeP = ori;
	//Ut.dd("Ori=" + ori.getLatitudeE6() + ", " + ori.getLongitudeE6());
	//Ut.dd("Fke=" + fakeP.getLatitudeE6() + ", " + fakeP.getLongitudeE6());
	
	return fakeP;
}


- (void)initVals
{
	EarthRadius = 6371009.0f;
		
	lon_step = 0.1;
	lat_step = 0.1;
		
	// Unified function definitions
	uLatStart = 11.0;
	uLatEnd = 54.0;
	uLonStart = 73.0;
	uLonEnd = 136.0;
		
	// 纬度X范围
	uMaxLatX = ((uLatEnd-uLatStart)/lat_step);
		
	// 经度X范围
	uMaxLonX = ((uLonEnd-uLonStart)/lon_step);
		
	// X的整图范围
	uMaxGeoX = uMaxLatX * uMaxLonX;
}

/*
 * 录入的坐标是否在合法的范围之内
 */
- (int)isValidRange:(GPoint)loc
{
	// 超出坐标，返回原来的位置
	if( loc.lat<uLatStart || loc.lat>=uLatEnd || loc.lon<uLonStart || loc.lon>=uLonEnd) return ACAMAR_FALSE;
	return ACAMAR_TRUE;
}

- (BOOL)isValidRange:(double)lat withLon:(double)lon
{
	// 超出坐标，返回原来的位置
	if( lat<uLatStart || lat>=uLatEnd || lon<uLonStart || lon>=uLonEnd) return FALSE;
	return TRUE;
}

/*
 * 统一偏移算法
 */
- (GPoint)getOffset:(GPoint)loc
{
	double a1;
	double b1;
	double c1;
	double a2;
	double b2;
	double c2;
	double a3;
	double b3;
	double c3;
	double a4;
	double b4;
	double c4;
	double a5;
	double b5;
	double c5;
	double a6;
	double b6;
	double c6;
	double a7;
	double b7;
	double c7;
	double a8;
	double b8;
	double c8;
	
	double a0;
	double w;
	
	double p1;
	double p2;
	
	// 获得经纬度
	double oLat = loc.lat;
	double oLon = loc.lon;
	
	// 以纬度为X轴的公式f(x) 中的X
	double latx = (oLat - uLatStart)/lat_step+1;
	
	// 以经度为X轴的公式 f(x) 中的X
	double lonx = (oLon - uLonStart)/lon_step+1;
	
	// 当前位置在整图的X位置
	//double geox = latx*uMaxLonX+lonx;
	
	// 开始：纬度偏移计算
	
	// 开始： 纬度偏移量噪音叠加公式 f_noise:
	p1 =    0.001001; //  (0.0009998, 0.001001)
	p2 =     -0.2909; //  (-0.2911, -0.2907)
	double lat_noise_p1 = p1*latx + p2;
	
	// f_noise 的 p2 f(x) 的叠加公式1：曲线1
	
	a1 =       315.6;
	b1 =    0.007846;
	c1 =      -2.804;
	a2 =       94.86;
	b2 =     0.02899;
	c2 =     -0.8805;
	a3 =       25.92;
	b3 =      0.1047;
	c3 =     -0.1286;
	a4 =       15.17;
	b4 =     0.04358;
	c4 =      -1.218;
	a5 =       9.061;
	b5 =     0.05788;
	c5 =      -1.121;
	a6 =       12.72;
	b6 =     0.07023;
	c6 =     -0.4499;
	a7 =       8.248;
	b7 =     0.07276;
	c7 =        2.28;
	a8 =       100.8;
	b8 =     0.01698;
	c8 =      -3.286;
	double lat_noise_p2_f1 = 
	a1*sin(b1*latx+c1) + a2*sin(b2*latx+c2) + a3*sin(b3*latx+c3) +                               
	a4*sin(b4*latx+c4) + a5*sin(b5*latx+c5) + a6*sin(b6*latx+c6) +                               
	a7*sin(b7*latx+c7) + a8*sin(b8*latx+c8);                  
	
	// f_noise 的 p2 f(x) 的叠加公式2：曲线2
	a0 =     -0.2128;
	a1 =     -0.2948;
	b1 =    -0.06413;
	a2 =     -0.5613;
	b2 =     -0.6568;
	a3 =     -0.5757;
	b3 =     -0.5303;
	a4 =     -0.2942;
	b4 =      -0.445;
	a5 =     -0.1555;
	b5 =     -0.4317;
	a6 =     -0.0118;
	b6 =     -0.3851;
	a7 =      -4.643;
	b7 =       12.28;
	w =     0.04491 ;
	
	double lat_noise_p2_f2 =
	a0 + a1*cos(latx*w) + b1*sin(latx*w) +                             
	a2*cos(2*latx*w) + b2*sin(2*latx*w) + a3*cos(3*latx*w) + b3*sin(3*latx*w) +
	a4*cos(4*latx*w) + b4*sin(4*latx*w) + a5*cos(5*latx*w) + b5*sin(5*latx*w) +
	a6*cos(6*latx*w) + b6*sin(6*latx*w) + a7*cos(7*latx*w) + b7*sin(7*latx*w);
	
	// f_noise 的 p2 f(x) 的叠加公式3：曲线3
	a0 =   -0.002346;
	a1 =      0.2574;
	b1 =      0.1603;
	a2 =      0.1051;
	b2 =    -0.02131;
	a3 =      0.3205;
	b3 =    -0.03793;
	a4 =      0.3008;
	b4 =    -0.01882;
	a5 =      -1.023;
	b5 =     -0.4526;
	a6 =     -0.4444;
	b6 =      0.5931;
	a7 =     -0.1758;
	b7 =     -0.4592;
	a8 =     -0.6219;
	b8 =      0.1205;
	w =     0.02364 ;
	double lat_noise_p2_f3 =
	a0 + a1*cos(latx*w) + b1*sin(latx*w) +                             
	a2*cos(2*latx*w) + b2*sin(2*latx*w) + a3*cos(3*latx*w) + b3*sin(3*latx*w) +
	a4*cos(4*latx*w) + b4*sin(4*latx*w) + a5*cos(5*latx*w) + b5*sin(5*latx*w) +
	a6*cos(6*latx*w) + b6*sin(6*latx*w) + a7*cos(7*latx*w) + b7*sin(7*latx*w) +
	a8*cos(8*latx*w) + b8*sin(8*latx*w);
	
	// f_noise 的 p2 f(x) 的叠加公式4：曲线4
	a1 =      0.4713;
	b1 =      0.2334;
	c1 =      -1.562;
	a2 =      0.4293;
	b2 =      0.2773;
	c2 =      -1.524;
	a3 =      0.4416;
	b3 =      0.1313;
	c3 =      -1.551;
	a4 =      0.4361;
	b4 =      0.8071;
	c4 =       2.693;
	double lat_noise_p2_f4 = 
	a1*sin(b1*latx+c1) + a2*sin(b2*latx+c2) + a3*sin(b3*latx+c3) +                               
	a4*sin(b4*latx+c4);
	
	// 第一个公式 f1 最终结果
	// Linear model Poly1:
	//       f1(x) = p1*x + p2
	double lat_noise = lat_noise_p1 * lonx + (lat_noise_p2_f1 + lat_noise_p2_f2 + lat_noise_p2_f3 + lat_noise_p2_f4);  
	// 结束：噪音公式
	
	// 开始： 纬度偏移量第一个叠加公式 f1
	p1 =      0.2492; //  (0.2434, 0.2549)
	p2 =       27.23; //  (25.13, 29.33)
	double lat_f1 = p1 * lonx + p2;
	// 结束： 纬度偏移量第一个叠加公式 f1
	
	// 开始： 纬度偏移量第二个叠加公式 f2:
	a1 =       13.37;
	b1 =      0.6283;
	c1 =     -0.6264;
	a2 =       13.34;
	b2 =       1.885;
	c2 =      -1.882;
	double lat_f2 =
	a1*sin(b1*lonx+c1) + a2*sin(b2*lonx+c2);
	// 结束： 纬度偏移量第二个叠加公式 f2:
	
	// 开始： 纬度偏移量第三个叠加公式 f3:
	a1 =       0.495;
	b1 =    0.001819;
	c1 =       5.592;
	a2 =      0.1909;
	b2 =       2.513;
	c2 =     -0.9771;
	a3 =      0.1902;
	b3 =       1.258;
	c3 =      0.3123;
	a4 =      0.1117;
	b4 =     0.03553;
	c4 =     -0.4487;
	a5 =      0.3422;
	b5 =     0.01182;
	c5 =      0.7519;
	a6 =      0.1045;
	b6 =       2.894;
	c6 =      -1.648;
	a7 =      0.1416;
	b7 =       2.522;
	c7 =       3.967;
	a8 =      0.0901;
	b8 =       2.503;
	c8 =      0.6729;
	double lat_f3 = 
	a1*sin(b1*lonx+c1) + a2*sin(b2*lonx+c2) + a3*sin(b3*lonx+c3) +                               
	a4*sin(b4*lonx+c4) + a5*sin(b5*lonx+c5) + a6*sin(b6*lonx+c6) +                               
	a7*sin(b7*lonx+c7) + a8*sin(b8*lonx+c8);                  
	// 结束： 纬度偏移量第三个叠加公式 f3:
	
	// 叠加所有的函数，得到初步精度的纬度偏移
	double lat_offset = lat_f1+lat_f2+lat_f3+lat_noise;
	
	// 纬度偏移全图修正
	// 结束：纬度偏移计算
	
	// 开始：经度偏移计算
	// 开始： 经度偏移量第噪音叠加公式 f_noise:
	// 开始：P1 的 f1
	p1 =   0.0009952; //  (0.0009945, 0.0009959)
	p2 =     -0.2898; //  (-0.29, -0.2897)
	double lon_noise_p1 = p1*latx + p2;
	// 结束：P1 的 f1
	
	// 开始：P2 的 f1
	p1 =     -0.1209; //  (-0.1214, -0.1205)
	p2 =       35.58; //  (35.46, 35.69)
	double lon_noise_p2_f1 = p1*latx + p2;
	// 结束：P2 的 f1
	
	// 开始：P2 的 f2
	a1 =       0.847;
	b1 =      0.8013;
	c1 =       3.686;
	a2 =      0.5604;
	b2 =       0.797;
	c2 =        1.07;
	a3 =       3.579;
	b3 =      0.7372;
	c3 =     -0.1955;
	a4 =      0.2644;
	b4 =      0.7688;
	c4 =      -3.215;
	a5 =      0.4317;
	b5 =      0.7817;
	c5 =       2.285;
	a6 =       3.403;
	b6 =       0.737;
	c6 =        2.93;
	a7 =      0.2168;
	b7 =       2.724;
	c7 =       2.733;
	a8 =      0.1359;
	b8 =      0.8665;
	c8 =      -2.136;
	double lon_noise_p2_f2 = 
	a1*sin(b1*latx+c1) + a2*sin(b2*latx+c2) + a3*sin(b3*latx+c3) +                               
	a4*sin(b4*latx+c4) + a5*sin(b5*latx+c5) + a6*sin(b6*latx+c6) +                               
	a7*sin(b7*latx+c7) + a8*sin(b8*latx+c8);                  
	// 结束：P2 的 f2
	double lon_noise = lon_noise_p1 * lonx + (lon_noise_p2_f1 + lon_noise_p2_f2);		
	// 结束： 经度偏移量噪音叠加公式 f1:
	
	// 开始： 经度偏移量第二个叠加公式 f2:
	a1 =        1081;
	b1 =    0.004036;
	c1 =       1.028;
	a2 =       935.7;
	b2 =    0.006012;
	c2 =       3.797;
	a3 =       40.02;
	b3 =     0.01747;
	c3 =       1.198;
	a4 =        96.7;
	b4 =     0.02651;
	c4 =        3.92;
	a5 =       26.07;
	b5 =       0.105;
	c5 =       3.982;
	a6 =       7.583;
	b6 =     0.02929;
	c6 =       5.139;
	a7 =       1.237;
	b7 =     0.09801;
	c7 =      0.4896;
	a8 =       13.03;
	b8 =       1.885;
	c8 =      -1.952;
	double lon_f1 = 
	a1*sin(b1*lonx+c1) + a2*sin(b2*lonx+c2) + a3*sin(b3*lonx+c3) +                               
	a4*sin(b4*lonx+c4) + a5*sin(b5*lonx+c5) + a6*sin(b6*lonx+c6) +                               
	a7*sin(b7*lonx+c7) + a8*sin(b8*lonx+c8);                  		// 结束： 经度偏移量第三个叠加公式 f4:
	// 结束： 经度偏移量第二个叠加公式 f2:
	
	// 开始： 经度偏移量第二个叠加公式 f2:
	a1 =       13.27;
	b1 =      0.6283;
	c1 =     -0.6262;
	a2 =       13.35;
	b2 =      0.3141;
	c2 =     -0.3084;
	double lon_f2 = a1*sin(b1*lonx+c1) + a2*sin(b2*lonx+c2);
	// 结束： 经度偏移量第二个叠加公式 f2:
	
	// 开始： 经度偏移量第三个叠加公式 f3:
	a1 =       2.246;
	b1 =    0.004683;
	c1 =      0.9955;
	a2 =       1.379;
	b2 =    0.007285;
	c2 =       2.939;
	a3 =       25.56;
	b3 =     0.05233;
	c3 =      0.8284;
	a4 =       26.89;
	b4 =     0.09638;
	c4 =      -2.291;
	a5 =       26.67;
	b5 =     0.09643;
	c5 =      0.8174;
	a6 =       25.47;
	b6 =     0.05238;
	c6 =       3.964;
	a7 =      0.2792;
	b7 =       1.882;
	c7 =     -0.4823;
	a8 =      0.3803;
	b8 =     0.03272;
	c8 =      -2.303;
	double lon_f3 = 
	a1*sin(b1*lonx+c1) + a2*sin(b2*lonx+c2) + a3*sin(b3*lonx+c3) +                               
	a4*sin(b4*lonx+c4) + a5*sin(b5*lonx+c5) + a6*sin(b6*lonx+c6) +                               
	a7*sin(b7*lonx+c7) + a8*sin(b8*lonx+c8);                  		// 结束： 经度偏移量第三个叠加公式 f4:
	
	// 开始： 经度偏移量第四个叠加公式 f4:
	a0 =   0.0008342;
	a1 =    -0.02752;
	b1 =       0.045;
	a2 =      0.2266;
	b2 =     0.02231;
	a3 =    -0.06767;
	b3 =      0.2134;
	a4 =     -0.5659;
	b4 =    -0.04908;
	a5 =     0.08506;
	b5 =     0.01836;
	w =     0.02821 ;
	double lon_f4 =
	a0 + a1*cos(lonx*w) + b1*sin(lonx*w) + 
	a2*cos(2*lonx*w) + b2*sin(2*lonx*w) + a3*cos(3*lonx*w) + b3*sin(3*lonx*w) + 
	a4*cos(4*lonx*w) + b4*sin(4*lonx*w) + a5*cos(5*lonx*w) + b5*sin(5*lonx*w);
	
	// 结束： 经度偏移量第四个叠加公式 f4:
	
	// 叠加经度的偏移量，得到较为准确的经度偏移
	double lon_offset = lon_f1+lon_f2+lon_f3+lon_f4+lon_noise;
	
	// 结束：经度偏移计算
	
	GPoint offsetMeters;
	offsetMeters.lat = lat_offset;
	offsetMeters.lon = lon_offset;
	
	return offsetMeters;
}

/* 
 *  locArray: 从Java获得的位置，Lat, Lon
 */
- (GPoint)fakeOffset: (GPoint) loc
{
	// initialize to zero
	GPoint offsetMeters;
	offsetMeters.lat = 0;
	offsetMeters.lon = 0;
	
	if( [self isValidRange:loc] == ACAMAR_TRUE )
	{
		offsetMeters = [self getOffset:loc];
	}
	return offsetMeters;
}

- (id)init {
    self = [super init];
	[self initVals];
    return self;
}

@end
