//
//  flip.c
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/4/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "flip.h"

uint16_t flip_endian16(uint16_t value) {
    uint16_t result = 0;
    result |= (value & 0xFF) << 8;
    result |= (value & 0xFF00) >> 8;
    return result;
}

uint32_t flip_endian32(uint32_t value) {
    uint32_t result = 0;
    result |= (value & 0xFF) << 24;
    result |= (value & 0xFF00) << 8;
    result |= (value & 0xFF0000) >> 8;
    result |= (value & 0xFF000000) >> 24;
    return result;
}
