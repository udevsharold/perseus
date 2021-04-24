//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#include <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

extern const struct VXXPCKey
{
    const char *timeout;
    const char *identifier;
    const char *type;
    const char *icon;
    const char *title;
    const char *subtitle;
    const char *leadingImageName;
    const char *leadingImagePath;
    const char *trailingImageName;
    const char *trailingImagePath;
    const char *trailingText;
    const char *backgroundColor;
} VXKey;

#ifdef __cplusplus
}
#endif
