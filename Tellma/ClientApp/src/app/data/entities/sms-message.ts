// tslint:disable:max-line-length
import { EntityDescriptor } from './base/metadata';
import { WorkspaceService } from '../workspace.service';
import { TranslateService } from '@ngx-translate/core';
import { EntityWithKey } from './base/entity-with-key';
import { TimeGranularity } from './base/metadata-types';

export type SmsMessageState = -4 | -3 | -2 | -1 | 0 | 1 | 2 | 3 | 4;
const smsStates = [-4, -3, -2, -1, 0, 1, 2, 3, 4];

export interface SmsMessageForQuery extends EntityWithKey {
    ToPhoneNumber?: string;
    Message?: string;
    State?: SmsMessageState;
    ErrorMessage?: string;
    StateSince?: string;
    CreatedAt?: string;
}

let _cache: EntityDescriptor;

export function metadata_SmsMessage(_: WorkspaceService, trx: TranslateService): EntityDescriptor {
    // Some global values affect the result, we check here if they have changed, otherwise we return the cached result
    const entityDesc: EntityDescriptor = {
        collection: 'SmsMessageForQuery',
        titleSingular: () => trx.instant('SmsMessage'),
        titlePlural: () => trx.instant('SmsMessages'),
        select: ['Message', 'ToPhoneNumber'],
        apiEndpoint: 'sms-messages',
        masterScreenUrl: 'sms-messages',
        orderby: () => ['Message'],
        inactiveFilter: null, // No inactive filter
        format: (item: SmsMessageForQuery) => item.Message,
        formatFromVals: (vals: any[]) => vals[0],
        properties: {
            Id: { noSeparator: true, datatype: 'numeric', control: 'number', label: () => trx.instant('Id'), minDecimalPlaces: 0, maxDecimalPlaces: 0 },
            ToPhoneNumber: { datatype: 'string', control: 'text', label: () => trx.instant('SmsMessage_ToPhoneNumber') },
            Message: { datatype: 'string', control: 'text', label: () => trx.instant('SmsMessage_Message') },
            State: {
                datatype: 'numeric',
                control: 'choice',
                label: () => trx.instant('State'),
                choices: smsStates,
                format: (state: number) => {
                    let prefix = '';
                    if (state < 0) {
                        prefix = 'minus_';
                    }

                    if (Math.abs(state) <= 2) {
                        return trx.instant('Notification_State_' + prefix + Math.abs(state));
                    } else if (!!state) {
                        return trx.instant('SmsMessage_State_' + prefix + Math.abs(state));
                    } else {
                        return '';
                    }
                },
                color: (state: number) => {
                    if (state < 0) {
                        return '#dc3545'; // Red
                    } else if (state < 3) {
                        return '#6c757d'; // Grey
                    } else {
                        return '#28a745'; // Green
                    }
                }
            },
            ErrorMessage: { datatype: 'string', control: 'text', label: () => trx.instant('SmsMessage_ErrorMessage') },
            StateSince: { datatype: 'datetimeoffset', control: 'datetime', label: () => trx.instant('StateSince'), granularity: TimeGranularity.minutes },
            CreatedAt: { datatype: 'datetimeoffset', control: 'datetime', label: () => trx.instant('CreatedAt'), granularity: TimeGranularity.minutes },
        }
    };

    _cache = entityDesc;

    return _cache;
}
