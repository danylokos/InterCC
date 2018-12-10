//
//  qmi.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 12/12/18.
//  Copyright © 2018 Danylo Kostyshyn. All rights reserved.
//

#include "qmi.h"

#include "util.h"

//#define DEBUG_MAC
#ifdef DEBUG_MAC
#define qmilog printf
#define BYTE_COLOR ""
#define BYTE_COLOR_NRM ""
#else
#define BYTE_COLOR FGGRN
#define BYTE_COLOR_NRM FGNRM
#endif

const char *get_qmi_service_name(QmiService service) {
    switch (service) {
        case QMI_SERVICE_CTL: return "CTL";
        case QMI_SERVICE_WDS: return "WDS";
        case QMI_SERVICE_DMS: return "DMS";
        case QMI_SERVICE_NAS: return "NAS";
        case QMI_SERVICE_QOS: return "QOS";
        case QMI_SERVICE_WMS: return "WMS";
        case QMI_SERVICE_PDS: return "PDS";
        case QMI_SERVICE_AUTH: return "AUTH";
        case QMI_SERVICE_AT: return "AT";
        case QMI_SERVICE_VOICE: return "VOICE";
        case QMI_SERVICE_CAT2: return "CAT2";
        case QMI_SERVICE_UIM: return "UIM";
        case QMI_SERVICE_PBM: return "PBM";
        case QMI_SERVICE_QCHAT: return "QCHAT";
        case QMI_SERVICE_RMTFS: return "RMTFS";
        case QMI_SERVICE_TEST: return "TEST";
        case QMI_SERVICE_LOC: return "LOC";
        case QMI_SERVICE_SAR: return "SAR";
        case QMI_SERVICE_IMS: return "IMS";
        case QMI_SERVICE_ADC: return "ADC";
        case QMI_SERVICE_CSD: return "CSD";
        case QMI_SERVICE_MFS: return "MFS";
        case QMI_SERVICE_TIME: return "TIME";
        case QMI_SERVICE_TS: return "TS";
        case QMI_SERVICE_TMD: return "TMD";
        case QMI_SERVICE_SAP: return "SAP";
        case QMI_SERVICE_WDA: return "WDA";
        case QMI_SERVICE_TSYNC: return "TSYNC";
        case QMI_SERVICE_RFSA: return "RFSA";
        case QMI_SERVICE_CSVT: return "CSVT";
        case QMI_SERVICE_QCMAP: return "QCMAP";
        case QMI_SERVICE_IMSP: return "IMSP";
        case QMI_SERVICE_IMSVT: return "IMSVT";
        case QMI_SERVICE_IMSA: return "IMSA";
        case QMI_SERVICE_COEX: return "COEX";
        case QMI_SERVICE_PDC: return "PDC";
        case QMI_SERVICE_STX: return "STX";
        case QMI_SERVICE_BIT: return "BIT";
        case QMI_SERVICE_IMSRTP: return "IMSRTP";
        case QMI_SERVICE_RFRPE: return "RFRPE";
        case QMI_SERVICE_DSD: return "DSD";
        case QMI_SERVICE_SSCTL: return "SSCTL";
        case QMI_SERVICE_CAT: return "CAT";
        case QMI_SERVICE_RMS: return "RMS";
        case QMI_SERVICE_OMA: return "OMA";
        default: return "Unknown";
    }
}

#pragma mark -

typedef enum {
    qmi_ctl_flag_request = 0b00,
    qmi_ctl_flag_response = 0b01,
    qmi_ctl_flag_indication = 0b10,
    qmi_ctl_flag_reserved = 0b11,
} qmi_ctl_flag;

bool is_qmi_ctl_request(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_request) & 0b11) == 0;
}

bool is_qmi_ctl_response(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_response) & 0b11) == 0;
}

bool is_qmi_ctl_indication(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_indication) & 0b11) == 0;
}

bool is_qmi_ctl_reserved(uint8_t flags) {
    return ((flags ^ qmi_ctl_flag_reserved) & 0b11) == 0;
}

const char *qmi_ctl_flag_name(uint8_t flags) {
    if (is_qmi_ctl_request(flags)) {
        return "↑ REQ";
    } else if (is_qmi_ctl_response(flags)) {
        return "↓ RESP";
    } else if (is_qmi_ctl_indication(flags)) {
        return "→ IND";
    } else if (is_qmi_ctl_reserved(flags)) {
        return "RSRV";
    }
    return NULL;
}

#pragma mark -

void print_qmi_message(uint8_t *raw);
void print_tlvs(uint8_t *raw_tlv, uint8_t raw_tlv_length);

char *bits_to_str(uint8_t byte);

#define QMI_MESSAGE_QMUX_MARKER (uint8_t) 0x01

void print_qmi_message(uint8_t *raw) {
    full_message *message = (full_message *)raw;
    qmilog("marker: %s0x%02x%s\n", BYTE_COLOR, message->marker, BYTE_COLOR_NRM);
    if (message->marker != QMI_MESSAGE_QMUX_MARKER) {
        qmilog("not valid QMUX header\n");
        return;
    }
    qmilog("qmux.length: %s0x%04x%s (%d)\n", BYTE_COLOR, message->qmux.length, BYTE_COLOR_NRM, message->qmux.length);
    char *bits_str = bits_to_str(message->qmux.flags);
    
    qmilog("qmux.flags: %s0x%02x%s (%s)\n", BYTE_COLOR, message->qmux.flags, BYTE_COLOR_NRM, bits_str);
    free(bits_str);
    const char *service_name = get_qmi_service_name((QmiService)message->qmux.service);
    qmilog("qmux.service: %s0x%02x%s (%s)\n", BYTE_COLOR, message->qmux.service, BYTE_COLOR_NRM, service_name);
    qmilog("qmux.client: %s0x%02x%s\n", BYTE_COLOR, message->qmux.client, BYTE_COLOR_NRM);
    if (message->qmux.service == QMI_SERVICE_CTL) {
        char *bits_str = bits_to_str(message->qmi.control.header.flags);
        qmilog("qmi.control.header.flags: %s0x%02x%s (%s) (%s)\n", BYTE_COLOR, message->qmi.control.header.flags, BYTE_COLOR_NRM, bits_str, qmi_ctl_flag_name(message->qmi.control.header.flags));
        free(bits_str);
        qmilog("qmi.control.header.transaction: %s0x%02x%s\n", BYTE_COLOR, message->qmi.control.header.transaction, BYTE_COLOR_NRM);
        qmilog("qmi.control.header.message: %s0x%04x%s\n", BYTE_COLOR, message->qmi.control.header.message, BYTE_COLOR_NRM);
        qmilog("qmi.control.header.tlv_length: %s0x%04x%s (%d)\n", BYTE_COLOR, message->qmi.control.header.tlv_length, BYTE_COLOR_NRM, message->qmi.control.header.tlv_length);
        
        print_tlvs((uint8_t *)message->qmi.control.tlv, message->qmi.control.header.tlv_length);
    } else {
        char *bits_str = bits_to_str(message->qmi.service.header.flags);
        qmilog("qmi.service.header.flags: %s0x%02x%s (%s)\n", BYTE_COLOR, message->qmi.service.header.flags, BYTE_COLOR_NRM, bits_str);
        free(bits_str);
        qmilog("qmi.service.header.transaction: %s0x%04x%s\n", BYTE_COLOR, message->qmi.service.header.transaction, BYTE_COLOR_NRM);
        qmilog("qmi.service.header.message: %s0x%04x%s\n", BYTE_COLOR, message->qmi.service.header.message, BYTE_COLOR_NRM);
        qmilog("qmi.service.header.tlv_length: %s0x%04x%s (%d)\n", BYTE_COLOR, message->qmi.service.header.tlv_length, BYTE_COLOR_NRM, message->qmi.service.header.tlv_length);
        
        print_tlvs((uint8_t *)message->qmi.service.tlv, message->qmi.service.header.tlv_length);
    }
}

void print_tlvs(uint8_t *raw_tlv, uint8_t raw_tlv_length) {
    uint16_t tlv_idx = 0;
    uint16_t offset = 0;
    while (offset < raw_tlv_length) {
        tlv *tlv_p = (tlv *)&(raw_tlv[offset]);
        
        qmilog("\tqmi.service.tlv[%hu].tlv_type: %s0x%02x%s\n", tlv_idx, BYTE_COLOR, tlv_p->type, BYTE_COLOR_NRM);
        qmilog("\tqmi.service.tlv[%hu].tlv_length: %s0x%04x%s (%d)\n", tlv_idx, BYTE_COLOR, tlv_p->length, BYTE_COLOR_NRM, tlv_p->length);
        if (tlv_p->length > 0) {
            qmilog("\tqmi.service.tlv[%hu].tlv_value:\n", tlv_idx);
#ifdef DEBUG_MAC
            fhexdump(stdout, tlv_p->value, tlv_p->length);
#else
            hexdumpcc(tlv_p->value, tlv_p->length, BYTE_COLOR);
#endif
        }

        uint16_t next_tlv_offset = sizeof(tlv) + tlv_p->length;
        offset += next_tlv_offset;
        
        tlv_idx++;
    }
}

#define BITS_NUM 8

char *bits_to_str(uint8_t byte) {
    char *str = (char *)malloc(sizeof(char) * 10);
    size_t extra_char = 0;
    for (size_t i=0; i<BITS_NUM; i++) {
        if (i == BITS_NUM/2) {
            sprintf(str + i, " %d", (byte >> (BITS_NUM-1-i)) & 0x01);
            extra_char += 1;
        } else {
            sprintf(str + i + extra_char, "%d", (byte >> (BITS_NUM-1-i)) & 0x01);
        }
    }
    return str;
}
