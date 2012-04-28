//
//  Swim.h
//  gpsswimjam
//
//  Created by wearetitans on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Swim : NSManagedObject

@property (nonatomic, retain) NSNumber * swimDuration;
@property (nonatomic, retain) NSNumber * swimDistance;
@property (nonatomic, retain) NSDate * createdAt;

@end
