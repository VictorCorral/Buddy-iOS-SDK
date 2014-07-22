//
//  BPMetrics.h
//  BuddySDK
//
//  Created by Erik Kerber on 2/2/14.
//
//

#import <Foundation/Foundation.h>

typedef void (^BuddyTimedMetricResult)(NSInteger elapsedTimeInMs, NSError *error);


@interface BPMetricCompletionHandler : NSObject

- (instancetype)initWithMetricId:(NSString *)metricId andClient:(id<BPRestProviderOld>)restProvider;

- (void)signalComplete:(BuddyTimedMetricResult)callback __attribute__ ((deprecated));

- (void)finishMetric:(BuddyTimedMetricResult)callback;


@end

typedef void (^BuddyMetricCallback)(BPMetricCompletionHandler *metricCompletionHandler, NSError *error);
