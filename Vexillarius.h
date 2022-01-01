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

#import <Foundation/Foundation.h>

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
