//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"
#import "PrivateHeaders.h"

typedef NS_ENUM(NSInteger, PSPokeGizmoType) {
    PSPokeGizmoTypeOnce = 1,
    PSPokeGizmoTypeDouble = 2,
    PSPokeGizmoTypeDefault = 3,
    PSPokeGizmoTypeProminent = 4
};

#ifdef __cplusplus
extern "C" {
#endif

void pokeGizmo(PSPokeGizmoType type);

#ifdef __cplusplus
}
#endif
