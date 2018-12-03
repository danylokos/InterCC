//
//  qmi.h
//  InterCC
//
//  Created by Danylo Kostyshyn on 11/30/18.
//  Copyright © 2018 Danylo Kostyshyn. All rights reserved.
//

namespace qmi {
    typedef enum {
        CTL     = 0x00,
        WDS     = 0x01,
        DMS     = 0x02,
        NAS     = 0x03,
        QOS     = 0x04,
        WMS     = 0x05,
        PDS     = 0x06,
        AUTH    = 0x07,
        AT      = 0x08,
        VOICE   = 0x09,
        CAT2    = 0x0A,
        UIM     = 0x0B,
        PBM     = 0x0C,
        RMTFS   = 0x0D,
        LOC     = 0x0F,
        SAR     = 0x11,
        CSD     = 0x14,
        EFS     = 0x15,
        TS      = 0x17,
        TMD     = 0x18,
        CAT     = 0xE0,
        RMS     = 0xE1,
        OMA     = 0xE2
    } ServiceType;
}

typedef struct QMux QMux;

typedef unsigned int QMIClientCallback;

class ATCSIPCDriver {
    
};

class ATCSResetInvoker {
    
};
