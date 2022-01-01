//    Copyright (c) 2021 udevs
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, version 3.
//
//    This program is distributed in the hope that it will be useful, but
//    WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//    General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program. If not, see <http://www.gnu.org/licenses/>.

#import "Common.h"
#import "PrivateHeaders.h"

#ifndef PERSEUSPREFS
extern long long rssiThreshold;
extern BOOL fastUnlock;
extern BOOL unlockedWithPerseus;
extern int pokeType;
extern BOOL enabled;
extern BOOL banner;
extern BOOL unlockApps;
extern BOOL inSession;
#endif //PERSEUSPREFS

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
