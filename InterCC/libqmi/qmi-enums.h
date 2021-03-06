/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * libqmi-glib -- GLib/GIO based library to control QMI devices
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 * Copyright (C) 2012 Google, Inc.
 * Copyright (C) 2012-2017 Aleksander Morgado <aleksander@aleksander.es>
 */

#ifndef _LIBQMI_GLIB_QMI_ENUMS_H_
#define _LIBQMI_GLIB_QMI_ENUMS_H_

//#if !defined (__LIBQMI_GLIB_H_INSIDE__) && !defined (LIBQMI_GLIB_COMPILATION)
//#error "Only <libqmi-glib.h> can be included directly."
//#endif

/**
 * SECTION: qmi-enums
 * @title: Common enumerations and flags
 *
 * This section defines common enumerations and flags used in the interface.
 */

/**
 * QmiService:
 * @QMI_SERVICE_UNKNOWN: Unknown service.
 * @QMI_SERVICE_CTL: Control service.
 * @QMI_SERVICE_WDS: Wireless Data Service.
 * @QMI_SERVICE_DMS: Device Management Service.
 * @QMI_SERVICE_NAS: Network Access Service.
 * @QMI_SERVICE_QOS: Quality Of Service service.
 * @QMI_SERVICE_WMS: Wireless Messaging Service.
 * @QMI_SERVICE_PDS: Position Determination Service.
 * @QMI_SERVICE_AUTH: Authentication service.
 * @QMI_SERVICE_AT: AT service.
 * @QMI_SERVICE_VOICE: Voice service.
 * @QMI_SERVICE_CAT2: Card Application Toolkit service (v2).
 * @QMI_SERVICE_UIM: User Identity Module service.
 * @QMI_SERVICE_PBM: Phonebook Management service.
 * @QMI_SERVICE_QCHAT: QCHAT service. Since: 1.8.
 * @QMI_SERVICE_RMTFS: Remote file system service.
 * @QMI_SERVICE_TEST: Test service. Since: 1.8.
 * @QMI_SERVICE_LOC: Location service (~ PDS v2).
 * @QMI_SERVICE_SAR: Service access proxy service.
 * @QMI_SERVICE_IMS: IMS settings service. Since: 1.8.
 * @QMI_SERVICE_ADC: Analog to digital converter driver service. Since: 1.8.
 * @QMI_SERVICE_CSD: Core sound driver service. Since: 1.8.
 * @QMI_SERVICE_MFS: Modem embedded file system service. Since: 1.8.
 * @QMI_SERVICE_TIME: Time service. Since: 1.8.
 * @QMI_SERVICE_TS: Thermal sensors service. Since: 1.8.
 * @QMI_SERVICE_TMD: Thermal mitigation device service. Since: 1.8.
 * @QMI_SERVICE_SAP: Service access proxy service. Since: 1.8.
 * @QMI_SERVICE_WDA: Wireless data administrative service. Since: 1.8.
 * @QMI_SERVICE_TSYNC: TSYNC control service. Since: 1.8.
 * @QMI_SERVICE_RFSA: Remote file system access service. Since: 1.8.
 * @QMI_SERVICE_CSVT: Circuit switched videotelephony service. Since: 1.8.
 * @QMI_SERVICE_QCMAP: Qualcomm mobile access point service. Since: 1.8.
 * @QMI_SERVICE_IMSP: IMS presence service. Since: 1.8.
 * @QMI_SERVICE_IMSVT: IMS videotelephony service. Since: 1.8.
 * @QMI_SERVICE_IMSA: IMS application service. Since: 1.8.
 * @QMI_SERVICE_COEX: Coexistence service. Since: 1.8.
 * @QMI_SERVICE_PDC: Persistent device configuration service. Since: 1.8.
 * @QMI_SERVICE_STX: Simultaneous transmit service. Since: 1.8.
 * @QMI_SERVICE_BIT: Bearer independent transport service. Since: 1.8.
 * @QMI_SERVICE_IMSRTP: IMS RTP service. Since: 1.8.
 * @QMI_SERVICE_RFRPE: RF radiated performance enhancement service. Since: 1.8.
 * @QMI_SERVICE_DSD: Data system determination service. Since: 1.8.
 * @QMI_SERVICE_SSCTL: Subsystem control service. Since: 1.8.
 * @QMI_SERVICE_CAT: Card Application Toolkit service (v1).
 * @QMI_SERVICE_RMS: Remote Management Service.
 * @QMI_SERVICE_OMA: Open Mobile Alliance device management service.
 *
 * QMI services.
 *
 * Since: 1.0
 */
typedef enum {
    QMI_SERVICE_UNKNOWN = -1,
    QMI_SERVICE_CTL = 0,
    QMI_SERVICE_WDS = 1,
    QMI_SERVICE_DMS = 2,
    QMI_SERVICE_NAS = 3,
    QMI_SERVICE_QOS = 4,
    QMI_SERVICE_WMS = 5,
    QMI_SERVICE_PDS = 6,
    QMI_SERVICE_AUTH = 7,
    QMI_SERVICE_AT = 8,
    QMI_SERVICE_VOICE = 9,
    QMI_SERVICE_CAT2 = 10,
    QMI_SERVICE_UIM = 11,
    QMI_SERVICE_PBM = 12,
    QMI_SERVICE_QCHAT = 13,
    QMI_SERVICE_RMTFS = 14,
    QMI_SERVICE_TEST = 15,
    QMI_SERVICE_LOC = 16,
    QMI_SERVICE_SAR = 17,
    QMI_SERVICE_IMS = 18,
    QMI_SERVICE_ADC = 19,
    QMI_SERVICE_CSD = 20,
    QMI_SERVICE_MFS = 21,
    QMI_SERVICE_TIME = 22,
    QMI_SERVICE_TS = 23,
    QMI_SERVICE_TMD = 24,
    QMI_SERVICE_SAP = 25,
    QMI_SERVICE_WDA = 26,
    QMI_SERVICE_TSYNC = 27,
    QMI_SERVICE_RFSA = 28,
    QMI_SERVICE_CSVT = 29,
    QMI_SERVICE_QCMAP = 30,
    QMI_SERVICE_IMSP = 31,
    QMI_SERVICE_IMSVT = 32,
    QMI_SERVICE_IMSA = 33,
    QMI_SERVICE_COEX = 34,
    /* 35, reserved */
    QMI_SERVICE_PDC = 36,
    /* 37, reserved */
    QMI_SERVICE_STX = 38,
    QMI_SERVICE_BIT = 39,
    QMI_SERVICE_IMSRTP = 40,
    QMI_SERVICE_RFRPE = 41,
    QMI_SERVICE_DSD = 42,
    QMI_SERVICE_SSCTL = 43,
    QMI_SERVICE_CAT = 224,
    QMI_SERVICE_RMS = 225,
    QMI_SERVICE_OMA = 226
} QmiService;

/**
 * qmi_service_get_string:
 *
 * Since: 1.0
 */

/**
 * QmiDataEndpointType:
 * @QMI_DATA_ENDPOINT_TYPE_HSUSB: Data Endpoint Type HSUSB.
 * @QMI_DATA_ENDPOINT_TYPE_UNDEFINED: Data Endpoint Type undefined.
 *
 * Data Endpoint Type.
 *
 * Since: 1.18
 */
typedef enum { /**< underscore_name=qmi_data_endpoint_type > */
    QMI_DATA_ENDPOINT_TYPE_HSUSB     = 0X02,
    QMI_DATA_ENDPOINT_TYPE_UNDEFINED = 0XFF,
} QmiDataEndpointType;

/**
 * qmi_data_endpoint_type_get_string:
 *
 * Since: 1.18
 */

#endif /* _LIBQMI_GLIB_QMI_ENUMS_H_ */
