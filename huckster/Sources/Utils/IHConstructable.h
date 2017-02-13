//
//  IHConstructable.h
//  huckster
//
//  Created by Katekov Anton on 2/11/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#ifndef IHConstructable_h
#define IHConstructable_h

#import <Foundation/Foundation.h>



@protocol IHConstructable <NSObject>

+ (id<IHConstructable>)objectFromExternalRepresentation:(id)externalRepresentation;

@end


#endif /* IHConstructable_h */
