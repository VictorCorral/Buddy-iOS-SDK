//
//  BPLocation.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/9/14.
//
//

@protocol BPLocationProperties <BuddyObjectProperties>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *fax;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) BOOL isPublic;

@end

@interface BPSearchLocation : BPObjectSearch<BPLocationProperties>

@end

@interface BPLocation : BuddyObject<BPLocationProperties>

@end
