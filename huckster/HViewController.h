//
//  HViewController.h
//  huckster
//
//  Created by Katekov Anton on 2/9/17.
//  Copyright © 2017 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HInfiniteCollectionView;



@interface HViewController : UIViewController {
    
    IBOutlet UILabel *_labelRate;
    IBOutlet UIButton *_buttonExchange;
    
    IBOutlet HInfiniteCollectionView *_collectionCurrencyFrom;
    IBOutlet HInfiniteCollectionView *_collectionCurrencyTo;
    
    IBOutlet UIImageView *_imageAnimation;
    
    IBOutlet UIPageControl *_pageCurrencyFrom;
    IBOutlet UIPageControl *_pageCurrencyTo;
    
    IBOutlet UITextField *_text;
    
    IBOutlet UIActivityIndicatorView *_activityLoading;
}


@end

