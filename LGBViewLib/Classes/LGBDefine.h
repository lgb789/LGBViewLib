//
//  LGBDefine.h
//  AnimationCategory
//
//  Created by lgb789 on 2017/2/24.
//  Copyright © 2017年 com.dnj. All rights reserved.
//

#ifndef LGBDefine_h
#define LGBDefine_h

//Log
#ifdef DEBUG
    #define ZA_log(fmt,...)             NSLog(@"[%@:%d] " fmt, [[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__)
#else
    #define ZA_log(fmt,...)
#endif

#define NSStringFromBool(b)             (b ? @"YES" : @"NO")

#define ZA_logBounds(view)              ZA_log(@"%s bounds: %@", #view, NSStringFromCGRect([view bounds]))
#define ZA_logFrame(view)               ZA_log(@"%s frame: %@", #view, NSStringFromCGRect([view frame]))
#define ZA_logSize(size)                ZA_log(@"%s frame: %@", #size, NSStringFromCGSize(size))
#define ZA_logString(str)               ZA_log(@"%s : %@", #str, str)
#define ZA_logObj(obj)                  ZA_log(@"%s : %@", #obj, obj)
#define ZA_logInteger(num)              ZA_log(@"%s : %ld", #num, (long)num)
#define ZA_logFloat(num)                ZA_log(@"%s : %f", #num, num)
#define ZA_logBool(num)                 ZA_log(@"%s : %@", #num, NSStringFromBool(num))

#ifdef DEBUG
    #define ZA_SHOW_VIEW_BORDERS    YES
#else
    #define ZA_SHOW_VIEW_BORDERS    NO
#endif

#define ZA_showDebugBorderForViewColor(view, color)     if (ZA_SHOW_VIEW_BORDERS) { view.layer.borderColor = color.CGColor; view.layer.borderWidth = 1.0; }
#define ZA_showDebugBorderForView(view)                 ZA_showDebugBorderForViewColor(view, [UIColor colorWithWhite:0.0 alpha:0.25])

//Getter
#define ZA_getter(type, _name)                           return (_name = (_name == nil ? [type new] : _name))
#define ZA_getterCon(_name, con)                         return (_name = (_name == nil ? con : _name))
#define ZA_getterFunCon(type, name, _name, con)          -(type *)name { return (_name = (_name == nil ? con : _name)); }
#define ZA_getterFun(type, name, _name)                  -(type *)name { return (_name = (_name == nil ? [type new] : _name)); }

//Selector leaks
#define ZA_performSelectorLeakWarning(stuff) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        stuff; \
        _Pragma("clang diagnostic pop") \
    } while (0)

//Threading  
#define ZA_runOnMainThread          ZA_performSelectorLeakWarning(if (![NSThread isMainThread]){ dispatch_sync(dispatch_get_main_queue(), ^{ [self performSelector:_cmd]; }); return;})
#define ZA_isMainThread             NSStringFromBool([NSThread isMainThread])

//Color
#define ZA_rgba(r,g,b,a)            [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ZA_rgb(r,g,b)               ZA_rgba(r,g,b,1.0f)
#define ZA_hexRGBA(rgb, a)          ZA_rgba(((rgb & 0xFF0000) >> 16), ((rgb & 0xFF00) >> 8), (rgb & 0xFF), a)
#define ZA_hexRGB(rgb)              ZA_hexRGBA(rgb, 1.0)

#define ZA_colorRed                 [UIColor iOS7redColor]
#define ZA_colorOrange              [UIColor iOS7orangeColor]
#define ZA_colorYellow              [UIColor iOS7yellowColor]
#define ZA_colorGreen               [UIColor iOS7greenColor]
#define ZA_colorBlue                [UIColor iOS7lightBlueColor]
#define ZA_colorDarkBlue            [UIColor iOS7darkBlueColor]
#define ZA_colorPurple              [UIColor iOS7purpleColor]
#define ZA_colorPink                [UIColor iOS7pinkColor]
#define ZA_colorDarkGray            [UIColor iOS7darkGrayColor]
#define ZA_colorLightGray           [UIColor iOS7lightGrayColor]
#define ZA_colorClear               [UIColor clearColor]

//Delegate
#define ZA_appDelegate              [[UIApplication sharedApplication] delegate]

//Timer
#define ZA_invalidateTimer(t)       [t invalidate]; t = nil

//Property
#define ZA_propertyStrong(type, name)           @property (nonatomic, strong) type *name
#define ZA_propertyWeak(type, name)             @property (nonatomic, weak) type *name
#define ZA_propertyCopy(type, name)             @property (nonatomic, copy) type *name
#define ZA_propertyAssign(type, name)           @property (nonatomic, assign) type name

//Font
#define ZA_fontHeadLine                 [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
#define ZA_fontSubheadline              [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
#define ZA_fontBody                     [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
#define ZA_fontFootnote                 [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
#define ZA_fontCaption1                 [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]
#define ZA_fontCaption2                 [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]




#endif /* LGBDefine_h */
