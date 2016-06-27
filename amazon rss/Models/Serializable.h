//
//  Serializable.h
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Serializable <NSObject>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)serialize;

@end
