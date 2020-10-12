// tslint:disable:member-ordering
import { Component, OnInit, OnDestroy } from '@angular/core';
import { WorkspaceService, ReconciliationStore, ReportStatus } from '~/app/data/workspace.service';
import { Router, ActivatedRoute, ParamMap, Params } from '@angular/router';
import { Subscription, Subject, Observable, of } from 'rxjs';
import { ApiService } from '~/app/data/api.service';
import { catchError, switchMap, tap } from 'rxjs/operators';
import { ICanDeactivate } from '~/app/data/unsaved-changes.guard';
import { CustomUserSettingsService } from '~/app/data/custom-user-settings.service';
import { TranslateService } from '@ngx-translate/core';
import { SelectorChoice } from '~/app/shared/selector/selector.component';
import { Account } from '~/app/data/entities/account';
import { FriendlyError } from '~/app/data/util';
import {
  ReconciliationGetReconciledArguments,
  ReconciliationGetReconciledResponse,
  ReconciliationGetUnreconciledArguments
} from '~/app/data/dto/reconciliation';
import { Entry } from '~/app/data/entities/entry';
import { ExternalEntry } from '~/app/data/entities/external-entry';

type View = 'unreconciled' | 'reconciled';

@Component({
  selector: 't-reconciliation',
  templateUrl: './reconciliation.component.html',
  styles: []
})
export class ReconciliationComponent implements OnInit, OnDestroy, ICanDeactivate {

  private DEFAULT_PAGE_SIZE = 200;

  private argumentsKey = 'reconciliation/arguments';
  private _subscriptions: Subscription;
  private notifyFetch$ = new Subject<void>();
  private notifyDestruct$ = new Subject<void>();
  private api = this.apiService.reconciliationApi(this.notifyDestruct$); // Only for intellisense

  public viewChoices: SelectorChoice[] = [
    { value: 'reconciled', name: () => this.translate.instant('Reconciled') },
    { value: 'unreconciled', name: () => this.translate.instant('Unreconciled') },
  ];

  private numericKeys: { [key: string]: any } = {
    account_id: undefined,
    custody_id: undefined,
    entries_top: 200,
    entries_skip: 0,
    ex_entries_top: 200,
    ex_entries_skip: 0,
    top: 200,
    skip: 0,
    from_amount: undefined,
    to_amount: undefined,
  };

  private stringKeys: { [key: string]: any } = {
    view: 'unreconciled',
    from_date: undefined,
    to_date: undefined,
    ex_ref_contains: undefined
  };

  constructor(
    private workspace: WorkspaceService, private router: Router, private customUserSettings: CustomUserSettingsService,
    private route: ActivatedRoute, private apiService: ApiService, private translate: TranslateService) { }

  ngOnInit(): void {

    // Initialize the api service
    this.api = this.apiService.reconciliationApi(this.notifyDestruct$);

    // Set up all the subscriptions
    this._subscriptions = new Subscription();

    // Subscribe to fetch requests
    this._subscriptions.add(this.notifyFetch$.pipe(
      switchMap(() => this.doFetch())
    ).subscribe());

    // Subscribe to changing URL param
    this._subscriptions.add(this.route.paramMap.subscribe((params: ParamMap) => {

      // Copy all report arguments from URL

      let fetchIsNeeded = false;
      const s = this.state;
      const args = s.arguments;

      for (const key of Object.keys(this.stringKeys)) {
        const paramValue = params.get(key) || this.stringKeys[key];
        if (args[key] !== paramValue) {
          args[key] = paramValue;
          fetchIsNeeded = true;
        }
      }

      for (const key of Object.keys(this.numericKeys)) {
        const paramValue = (+params.get(key)) || this.numericKeys[key];
        if (args[key] !== paramValue) {
          args[key] = paramValue;
          fetchIsNeeded = true;
        }
      }

      if (fetchIsNeeded) {
        this.fetch();
      }
    }));
  }

  ngOnDestroy(): void {
    this.notifyDestruct$.next();
    this._subscriptions.unsubscribe();
  }

  private urlStateChanged(): void {
    // We wish to store part of the page state in the URL
    // This method is called whenever that part of the state has changed
    // Below we capture the new URL state, and then navigate to the new URL

    const s = this.state;
    const args = s.arguments;
    const params: Params = {};

    // Add the string arguments
    for (const key of Object.keys(this.stringKeys)) {
      const value = args[key] || this.stringKeys[key];
      if (!!value) {
        params[key] = value;
      }
    }

    // Add the numeric arguments
    for (const key of Object.keys(this.numericKeys)) {
      const value = args[key] || this.numericKeys[key];
      if (!!value) {
        params[key] = value;
      }
    }

    // navigate to the new url
    this.router.navigate(['.', params], { relativeTo: this.route, replaceUrl: true });
  }

  private parametersChanged(): void {

    // Update the URL
    this.urlStateChanged();

    // Save the arguments in user settings
    const argsString = JSON.stringify(this.state.arguments);
    this.customUserSettings.save(this.argumentsKey, argsString);

    // Refresh the results
    this.fetch();
  }

  public fetch() {
    this.notifyFetch$.next();
  }

  private doFetch(): Observable<void> {
    // For robustness grab a reference to the state object, in case it changes later
    const s = this.state;
    const store = s.store;

    if (!this.requiredParametersAreSet) {
      store.reportStatus = ReportStatus.information;
      store.information = () => this.translate.instant('FillRequiredFields');
      return of();
    } else if (this.loadingRequiredParameters) {
      // Wait until required parameters have loaded
      // They will call fetch again once they load
      store.reportStatus = ReportStatus.loading;
      delete s.reconciled_response;
      delete s.unreconciled_response;
      return of();
    } else {
      store.reportStatus = ReportStatus.loading;
      let obs: Observable<void>;
      if (this.view === 'unreconciled') {
        delete s.unreconciled_response;
        const args: ReconciliationGetUnreconciledArguments = {
          accountId: this.accountId,
          custodyId: this.custodyId,
          asOfDate: this.toDate,
          entriesTop: this.entriesTop,
          entriesSkip: this.entriesSkip,
          externalEntriesTop: this.externalEntriesTop,
          externalEntriesSkip: this.externalEntriesSkip,
        };

        // Prepare the query params
        obs = this.api.getUnreconciled(args).pipe(
          tap(response => {
            // Result is loaded
            store.reportStatus = ReportStatus.loaded;

            // Add the result to the state
            s.unreconciled_response = response;
          }),
          catchError((friendlyError: FriendlyError) => {
            store.reportStatus = ReportStatus.error;
            store.errorMessage = friendlyError.error;
            return of(null);
          })
        );
      } else {
        delete s.reconciled_response;
        const args: ReconciliationGetReconciledArguments = {
          accountId: this.accountId,
          custodyId: this.custodyId,
          fromDate: this.fromDate,
          toDate: this.toDate,
          fromAmount: this.fromAmount,
          toAmount: this.toAmount,
          externalReferenceContains: this.externalReferenceContains,
          top: this.top,
          skip: this.skip,
        };

        // Prepare the query params
        obs = this.api.getReconciled(args).pipe(
          tap(response => {
            // Result is loaded
            store.reportStatus = ReportStatus.loaded;

            // Add the result to the state
            s.reconciled_response = response;
          }),
          catchError((friendlyError: FriendlyError) => {
            store.reportStatus = ReportStatus.error;
            store.errorMessage = friendlyError.error;
            return of(null);
          })
        );
      }

      return obs;
    }
  }

  public get requiredParametersAreSet(): boolean {
    const args = this.state.arguments;
    return !!args.account_id && !!args.custody_id;
  }

  private get loadingRequiredParameters(): boolean {
    // Some times the account Id or resource Id from the Url refer to entities that are not loaded
    // Given that computing the statement query requires knowledge of these entities (not just their Ids)
    // We have to wait until the details pickers have loaded the entities for us, until then this
    // property returns true, and the statement query is not executed
    if (!!this.accountId && !this.account()) {
      return true;
    }

    if (this.showCustodyParameter && !this.readonlyCustody_Manual && !!this.custodyId && !this.ws.get('Custody', this.custodyId)) {
      return true;
    }

    return false;
  }

  public get ws() {
    return this.workspace.currentTenant;
  }

  public get state(): ReconciliationStore {

    const ws = this.ws;
    return ws.reconciliationState = ws.reconciliationState || new ReconciliationStore();
  }

  public canDeactivate(): boolean | Observable<boolean> {
    return true;
    // if (this.isDirty) {

    //   // IF there are unsaved changes, prompt the user asking if they would like them discarded
    //   const modal = this.modalService.open(this.unsavedChangesModal);

    //   // capture the user's decision in a subject:
    //   // first action when the user presses one of the two buttons
    //   // second func is when the user dismisses the modal with x or ESC or clicking the background
    //   const decision$ = new Subject<boolean>();
    //   modal.result.then(
    //     v => { decision$.next(v); decision$.complete(); },
    //     _ => { decision$.next(false); decision$.complete(); }
    //   );

    //   // return the subject that will eventually emit the user's decision
    //   return decision$;

    // } else {

    //   // IF there are no unsaved changes, the navigation can happily proceed
    //   return true;
    // }
  }

  public get canExport() {
    return this.isLoaded;
  }

  private account(id?: number): Account {
    id = id || this.accountId;
    return this.ws.get('Account', id);
  }

  // UI Bindings

  public onParameterLoaded(): void {
    if (this.state.store.reportStatus === ReportStatus.loading) {
      this.fetch();
    }
  }

  // view
  public get view(): View {
    return this.state.arguments.view;
  }

  public set view(v: View) {
    const args = this.state.arguments;
    if (args.view !== v) {
      args.view = v;
      this.parametersChanged();
    }
  }

  /**
   * Returns false if the unreconciled entries view is selected
   */
  public get isUnreconciled(): boolean {
    return this.view === 'unreconciled';
  }

  /**
   * Returns true if the reconciled entries view is selected
   */
  public get isReconciled(): boolean {
    return this.view === 'reconciled';
  }

  // Error Message
  public get showErrorMessage(): boolean {
    return this.state.store.reportStatus === ReportStatus.error;
  }

  public get errorMessage(): string {
    return this.state.store.errorMessage;
  }

  // Information
  public get showInformation(): boolean {
    return this.state.store.reportStatus === ReportStatus.information;
  }

  public information(): string {
    return this.state.store.information();
  }

  // Spinner
  public get showSpinner(): boolean {
    return this.state.store.reportStatus === ReportStatus.loading;
  }

  // accountId
  public get accountId(): number {
    return this.state.arguments.account_id;
  }

  public set accountId(v: number) {
    const args = this.state.arguments;
    if (args.account_id !== v) {
      args.account_id = v;
      this.parametersChanged();
    }
  }

  // custodyId
  public get custodyId(): number {
    return this.state.arguments.custody_id;
  }

  public set custodyId(v: number) {
    const args = this.state.arguments;
    if (args.custody_id !== v) {
      args.custody_id = v;
      this.parametersChanged();
    }
  }

  public get showCustodyParameter(): boolean {
    const account = this.account();
    return !!account && !!account.CustodyDefinitionId;
  }

  public get readonlyCustody_Manual(): boolean {
    const account = this.account();
    return !!account && !!account.CustodyId;
  }

  // toDate
  public get toDate(): string {
    return this.state.arguments.to_date;
  }

  public set toDate(v: string) {
    const args = this.state.arguments;
    if (args.to_date !== v) {
      args.to_date = v;
      this.parametersChanged();
    }
  }

  // fromDate
  public get fromDate(): string {
    return this.state.arguments.from_date;
  }

  public set fromDate(v: string) {
    const args = this.state.arguments;
    if (args.from_date !== v) {
      args.from_date = v;
      this.parametersChanged();
    }
  }

  // top
  public get top(): number {
    return this.state.arguments.top;
  }

  public set top(v: number) {
    const args = this.state.arguments;
    if (args.top !== v) {
      args.top = v;
      this.parametersChanged();
    }
  }

  // skip
  public get skip(): number {
    return this.state.arguments.skip;
  }

  public set skip(v: number) {
    const args = this.state.arguments;
    if (args.skip !== v) {
      args.skip = v;
      this.parametersChanged();
    }
  }

  // entries top
  public get entriesTop(): number {
    return this.state.arguments.entries_top;
  }

  public set entriesTop(v: number) {
    const args = this.state.arguments;
    if (args.entries_top !== v) {
      args.entries_top = v;
      this.parametersChanged();
    }
  }

  // entries skip
  public get entriesSkip(): number {
    return this.state.arguments.entries_skip;
  }

  public set entriesSkip(v: number) {
    const args = this.state.arguments;
    if (args.entries_skip !== v) {
      args.entries_skip = v;
      this.parametersChanged();
    }
  }

  // external entries top
  public get externalEntriesTop(): number {
    return this.state.arguments.ex_entries_top;
  }

  public set externalEntriesTop(v: number) {
    const args = this.state.arguments;
    if (args.ex_entries_top !== v) {
      args.ex_entries_top = v;
      this.parametersChanged();
    }
  }

  // external entries skip
  public get externalEntriesSkip(): number {
    return this.state.arguments.ex_entries_skip;
  }

  public set externalEntriesSkip(v: number) {
    const args = this.state.arguments;
    if (args.ex_entries_skip !== v) {
      args.ex_entries_skip = v;
      this.parametersChanged();
    }
  }

  // from amount
  public get fromAmount(): number {
    return this.state.arguments.from_amount;
  }

  public set fromAmount(v: number) {
    const args = this.state.arguments;
    if (args.from_amount !== v) {
      args.from_amount = v;
      this.parametersChanged();
    }
  }

  // to amount
  public get toAmount(): number {
    return this.state.arguments.to_amount;
  }

  public set toAmount(v: number) {
    const args = this.state.arguments;
    if (args.to_amount !== v) {
      args.to_amount = v;
      this.parametersChanged();
    }
  }

  // external reference contains
  public get externalReferenceContains(): string {
    return this.state.arguments.ex_ref_contains;
  }

  public set externalReferenceContains(v: string) {
    const args = this.state.arguments;
    if (args.ex_ref_contains !== v) {
      args.ex_ref_contains = v;
      this.parametersChanged();
    }
  }

  private get isLoaded(): boolean {
    return this.state.store.reportStatus === ReportStatus.loaded;
  }

  public onExport() {
    alert('TODO');
  }

  public get actionsDropdownPlacement() {
    return this.workspace.ws.isRtl ? 'bottom-right' : 'bottom-left';
  }

  public get flip() {
    // this is to flip the UI icons in RTL
    return this.workspace.ws.isRtl ? 'horizontal' : null;
  }

  public get disableRefresh(): boolean {
    return !this.requiredParametersAreSet;
  }

  public onRefresh(): void {
    // The if statement to deal with incessant button clickers (Users who hit refresh repeatedly)
    if (this.state.store.reportStatus !== ReportStatus.loading) {
      this.fetch();
    }
  }

  // Paging for reconciled entities

  get from(): number {
    const skip = this.state.arguments.skip;
    return Math.min(skip + 1, this.total);
  }

  get to(): number {
    return Math.min(this.state.arguments.skip + this.DEFAULT_PAGE_SIZE, this.total);
  }

  get total(): number {
    return !!this.state.reconciled_response ?
      this.state.reconciled_response.Reconciliations.length : 0;
  }

  onPreviousPage() {
    const args = this.state.arguments;
    args.skip = Math.max(args.skip - this.DEFAULT_PAGE_SIZE, 0);

    this.urlStateChanged(); // to update the URL state
    this.fetch();
  }

  get canPreviousPage(): boolean {
    return this.state.arguments.skip > 0;
  }

  onNextPage() {
    const s = this.state.arguments;
    s.skip = s.skip + this.DEFAULT_PAGE_SIZE;

    this.urlStateChanged(); // to update the URL state
    this.fetch();
  }

  get canNextPage(): boolean {
    return this.to < this.total;
  }

  // results

  private _reconciled: ReconciledRow[];
  private _reconciledResponse: ReconciliationGetReconciledResponse;

  public get reconciled(): ReconciledRow[] {
    const res = this.state.reconciled_response;
    if (this._reconciledResponse !== res) {
      this._reconciledResponse = res;

      this._reconciled = [];
      if (!!res) {
        const entriesDic: { [id: number]: Entry } = {};
        const exEntriesDic: { [id: number]: ExternalEntry } = {};

        for (const entry of res.Entries) {
          entriesDic[entry.Id] = entry;
        }

        for (const exEntry of res.ExternalEntries) {
          exEntriesDic[exEntry.Id] = exEntry;
        }

        for (const reconciliation of res.Reconciliations) {
          const length = Math.max(reconciliation.Entries.length, reconciliation.ExternalEntries.length);
          for (let i = 0; i < length; i++) {
            const row: ReconciledRow = { };

            // The first row will have a middle cell extending to the entire reconciliation, with a button to unreconcile
            if (i === 0) {
              row.rowSpan = length;
            }
            // The last row will have a thick bottom border indicating that the reconciliation is done, and shows the next reconciliation
            if (i === length - 1) {
              row.lastOne = true;
            }

            // The entry
            const reconciliationEntry = reconciliation.Entries[0];
            if (!!reconciliationEntry && !!reconciliationEntry.EntryId) {
              row.entry = entriesDic[reconciliationEntry.EntryId];
            }

            // The external entry
            const reconciliationExEntry = reconciliation.ExternalEntries[0];
            if (!!reconciliationExEntry && !!reconciliationExEntry.ExternalEntryId) {
              row.exEntry = exEntriesDic[reconciliationExEntry.ExternalEntryId];
            }
          }
        }
      }
    }

    return this._reconciled;
  }

  public onSelectRow(row: ReconciledRow) {
    alert('TODO');
  }
}

interface ReconciledRow {
  entry?: Entry;
  exEntry?: ExternalEntry;
  rowSpan?: number;
  lastOne?: boolean;
}