import { EntitiesResponse } from './dto/entities-response';
import { WorkspaceService, TenantWorkspace } from './workspace.service';
import { GetByIdResponse } from './dto/get-by-id-response';
import { EntityWithKey } from './entities/base/entity-with-key';
import { HttpErrorResponse } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { from, Observable, Observer, throwError } from 'rxjs';
import {
  EntityDescriptor, Control, PropVisualDescriptor
} from './entities/base/metadata';
import { formatNumber } from '@angular/common';
import { insert, set, getSelection } from 'text-field-edit';
import { concatMap, map } from 'rxjs/operators';
import { Calendar, DateGranularity, DateTimeGranularity, TimeGranularity } from './entities/base/metadata-types';

// This handy function takes the entities from the response and all their related entities
// adds them to the workspace indexed by their IDs and returns the IDs of the entities
// this pattern ensures that entities are not spread everywhere in the app, but are
// maintained in a centralized workspace instead, so an update to the entity name for example
// will see that reflected updated everywhere where that name is displayed
export function addToWorkspace(response: EntitiesResponse, workspace: WorkspaceService): (number | string)[] {

  // Merge fresh entities in the workspace
  const relatedEntities = response.RelatedEntities;
  mergeEntitiesInWorkspace(relatedEntities, workspace);

  const result = {};
  result[response.CollectionName] = response.Result;
  mergeEntitiesInWorkspace(result, workspace);

  // Notify everyone
  workspace.notifyStateChanged();

  // Return the IDs of the main entities
  return response.Result.map(e => e.Id);
}

export function addSingleToWorkspace(response: GetByIdResponse, workspace: WorkspaceService): (number | string) {

  // Merge fresh entities in the workspace
  const entities = response.RelatedEntities;
  mergeEntitiesInWorkspace(entities, workspace);

  const result = {};
  result[response.CollectionName] = [response.Result];
  mergeEntitiesInWorkspace(result, workspace);

  // Notify everyone
  workspace.notifyStateChanged();

  // Return the ID of the result
  return response.Result.Id;
}

export function mergeEntitiesInWorkspace(entities: { [key: string]: EntityWithKey[] }, workspace: WorkspaceService) {
  if (!!entities) {
    const collectionNames = Object.keys(entities);
    for (const collectionName of collectionNames) {
      const collection = entities[collectionName];
      const wsCollection = workspace.current[collectionName];
      if (!wsCollection) {
        // dev mistake
        console.error(`Could not find collection '${collectionName}' in the workspace`);
      }

      for (const freshItem of collection) {
        const staleItem = wsCollection[freshItem.Id];
        apply(freshItem, staleItem, wsCollection);
      }
    }
  }
}

function apply(freshItem: EntityWithKey, staleItem: EntityWithKey, wsCollection: any) {
  if (!!staleItem) {
    wsCollection[freshItem.Id] = JSON.parse(JSON.stringify(merge(freshItem, staleItem)));
  } else {
    wsCollection[freshItem.Id] = freshItem;
  }
}

function merge(freshItem: EntityWithKey, staleItem: EntityWithKey): EntityWithKey {

  // every property in the DTO tree is tagged with metadata, either loaded = 2, restricted = 1 or not loaded = 0
  // this method merges two DTOs the stale on the client and the fresh one from the server, it recursively
  // traverses the DTO tree and copies the fields one by one, the field value with the higher metadata wins
  // for example if a field comes from the server restricted = 1, and on the client loaded = 2, the client value wins

  // LIMITATION: this doesn't currently support arrays of arrays, but for now we don't execpt any to come by since
  // DTOs are loaded directly from EF which won't generate such a DTO

  const staleMetadata = staleItem.EntityMetadata;
  const freshMetadata = freshItem.EntityMetadata;

  const result = staleItem; // to force update the UI bindings
  result.Id = freshItem.Id;

  const metadataArray = Object.keys(freshItem.EntityMetadata).concat(Object.keys(staleItem.EntityMetadata));
  metadataArray.forEach(prop => {
    const freshPropMetadata = freshMetadata[prop] || 0;
    const stalePropMetadata = staleMetadata[prop] || 0;
    const freshValue = freshItem[prop];
    const staleValue = staleItem[prop];

    if (freshPropMetadata >= stalePropMetadata) {
      result[prop] = freshValue;
      result.EntityMetadata[prop] = freshPropMetadata;
    } else {
      result[prop] = staleValue;
      result.EntityMetadata[prop] = stalePropMetadata;
    }

    // if the property is a navigation property or an array, and both values
    // are not null then it's not one or the other, we have to merge them
    if (!!freshValue && !!staleValue && freshPropMetadata === 2 && stalePropMetadata === 2) {
      if (!!freshValue.EntityMetadata || !!staleValue.EntityMetadata) {
        // a navigation property, call merge recursively
        result[prop] = merge(freshValue, staleValue);
      } else if (freshValue.constructor === Array || staleValue.constructor === Array) {
        result[prop] = mergeArrays(freshValue, staleValue);
      }
    }
  });

  return result;
}

function mergeArrays(freshArray: EntityWithKey[], staleArray: EntityWithKey[]): EntityWithKey[] {
  // to efficiently retrieve the lines in the stale array, this pays off for huge arrays
  const staleArrayHash: { [id: string]: EntityWithKey } = {};
  staleArray.forEach(staleLine => {
    staleArrayHash[staleLine.Id] = staleLine;
  });

  for (let i = 0; i < freshArray.length; i++) {
    const freshLine = freshArray[i];
    const staleLine = staleArrayHash[freshLine.Id];

    if (!!staleLine) {
      freshArray[i] = merge(freshLine, staleLine);
    }
  }

  return freshArray;
}

function safeToOpenDirectly(blob: Blob): boolean {
  switch (blob.type) {
    case 'application/pdf':
    case 'image/jpeg':
    case 'image/png':
      return true;
  }
  return false;
}

export function downloadBlob(blob: Blob, fileName: string) {
  // Helper function to download a blob from memory to the user's computer,
  // Without having to open a new window first
  if (window.navigator && window.navigator.msSaveOrOpenBlob) {
    // To support IE and Edge
    if (safeToOpenDirectly(blob)) {
      window.navigator.msSaveOrOpenBlob(blob, fileName);
    } else {
      window.navigator.msSaveBlob(blob, fileName);
    }
  } else {

    // Create an in memory url for the blob, further reading:
    // https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL
    const url = window.URL.createObjectURL(blob);

    if (safeToOpenDirectly(blob)) {
      // Opens the file in a new browser tab
      window.open(url);

      // const win = window.open();

      // // Title
      // const title = win.document.createElement('title');
      // title.appendChild(win.document.createTextNode(fileName));

      // // Icon
      // const link = win.document.createElement('link');
      // link.rel = 'icon';
      // // link.type = 'image/x-icon';
      // link.href = 'favicon.ico';


      // // Body
      // const iframe = win.document.createElement('iframe');
      // iframe.src = url;
      // iframe.width = '100%';
      // iframe.height = '100%';
      // iframe.style.border = 'none';

      // win.document.head.appendChild(title);
      // win.document.head.appendChild(link);
      // win.document.body.appendChild(iframe);
      // win.document.body.style.margin = '0';

    } else {
      // Below is a trick for downloading files without opening a new browser tab
      const a = document.createElement('a');
      a.href = url;
      a.download = fileName || 'file';
      a.click();
    }

    // Best practice to prevent a memory leak, especially in a SPA
    window.URL.revokeObjectURL(url);
  }
}

const _maxAttachmentSize = 20 * 1024 * 1024;

export function onFileSelected(
  input: HTMLInputElement,
  pendingFilesSize: number,
  translate: TranslateService) {
  const files = input.files as FileList;
  if (!files) {
    return;
  }

  // Convert the FileList to an array
  const filesArray: File[] = [];
  // tslint:disable-next-line:prefer-for-of
  for (let i = 0; i < files.length; i++) {
    filesArray.push(files[i]);
  }

  // Clear the input field
  input.value = '';

  // Calculate total size of files
  const totalSize = filesArray
    .map(e => e.size || 0)
    .reduce((total, v) => total + v, 0);

  // Make sure total size of selected files doesn't exceed maximum size
  if (totalSize > _maxAttachmentSize) {
    const msg = translate.instant('Error_FileSizeExceedsMaximumSizeOf0', { size: fileSizeDisplay(_maxAttachmentSize) });
    return throwError(msg);
  }

  if (pendingFilesSize + totalSize > _maxAttachmentSize) {
    const msg = translate.instant('Error_PendingFilesExceedMaximumSizeOf0', { size: fileSizeDisplay(_maxAttachmentSize) });
    return throwError(msg);
  }

  return from(filesArray).pipe(
    map(file => getDataURL(file).pipe(map(dataUrl => ({ file, dataUrl })))),
    concatMap(obs => obs),
    map(({ file, dataUrl }) => {
      // Get the base64 value from the data URL
      const commaIndex = dataUrl.indexOf(',');
      const fileBytes = dataUrl.substr(commaIndex + 1);
      const fileNamePieces = file.name.split('.');
      const extension = fileNamePieces.length > 1 ? fileNamePieces.pop() : null;
      const fileName = fileNamePieces.join('.') || '???';

      const attachment = {
        Id: null,
        File: fileBytes,
        FileName: fileName,
        FileExtension: extension,
      };

      return { attachment, file };
    })
  );

  // const observables = filesArray.map(file => getDataURL(file).pipe(
  //   map(dataUrl => {
  //     // Get the base64 value from the data URL
  //     const commaIndex = dataUrl.indexOf(',');
  //     const fileBytes = dataUrl.substr(commaIndex + 1);
  //     const fileNamePieces = file.name.split('.');
  //     const extension = fileNamePieces.length > 1 ? fileNamePieces.pop() : null;
  //     const fileName = fileNamePieces.join('.') || '???';

  //     const attachment = {
  //       Id: null,
  //       File: fileBytes,
  //       FileName: fileName,
  //       FileExtension: extension,
  //     };

  //     return { attachment, file };
  //   })
  // ));

  // return zip(observables);
}

export enum Key {
  Tab = 'Tab',
  Enter = 'Enter',
  Escape = 'Escape',
  Space = 'Space',
  ArrowLeft = 'ArrowLeft',
  ArrowUp = 'ArrowUp',
  ArrowRight = 'ArrowRight',
  ArrowDown = 'ArrowDown'
}

/**
 * Useful in forms to determine if a required value is specified
 * @param value the value that the
 */
export function isSpecified(value: any) {
  return !!value || value === 0 || value === false;
}

// Processed http error
export interface FriendlyError {
  status: number;
  error: any;
}

// Function to turn status codes into friendly localized human-readable errors
export function friendlify(error: any, trx: TranslateService): FriendlyError {
  const friendlyStructure = (status: number, err: any) => {
    return {
      status,
      error: err
    };
  };

  // Translates HttpClient's errors into human-friendly errors
  if (error instanceof HttpErrorResponse) {
    const res = error as HttpErrorResponse;

    switch (res.status) {
      case 0: // Offline
      case 504: // Service worker reports
        return friendlyStructure(res.status, trx.instant('Error_UnableToReachServer'));

      case 400: // Bad Request
      case 422: // Unprocessible entity
        // These two status codes mean a friendly error is already coming from the server
        return friendlyStructure(res.status, res.error);

      case 401:  // Unauthorized
        return friendlyStructure(res.status, trx.instant('Error_LoginSessionExpired'));

      case 403:  // Forbidden
        return friendlyStructure(res.status, trx.instant('Error_AccountDoesNotHaveSufficientPermissions'));

      case 404: // Not found
        return friendlyStructure(res.status, trx.instant('Error_RecordNotFound'));

      case 500:  // Internal Server Error
        return friendlyStructure(res.status, trx.instant('Error_UnhandledServerError'));

      default:  // Any other HTTP error
        return friendlyStructure(res.status, trx.instant('Error_UnkownServerError'));
    }

  } else {
    console.error(error);
    return friendlyStructure(null, trx.instant('Error_UnkownClientError'));
  }
}

export function getDataURL(blob: Blob): Observable<string> {
  const reader = new FileReader();
  const obs$ = new Observable<string>((obs: Observer<string>) => {
    // implement the observable contract based on reader
    reader.onloadend = () => {

      const data = reader.result as string;
      obs.next(data);
      obs.complete();
    };

    reader.onerror = (e) => {
      obs.error(e);
    };
  });

  reader.readAsDataURL(blob);
  return obs$;
}

export function fileSizeDisplay(fileSize: number): string {
  if (fileSize === null || fileSize === undefined) {
    return '';
  }

  let unitIndex = 0;
  const stepSize = 1024;
  while (fileSize >= stepSize || -fileSize >= stepSize) {
    fileSize /= stepSize;
    unitIndex++;
  }
  return (unitIndex ? fileSize.toFixed(1) : fileSize) + ' KMGTPEZY'[unitIndex] + 'B';
}

export function computeSelectForDetailsPicker(desc: EntityDescriptor, additionalSelect: string): string {
  // Computes the select parameter for details picker and the details screen in popup mode
  const resultPaths: { [key: string]: true } = {};

  // Basic select
  if (!!desc.select) {
    desc.select.forEach(s => resultPaths[s] = true);
  }

  if (!!desc.definitionIds) {
    resultPaths.DefinitionId = true;
  }

  // custom select
  if (!!additionalSelect) {
    additionalSelect.split(',').forEach(s => resultPaths[s] = true);
  }

  return Object.keys(resultPaths).join(',');
}

function closePrint() {
  // Cleanup duty once the user closes the print dialog
  document.body.removeChild(this.__container__);
  window.URL.revokeObjectURL(this.__url__);
}

function setPrintFactory(url: string): () => void {
  // As soon as the iframe is loaded and ready
  return function setPrint() {
    this.contentWindow.__container__ = this;
    this.contentWindow.__url__ = url;
    this.contentWindow.onbeforeunload = closePrint;
    this.contentWindow.onafterprint = closePrint;
    this.contentWindow.focus(); // Required for IE
    this.contentWindow.print();
  };
}

/**
 * Attaches the given blob in a hidden iFrame and calls print() on
 * that iframe, and then takes care of cleanup duty afterwards.
 * This function was inspired from MDN: https://mzl.la/2YfOs1v
 */
export function printBlob(blob: Blob): void {
  const url = window.URL.createObjectURL(blob);
  const iframe = document.createElement('iframe');
  iframe.onload = setPrintFactory(url);
  iframe.style.position = 'fixed';
  iframe.style.right = '0';
  iframe.style.bottom = '0';
  iframe.style.width = '0';
  iframe.style.height = '0';
  iframe.style.border = '0';
  iframe.sandbox.add('allow-same-origin');
  iframe.sandbox.add('allow-modals');
  iframe.src = url;
  document.body.appendChild(iframe);
}

// IMPORTANT: Keep in sync with function in CsvPackager.cs
export function csvPackage(data: string[][]): Blob {

  if (!data) {
    throw new Error(`The data is null`);
  }

  if (data.length === 0) {
    throw new Error(`Must supply the CSV header at least`);
  }

  const columnCount = data[0].length;
  const resultArray: string[] = [];
  const newLine = `
`;

  for (const row of data) {
    if (row.length !== columnCount) {
      throw new Error(`Number of columns is inconsistent across rows`);
    }

    const rowString: string = row.map(field => processFieldForCsv(field)).join(',');
    resultArray.push(rowString);
  }

  const result = resultArray.join(newLine);
  return new Blob(['\ufeff' + result], { type: 'text/csv' });
}

// IMPORTANT: Keep in sync with function in CsvPackager.cs
function processFieldForCsv(field: string) {
  if (field == null) {
    // Null in - Null out
    return null;
  }

  // Escape every double quote with another double quote
  field = field.replace(/"/g, '""');

  // Surround any field that contains double quotes, new lines, or commas with double quotes
  if (field.indexOf('"') > -1 || field.indexOf(',') > -1 || field.indexOf('\n') > -1 || field.indexOf('\r') > -1) {
    field = `"${field}"`;
  }

  // Return the processed field
  return field;
}

export interface ColumnDescriptor {
  path: string;
  display?: string;
}

/**
 * Overrides the default behavior of the TAB key and implements insertion of tab and block
 * indentation instead, for a more natural experience for textareas used to edit code
 */
export function onCodeTextareaKeydown(txtarea: HTMLTextAreaElement, e: KeyboardEvent, setter: (x: string) => void) {
  if ((e.keyCode || e.which) === 9) {

    // Prevent TAB's default behavior
    e.preventDefault();

    // IF the user highlight spans multiple lines, we indent all the highlighted lines (block-indent)
    const selection = getSelection(txtarea);
    if (!!selection && /\r|\n/.test(selection)) {

      // Get selection boundaries
      const selectionFrom = Math.min(txtarea.selectionStart, txtarea.selectionEnd);
      const selectionTo = Math.max(txtarea.selectionStart, txtarea.selectionEnd);

      // Get the entire text
      const text = txtarea.value;

      // Find the beginning of the first highlighted line
      let startOfFirstLine = selectionFrom;
      while (startOfFirstLine > 0) {
        if (text[startOfFirstLine - 1] === '\n') {
          break;
        }
        startOfFirstLine--;
      }

      // Split the text on the selection boundaries
      const before = text.slice(0, startOfFirstLine);
      const after = text.slice(selectionTo);
      let between = text.slice(startOfFirstLine, selectionTo);

      // Indent all lines in the between section
      between = '\t' + between.replace(/\r|\n/g, '\n\t');

      // Reassemble the pieces and replace the textarea contents with the new result
      const finalText = before + between + after;
      set(txtarea, finalText);

      // Reset the selection where it was before pressing TAB
      txtarea.selectionStart = selectionFrom + (startOfFirstLine === selectionFrom ? 0 : 1); // +1 To account for the extra tab
      txtarea.selectionEnd = before.length + between.length;
    } else {
      // ELSE: Relies on text-field-edit to insert an undo-able tab character
      insert(txtarea, '\t');
    }
  }
}

export function colorFromExtension(extension: string): string {
  const icon = iconFromExtension(extension);
  switch (icon) {
    case 'file-pdf': return '#CA342B';
    case 'file-word': return '#345692';
    case 'file-excel': return '#316F3E';
    case 'file-powerpoint': return '#BD4D2D';
    case 'file-archive': return '#E5BE36';
    case 'file-image': return '#3E7A7E';
    case 'file-video': return '#A12F5E'; // CC5747
    case 'file-audio': return '#BA7D27';

    case 'file-alt': // text files
    case 'file': return '#6c757d';
  }

  return null;
}

export function iconFromExtension(extension: string): string {
  if (!extension) {
    return 'file';
  } else {
    extension = extension.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'file-pdf';

      case 'doc':
      case 'docx':
        return 'file-word';

      case 'xls':
      case 'xlsx':
        return 'file-excel';

      case 'ppt':
      case 'pptx':
        return 'file-powerpoint';

      case 'txt':
      case 'rtf':
        return 'file-alt';

      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
        return 'file-archive';

      case 'jpg':
      case 'jpeg':
      case 'jpe':
      case 'jif':
      case 'jfif':
      case 'jfi':
      case 'png':
      case 'ico':
      case 'gif':
      case 'webp':
      case 'tiff':
      case 'tif':
      case 'psd':
      case 'raw':
      case 'arw':
      case 'cr2':
      case 'nrw':
      case 'k25':
      case 'bmp':
      case 'dib':
      case 'heif':
      case 'heic':
      case 'ind':
      case 'indd':
      case 'indt':
      case 'jp2':
      case 'j2k':
      case 'jpf':
      case 'jpx':
      case 'jpm':
      case 'mj2':
      case 'svg':
      case 'svgz':
      case 'ai':
      case 'eps':
        return 'file-image';

      case 'mpg':
      case 'mp2':
      case 'mpeg':
      case 'mpe':
      case 'mpv':
      case 'ogg':
      case 'mp4':
      case 'm4p':
      case 'm4v':
      case 'avi':
      case 'wmv':
      case 'mov':
      case 'qt':
      case 'flv':
      case 'swf':
        return 'file-video';

      case 'mp3':
      case 'aac':
      case 'wma':
      case 'flac':
      case 'alac':
      case 'wav':
      case 'aiff':
        return 'file-audio';

      default:
        return 'file';
    }
  }
}

/**
 * Constructs a PropDescriptor from scratch or overrides and existing one using the provided control and control options values.
 */
export function descFromControlOptions(
  ws: TenantWorkspace,
  control: Control,
  optionsJSON: string,
  desc?: PropVisualDescriptor): PropVisualDescriptor {

  // Optimization: Nothing to override
  if (!!desc && desc.control === control && !optionsJSON) {
    return desc;
  }

  let options: any;
  if (!!optionsJSON) {
    try {
      options = JSON.parse(optionsJSON);
    } catch { }
  }
  options = options || {};

  desc = desc || { control: 'text' }; // Makes the subsequent logic tidier
  control = control || desc.control;

  switch (control) {
    case 'null':
    case 'unsupported':
    case 'text':
    case 'check':
      return { control };

    case 'date': {
      let granularity: DateGranularity = DateGranularity.days;
      if (isSpecified(options.granularity)) {
        granularity = options.granularity;
      } else if (desc.control === 'date') {
        granularity = desc.granularity;
      }

      let calendar: Calendar;
      if (isSpecified(options.calendar)) {
        calendar = options.calendar;
      } else if (desc.control === 'date') {
        calendar = desc.calendar;
      }

      return { control, granularity, calendar };
    }
    case 'datetime': {
      let granularity: DateTimeGranularity = TimeGranularity.minutes;
      if (isSpecified(options.granularity)) {
        granularity = options.granularity;
      } else if (desc.control === 'datetime') {
        granularity = desc.granularity;
      }

      let calendar: Calendar;
      if (isSpecified(options.calendar)) {
        calendar = options.calendar;
      } else if (desc.control === 'datetime') {
        calendar = desc.calendar;
      }

      return { control, granularity, calendar };
    }

    case 'number':
    case 'percent':
      let minDecimalPlaces = 0;
      if (isSpecified(options.minDecimalPlaces)) {
        minDecimalPlaces = options.minDecimalPlaces;
      } else if (desc.control === 'number' || desc.control === 'percent') {
        minDecimalPlaces = desc.minDecimalPlaces;
      }

      let maxDecimalPlaces = Math.max(minDecimalPlaces, 4);
      if (isSpecified(options.maxDecimalPlaces)) {
        maxDecimalPlaces = options.maxDecimalPlaces;
      } else if (desc.control === 'number' || desc.control === 'percent') {
        maxDecimalPlaces = desc.maxDecimalPlaces;
      }

      let isRightAligned = true;
      if (isSpecified(options.isRightAligned)) {
        isRightAligned = options.isRightAligned;
      } else if (desc.control === 'number' || desc.control === 'percent') {
        isRightAligned = desc.isRightAligned;
      }

      let noSeparator = false;
      if (isSpecified(options.noSeparator)) {
        noSeparator = options.noSeparator;
      } else if (desc.control === 'number' || desc.control === 'percent') {
        noSeparator = desc.noSeparator;
      }

      return { control, minDecimalPlaces, maxDecimalPlaces, isRightAligned, noSeparator };

    case 'choice':
      let choices: (string | number)[] = []; // default value
      let format = (c: string | number) => c + ''; // default value
      let color: (c: string | number) => string; // No default value
      if (!!options.choices && options.choices.length > 0) {
        const choicesArray = options.choices as { value: string, name: string, name2: string, name3: string }[];
        const choicesDic: { [key: string]: () => string } = {};
        for (const e of choicesArray) {
          choicesDic[e.value] = () => ws.getMultilingualValueImmediate(e, 'name');
        }

        choices = choicesArray.map((e) => e.value);
        format = (c: string) => choicesDic[c] ? choicesDic[c]() : c;
      } else if (desc.control === 'choice') {
        choices = desc.choices;
        format = desc.format;
        color = desc.color; // Only override this when overriding the others
      }

      return { control, choices, format, color };

    case 'serial':
      let prefix = '';
      if (isSpecified(options.prefix)) {
        prefix = options.prefix;
      } else if (desc.control === 'serial') {
        prefix = desc.prefix;
      }

      let codeWidth = 4;
      if (isSpecified(options.codeWidth)) {
        codeWidth = options.codeWidth;
      } else if (desc.control === 'serial') {
        codeWidth = desc.codeWidth;
      }

      return { control, prefix, codeWidth };

    default:
      let filter: string;
      if (isSpecified(options.filter)) {
        filter = options.filter;
      } else if (desc.control === control) {
        filter = desc.filter;
      }

      let definitionId: number;
      if (isSpecified(options.definitionId)) {
        definitionId = options.definitionId;
      } else if (desc.control === control) {
        definitionId = desc.definitionId;
      }

      return { control, filter, definitionId };
  }
}

export function updateOn(desc: PropVisualDescriptor): 'change' | 'blur' {

  switch (desc.control) {
    case 'null':
    case 'text':
    case 'number':
    case 'percent':
    case 'serial':
    case 'date':
    case 'datetime':
    case 'unsupported':
      return 'blur';
    case 'choice':
    case 'check':
      return 'change';
    default:
      const x = desc.filter; // So it will complain if we forget a control
      return !!x ? 'change' : 'change';
  }
}

export function copyToClipboard(value: string) {
  const tempInput = document.createElement('input');
  tempInput.value = value;
  document.body.appendChild(tempInput);
  tempInput.select();
  document.execCommand('copy');
  document.body.removeChild(tempInput);
}
