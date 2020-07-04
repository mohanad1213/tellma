﻿INSERT INTO @AccountClassifications([Index],[ParentIndex],[Code],[Name],[Name2],[AccountTypeParentId]) VALUES
(1,NULL, N'1',N'Assets', N'الأصول',@Assets),
(11,1, N'11',N'Non-current assets', N'الأصول غير المتداولة',@NoncurrentAssets),
(1101,11, N'1101',N'Property, plant and equipment', N'الممتلكات والمصانع والمعدات',@PropertyPlantAndEquipment),
(110101,1101, N'110101',N'Land', N'الأراضي',@Land),
(110102,1101, N'110102',N'Buildings', N'مباني',@Buildings),
(110103,1101, N'110103',N'Machinery', N'الالات',@Machinery),
(110106,1101, N'110106',N'Motor Vehicles', N'العربات',@MotorVehicles),
(110107,1101, N'110107',N'Fixtures and fittings', N'التركيبات والتجهيزات',@FixturesAndFittings),
(110108,1101, N'110108',N'Office equipment', N'المعدات المكتبية',@OfficeEquipment),
(110109,1101, N'110109',N'Bearer plants', N'النباتات المثمرة',@BearerPlants),
(110110,1101, N'110110',N'Tangible exploration and evaluation assets', N'أصول الاستكشاف والتقييم الملموسة',@TangibleExplorationAndEvaluationAssets),
(110111,1101, N'110111',N'Mining assets', N'أصول التعدين',@MiningAssets),
(110112,1101, N'110112',N'Oil and gas assets', N'أصول النفط والغاز',@OilAndGasAssets),
(110113,1101, N'110113',N'Construction in progress', N'الإنشاءات قيد الإنجاز',@ConstructionInProgress),
(110114,1101, N'110114',N'Owner-occupied property measured using investment property fair value model', N'العقارات التي يشغلها مالكوها (قياسها باستخدام نموذج القيمة العادلة)',@OwneroccupiedPropertyMeasuredUsingInvestmentPropertyFairValueModel),
(110199,1101, N'110199',N'Other property, plant and equipment', N'الممتلكات والمصانع والمعدات الأخرى',@OtherPropertyPlantAndEquipment),
(1102,11, N'1102',N'Investment property', N'العقارات الاستثمارية',@InvestmentProperty),
(110201,1102, N'110201',N'Investment property completed', N'العقارات الاستثمارية المستكملة',@InvestmentPropertyCompleted),
(110202,1102, N'110202',N'Investment property under construction or development', N'العقارات الاستثمارية قيد الإنشاء أو التطوير',@InvestmentPropertyUnderConstructionOrDevelopment),
(1103,11, N'1103',N'Goodwill', N'الشهرة',@Goodwill),
(1104,11, N'1104',N'Intangible assets other than goodwill', N'الأصول غير الملموسة باستثناء الشهرة',@IntangibleAssetsOtherThanGoodwill),
(1105,11, N'1105',N'Investments accounted for using equity method', N'الاستثمارات التي يتم محاسبتها باستخدام طريقة حقوق الملكية',@InvestmentAccountedForUsingEquityMethod),
(110501,1105, N'110501',N'Investments in associates accounted for using equity method', N'الاستثمارات في المشاريع المشتركة التي يتم محاسبتها باستخدام طريقة حقوق الملكية',@InvestmentsInAssociatesAccountedForUsingEquityMethod),
(110502,1105, N'110502',N'Investments in joint ventures accounted for using equity method', N'الاستثمارات في المنشآت الزميلة التي يتم محاسبتها باستخدام طريقة حقوق الملكية',@InvestmentsInJointVenturesAccountedForUsingEquityMethod),
(1106,11, N'1106',N'Investments in subsidiaries, joint ventures and associates', N'الاستثمارات في الشركات التابعة والمشاريع المشتركة والشركات الزميلة',@InvestmentsInSubsidiariesJointVenturesAndAssociates),
(110601,1106, N'110601',N'Investments in subsidiaries', N'الاستثمارات في الشركات التابعة',@InvestmentsInSubsidiaries),
(110602,1106, N'110602',N'Investments in joint ventures', N'الاستثمارات في المشاريع المشتركة',@InvestmentsInJointVentures),
(110603,1106, N'110603',N'Investments in associates', N'الاستثمارات في الشركات الزميلة',@InvestmentsInAssociates),
(1107,11, N'1107',N'Non-current biological assets', N'الأصول البيولوجية غير المتداولة',@NoncurrentBiologicalAssets),
(1108,11, N'1108',N'Trade and other non-current receivables', N'الذمم المدينة التجارية والأخرى غير المتداولة',@NoncurrentReceivables),
(110801,1108, N'110801',N'Non-current trade receivables', N'الذمم المدينة التجارية غير المتداولة',@NoncurrentTradeReceivables),
(110802,1108, N'110802',N'Non-current receivables due from related parties', N'الذمم المدينة غير المتداولة المستحقة من أطراف ذات علاقة',@NoncurrentReceivablesDueFromRelatedParties),
(110803,1108, N'110803',N'Non-current prepayments', N'دفعات مسبقة غير متداولة',@NoncurrentPrepayments),
(110804,1108, N'110804',N'Non-current accrued income', N'الدخل المستحق غير المتداول',@NoncurrentAccruedIncome),
(110805,1108, N'110805',N'Non-current receivables from taxes other than income tax', N'الذمم المدينة غير المتداولة من الضرائب عدا عن ضريبة الدخل',@NoncurrentReceivablesFromTaxesOtherThanIncomeTax),
(110806,1108, N'110806',N'Non-current receivables from sale of properties', N'الذمم المدينة غير المتداولة من بيع العقارات',@NoncurrentReceivablesFromSaleOfProperties),
(110807,1108, N'110807',N'Non-current receivables from rental of properties', N'الذمم المدينة غير المتداولة من إيجار العقارات',@NoncurrentReceivablesFromRentalOfProperties),
(110899,1108, N'110899',N'Other non-current receivables', N'ذمم مدينة أخرى غير متداولة',@OtherNoncurrentReceivables),
(1109,11, N'1109',N'Non-current inventories', N'المخزون غير المتداول',@NoncurrentInventories),
(1110,11, N'1110',N'Deferred tax assets', N'أصول الضريبة المؤجلة',@DeferredTaxAssets),
(1111,11, N'1111',N'Current tax assets, non-current', N'الأصول الضريبية المتداولة، غير جارية',@CurrentTaxAssetsNoncurrent),
(1112,11, N'1112',N'Other non-current financial assets', N'أصول مالية غير متداولة أخرى',@OtherNoncurrentFinancialAssets),
(1113,11, N'1113',N'Other non-current non-financial assets', N'أصول غير مالية غير متداولة أخرى',@OtherNoncurrentNonfinancialAssets),
(1114,11, N'1114',N'Non-current non-cash assets pledged as collateral for which transferee has right by contract or cust', N'الأصول غير النقدية وغير المتداولة المرهونة كضمان والتي يكون للمنشأة المنقول إليها الحق بموجب عقد ما ',@NoncurrentNoncashAssetsPledgedAsCollateralForWhichTransfereeHasRightByContractOrCustomToSellOrRepledgeCollateral),
(12,1, N'12',N'Current assets', N'الاصول المتداولة',@CurrentAssets),
(1201,12, N'1201',N'Current inventories', N'المخزون الحالي',@Inventories),
(120101,1201, N'120101',N'Current inventories held for sale', N'المخزون الحالي المحتفظ به برسم البيع',@CurrentInventoriesHeldForSale),
(120102,1201, N'120102',N'Current work in progress', N'الأعمال الحالية قيد التنفيذ',@WorkInProgress),
(120103,1201, N'120103',N'Current materials and supplies to be consumed in production process or rendering services', N'المواد والمستلزمات الحالية التي تُستهلك في عملية الإنتاج أو تقديم الخدمات',@CurrentMaterialsAndSuppliesToBeConsumedInProductionProcessOrRenderingServices),
(120104,1201, N'120104',N'Current inventories in transit', N'المخزونات الحالية في مجال النقل',@CurrentInventoriesInTransit),
(120199,1201, N'120199',N'Other current inventories', N'مخزون حالي آخر',@OtherInventories),
(1202,12, N'1202',N'Trade and other current receivables', N'الذمم المدينة التجارية والأخرى المتداولة',@TradeAndOtherCurrentReceivables),
(120201,1202, N'120201',N'Current trade receivables', N'الذمم المدينة االتجارية المتداولة',@CurrentTradeReceivables),
(120202,1202, N'120202',N'Current receivables due from related parties', N'الذمم المدينة المتداولة المستحقة من أطراف ذات علاقة',@TradeAndOtherCurrentReceivablesDueFromRelatedParties),
(120203,1202, N'120203',N'Current prepayments', N'إجمالي الدفعات المسبقة الحالية',@CurrentPrepayments),
(120204,1202, N'120204',N'Current accrued income', N'الدخل المستحق الحالي',@CurrentAccruedIncome),
(120205,1202, N'120205',N'Current billed but not received', N'وصفت الحالي ولكن لم تتلق',@CurrentBilledButNotReceivedExtension),
(120206,1202, N'120206',N'Current receivables from taxes other than income tax', N'الذمم المدينة المتداولة من الضرائب عدا عن ضريبة الدخل',@CurrentReceivablesFromTaxesOtherThanIncomeTax),
(120207,1202, N'120207',N'Current receivables from rental of properties', N'الذمم المدينة المتداولة من إيجار العقارات',@CurrentReceivablesFromRentalOfProperties),
(120298,1202, N'120298',N'Other current receivables', N'ذمم مدينة متداولة أخرى',@OtherCurrentReceivables),
(120299,1202, N'120299',N'Allowance account for credit losses of trade and other current receivables', N'حساب مخصص خسائر الائتمان للذمم مدينة تجارية وأخرى الحالية',@AllowanceAccountForCreditLossesOfTradeAndOtherCurrentReceivablesExtension),
(1203,12, N'1203',N'Current tax assets, current', N'الأصول الضريبية المتداولة، جارية',@CurrentTaxAssetsCurrent),
(1204,12, N'1204',N'Current biological assets', N'الأصول البيولوجية المتداولة',@CurrentBiologicalAssets),
(1205,12, N'1205',N'Other current financial assets', N'أصول مالية متداولة أخرى',@OtherCurrentFinancialAssets),
(120501,1205, N'120501',N'Staff Debtors', N'المدينين الموظفين',@LoansExtension),
(120502,1205, N'120502',N'Sundry debtors', N'المدينين المتنوعة',@LoansExtension),
(120503,1205, N'120503',N'Collection Guarantee', N'جمع الضمان',@CollectionGuaranteeExtension),
(120504,1205, N'120504',N'Dishonoured Guarantee', N'المرتجعة ضمان',@DishonouredGuaranteeExtension),
(1206,12, N'1206',N'Other current non-financial assets', N'أصول غير مالية متداولة أخرى',@OtherCurrentNonfinancialAssets),
(1207,12, N'1207',N'Cash and cash equivalents', N'النقد والنقد المعادل',@CashAndCashEquivalents),
(120701,1207, N'120701',N'Cash', N'نقد',@Cash),
(120702,1207, N'120702',N'Cash equivalents', N'النقد المعادل',@CashEquivalents),
(120703,1207, N'120703',N'Other cash and cash equivalents', N'النقد والنقد المعادل الآخرين',@OtherCashAndCashEquivalents),
(1208,12, N'1208',N'Current non-cash assets pledged as collateral for which transferee has right by contract or custom t', N'الأصول غير النقدية المتداولة كضمان التي المنقول له الحق العقد أو العرف لبيع أو إعادة رهن الضمان',@CurrentNoncashAssetsPledgedAsCollateralForWhichTransfereeHasRightByContractOrCustomToSellOrRepledgeCollateral),
(1209,12, N'1209',N'Non-current assets or disposal groups classified as held for sale or as held for distribution to own', N'الموجودات غير المتداولة أو مجموعات التصرف المصنفة كاستثمارات محتفظ بها للبيع أو عقد لتوزيعها على أصح',@NoncurrentAssetsOrDisposalGroupsClassifiedAsHeldForSaleOrAsHeldForDistributionToOwners),
(2,NULL, N'2',N'Equity', N'حقوق الملكية',@Equity),
(20,2, N'20',N'Equity', N'حقوق الملكية',NULL),
(2000,20, N'2000',N'Equity', N'حقوق الملكية',NULL),
(200001,2000, N'200001',N'Issued capital', N'رأس المال المصدر',@IssuedCapital),
(200002,2000, N'200002',N'Retained earnings', N'الأرباح المستبقاة',@RetainedEarnings),
(200003,2000, N'200003',N'Share premium', N'علاوة إصدار',@SharePremium),
(200004,2000, N'200004',N'Treasury shares', N'أسهم الخزينة',@TreasuryShares),
(200005,2000, N'200005',N'Other equity interest', N'حصة مالكين أخرى',@OtherEquityInterest),
(200006,2000, N'200006',N'Other reserves', N'',@OtherReserves),
(3,NULL, N'3',N'Liabilities', N'الالتزامات',@Liabilities),
(31,3, N'31',N'Non-current liabilities', N'الالتزامات غير الجارية',@NoncurrentLiabilities),
(3101,31, N'3101',N'Non-current provisions', N'المخصصات غير المتداولة',@NoncurrentProvisions),
(310101,3101, N'310101',N'Non-current provisions for employee benefits', N'المخصصات غير المتداولة لمنافع الموظفين',@NoncurrentProvisionsForEmployeeBenefits),
(310102,3101, N'310102',N'Other non-current provisions', N'مخصصات أخرى غير متداولة',@OtherLongtermProvisions),
(3102,31, N'3102',N'Trade and other non-current payables', N'الذمم الدائنة التجارية والأخرى غير المتداولة',@NoncurrentPayables),
(3103,31, N'3103',N'Deferred tax liabilities', N'التزامات الضريبة المؤجلة',@DeferredTaxLiabilities),
(3104,31, N'3104',N'Current tax liabilities, non-current', N'الالتزامات الضريبية المتداولة، غير جارية',@CurrentTaxLiabilitiesNoncurrent),
(3105,31, N'3105',N'Other non-current financial liabilities', N'التزامات مالية غير متداولة أخرى',@OtherNoncurrentFinancialLiabilities),
(310501,3105, N'310501',N'Non-current financial liabilities at fair value through profit or loss, classified as held for tradi', N'المطلوبات المالية غير المتداولة بالقيمة العادلة من خلال الربح أو الخسارة، وتصنف على أنها محتفظ بها ل',@NoncurrentFinancialLiabilitiesAtFairValueThroughProfitOrLossClassifiedAsHeldForTrading),
(310502,3105, N'310502',N'Non-current financial liabilities at fair value through profit or loss, designated upon initial reco', N'المطلوبات المالية غير المتداولة بالقيمة العادلة من خلال الربح أو الخسارة، مصنفة عند التحقق المبدئي أ',@NoncurrentFinancialLiabilitiesAtFairValueThroughProfitOrLossDesignatedUponInitialRecognition),
(310503,3105, N'310503',N'Non-current financial liabilities at amortised cost', N'المطلوبات المالية غير المتداولة بالتكلفة المطفأة',@NoncurrentFinancialLiabilitiesAtAmortisedCost),
(3106,31, N'3106',N'Other non-current non-financial liabilities', N'التزامات غير مالية غير متداولة أخرى',@OtherNoncurrentNonfinancialLiabilities),
(32,3, N'32',N'Current liabilities', N'الالتزامات المتداولة',@CurrentLiabilities),
(3201,32, N'3201',N'Current provisions', N'المخصصات المتداولة',@CurrentProvisions),
(320101,3201, N'320101',N'Current provisions for employee benefits', N'المخصصات المتداولة لمنافع الموظفين',@CurrentProvisionsForEmployeeBenefits),
(320102,3201, N'320102',N'Other current provisions', N'مخصصات متداولة أخرى',@OtherShorttermProvisions),
(3202,32, N'3202',N'Trade and other current payables', N'الذمم الدائنة التجارية والأخرى المتداولة',@TradeAndOtherCurrentPayables),
(320201,3202, N'320201',N'Current trade payables', N'الذمم الدائنة االتجارية المتداولة',@TradeAndOtherCurrentPayablesToTradeSuppliers),
(320202,3202, N'320202',N'Current payables to related parties', N'الذمم الدائنة المتداولة إلى الأطراف ذات العلاقة',@TradeAndOtherCurrentPayablesToRelatedParties),
(320203,3202, N'320203',N'Deferred income classified as current', N'الدخل المؤجل المصنف على أنه متداول',@DeferredIncomeClassifiedAsCurrent),
(320204,3202, N'320204',N'Accruals classified as current', N'مستحقات تصنف الحالي',@AccrualsClassifiedAsCurrent),
(320205,3202, N'320205',N'Current payables on social security and taxes other than income tax', N'الذمم الدائنة المتداولة على الضمان الاجتماعي والضرائب عدا عن ضريبة الدخل',@CurrentPayablesOnSocialSecurityAndTaxesOtherThanIncomeTax),
(320206,3202, N'320206',N'Current retention payables', N'دائنة الاحتفاظ الحالية',@CurrentRetentionPayables),
(320299,3202, N'320299',N'Other current payables', N'ذمم دائنة متداولة اخرى',@OtherCurrentPayables),
(3203,32, N'3203',N'Current tax liabilities, current', N'الالتزامات الضريبية المتداولة، جارية',@CurrentTaxLiabilitiesCurrent),
(3204,32, N'3204',N'Other current financial liabilities', N'التزامات مالية متداولة أخرى',@OtherCurrentFinancialLiabilities),
(320401,3204, N'320401',N'Current financial liabilities at fair value through profit or loss, classified as held for trading', N'المطلوبات المالية الحالية بالقيمة العادلة من خلال الربح أو الخسارة، وتصنف على أنها محتفظ بها للمتاجر',@CurrentFinancialLiabilitiesAtFairValueThroughProfitOrLossClassifiedAsHeldForTrading),
(320402,3204, N'320402',N'Current financial liabilities at fair value through profit or loss, designated upon initial recognit', N'المطلوبات المالية الحالية بالقيمة العادلة من خلال الربح أو الخسارة، مصنفة عند التحقق المبدئي أو في و',@CurrentFinancialLiabilitiesAtFairValueThroughProfitOrLossDesignatedUponInitialRecognition),
(320403,3204, N'320403',N'Current financial liabilities at amortised cost', N'المطلوبات المالية الحالية بالتكلفة المطفأة',@CurrentFinancialLiabilitiesAtAmortisedCost),
(3205,32, N'3205',N'Other current non-financial liabilities', N'التزامات غير مالية متداولة أخرى',@OtherCurrentNonfinancialLiabilities),
(3206,32, N'3206',N'Liabilities included in disposal groups classified as held for sale', N'الالتزامات المدرجة في مجموعات التصرف المصنفة على أنه محتفظ بها برسم البيع',@LiabilitiesIncludedInDisposalGroupsClassifiedAsHeldForSale),
(4,NULL, N'4',N'Profit (loss) from operating activities', N'الربح (الخسارة) من الأنشطة التشغيلية',@ProfitLossFromOperatingActivities),
(41,4, N'41',N'Revenue', N'الإيراد',@Revenue),
(4101,41, N'4101',N'Revenue from sale of goods', N'الإيراد من بيع السلع',@RevenueFromSaleOfGoods),
(410101,4101, N'410101',N'Revenue from sale of goods (by product type)', N'الإيرادات من بيع السلع (حسب نوع المنتج)',@RevenueFromSaleOfGoods),
(4102,41, N'4102',N'Revenue from rendering of services', N'الإيراد من تقديم الخدمات',@RevenueFromRenderingOfServices),
(410201,4102, N'410201',N'Revenue from rendering of services (by service type)', N'الإيرادات من تقديم الخدمات (حسب نوع الخدمة)',@RevenueFromRenderingOfServices),
(4103,41, N'4103',N'Revenue from construction contracts', N'الإيراد من عقود الإنشاء',@RevenueFromConstructionContracts),
(4104,41, N'4104',N'Royalty income', N'دخل الملكية',@RevenueFromRoyalties),
(4105,41, N'4105',N'Licence fee income', N'دخل حقوق الانتفاع',@LicenceFeeIncome),
(4106,41, N'4106',N'Franchise fee income', N'دخل رسوم الترخيص',@FranchiseFeeIncome),
(4107,41, N'4107',N'Interest income', N'دخل الفائدة',@RevenueFromInterest),
(4108,41, N'4108',N'Dividend income', N'دخل أرباح الأسهم',@RevenueFromDividends),
(4199,41, N'4199',N'Other revenue', N'إيراد آخر',@OtherRevenue),
(42,4, N'42',N'Other income', N'دخل آخر',@OtherIncome),
(43,4, N'43',N'Expenses by nature', N'النفقات حسب طبيعتها',@ExpenseByNature),
(4301,43, N'4301',N'Raw materials and consumables used', N'المواد الخام والقابلة للاستهلاك المستخدمة',@RawMaterialsAndConsumablesUsed),
(4302,43, N'4302',N'Cost of merchandise sold', N'تكلفة البضائع المباعة',@CostOfMerchandiseSold),
(4303,43, N'4303',N'Services expense', N'مصروف الخدمات',@ServicesExpense),
(430301,4303, N'430301',N'Insurance expense', N'مصروف التأمين',@InsuranceExpense),
(430302,4303, N'430302',N'Professional fees expense', N'مصروف الرسوم المهنية',@ProfessionalFeesExpense),
(430303,4303, N'430303',N'Transportation expense', N'مصروف النقل',@TransportationExpense),
(430304,4303, N'430304',N'Bank and similar charges', N'الرسوم البنكية والرسوم المشابهة',@BankAndSimilarCharges),
(430305,4303, N'430305',N'Travel expense', N'نفقات السفر',@TravelExpense),
(430306,4303, N'430306',N'Communication expense', N'حساب الاتصالات',@CommunicationExpense),
(430307,4303, N'430307',N'Utilities expense', N'المصاريف الخدمية',@UtilitiesExpense),
(430308,4303, N'430308',N'Advertising expense', N'مصاريف الدعاية',@AdvertisingExpense),
(4304,43, N'4304',N'Employee benefits expense', N'مصاريف منافع الموظفين',@EmployeeBenefitsExpense),
(430401,4304, N'430401',N'Wages and salaries', N'الأجور والرواتب',@WagesAndSalaries),
(430402,4304, N'430402',N'Social security contributions', N'مساهمات الضمان الاجتماعي',@SocialSecurityContributions),
(430403,4304, N'430403',N'Other short-term employee benefits', N'منافع موظفين أخرى قصيرة الأجل',@OtherShorttermEmployeeBenefits),
(430404,4304, N'430404',N'Post-employment benefit expense, defined contribution plans', N'مصروف منافع ما بعد التوظيف، خطط المساهمة المحددة',@PostemploymentBenefitExpenseDefinedContributionPlans),
(430405,4304, N'430405',N'Post-employment benefit expense, defined benefit plans', N'مصروف منافع ما بعد التوظيف، خطط المنافع المحددة',@PostemploymentBenefitExpenseDefinedBenefitPlans),
(430406,4304, N'430406',N'Termination benefits expense', N'مصروف منافع الإنهاء',@TerminationBenefitsExpense),
(430407,4304, N'430407',N'Other long-term employee benefits', N'منافع الموظفين طويلة الاجل الأخرى',@OtherLongtermBenefits),
(430499,4304, N'430499',N'Other employee expense', N'مصروف آخر للموظفين',@OtherEmployeeExpense),
(4305,43, N'4305',N'Depreciation and amortisation expense', N'مصاريف الاستهلاك والإطفاء',@DepreciationAndAmortisationExpense),
(430501,4305, N'430501',N'Depreciation expense', N'مصروف الاستهلاك',@DepreciationExpense),
(430502,4305, N'430502',N'Amortisation expense', N'مصروف الإطفاء',@AmortisationExpense),
(4306,43, N'4306',N'Reversal of impairment loss (impairment loss) recognised in profit or loss', N'عكس خسارة انخفاض القيمة (خسارة انخفاض القيمة) المعترف بها في الربح أو الخسارة',@ImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLoss),
(430601,4306, N'430601',N'Write-downs (reversals of write-downs) of inventories', N'تخفيضات (عكس التخفيضات) المخزون',@WritedownsReversalsOfInventories),
(430602,4306, N'430602',N'Write-downs (reversals of write-downs) of property, plant and equipment', N'تخفيضات (عكس التخفيضات) الممتلكات والمصانع والمعدات',@WritedownsReversalsOfPropertyPlantAndEquipment),
(430603,4306, N'430603',N'Impairment loss (reversal of impairment loss) recognised in profit or loss, trade receivables', N'خسارة انخفاض القيمة (عكس خسارة الانخفاض في القيمة) المعترف بها في الربح أو الخسارة، الذمم المدينة ال',@ImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLossTradeReceivables),
(430604,4306, N'430604',N'Impairment loss (reversal of impairment loss) recognised in profit or loss, loans and advances', N'خسارة انخفاض القيمة (عكس خسارة الانخفاض في القيمة) المعترف بها في الربح أو الخسارة، والقروض والسلف',@ImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLossLoansAndAdvances),
(4307,43, N'4307',N'Tax expense other than income tax expense', N'مصروف ضريبة غير مصروف ضريبة الدخل',@TaxExpenseOtherThanIncomeTaxExpense),
(4399,43, N'4399',N'Other expenses', N'مصاريف أخرى',@OtherExpenseByNature),
(44,4, N'44',N'Other gains (losses)', N'أرباح (خسائر) الأخرى',@OtherGainsLosses),
(4401,44, N'4401',N'Gain (loss) on disposal of property, plant and equipment', N'الأرباح (الخسائر) من التصرف بالممتلكات والمصانع والمعدات',@GainLossOnDisposalOfPropertyPlantAndEquipmentExtension),
(4402,44, N'4402',N'Gain (loss) on foreign exchange', N'الربح (الخسارة) على الصرف الأجنبي',@GainLossOnForeignExchangeExtension),
(5,NULL, N'5',N'Other profit (loss)', N'الربح الآخر (خسارة)',NULL),
(51,5, N'51',N'Other profit (loss) from continuing operation', N'الربح الآخر (الخسارة) من استمرار العملية',NULL),
(5101,51, N'5101',N'Gains (losses) on net monetary position', N'الأرباح (الخسائر) من صافي المركز المالي',@GainsLossesOnNetMonetaryPosition),
(5102,51, N'5102',N'Gain (loss) arising from derecognition of financial assets measured at amortised cost', N'الأرباح (الخسائر) من إلغاء الاعتراف بالأصول المالية المقاسة بالتكلفة المطفأة',@GainLossArisingFromDerecognitionOfFinancialAssetsMeasuredAtAmortisedCost),
(5103,51, N'5103',N'Finance income', N'الدخل التمويلي',@FinanceIncome),
(5104,51, N'5104',N'Finance costs', N'تكاليف التمويل',@FinanceCosts),
(5105,51, N'5105',N'Impairment gain and reversal of impairment loss (impairment loss) determined in accordance with IFRS', N'أرباح انخفاض القيمة وعكس خسارة انخفاض القيمة (خسارة انخفاض القيمة) المحددة وفقا للمعيار الدولي لإعدا',@ImpairmentLossImpairmentGainAndReversalOfImpairmentLossDeterminedInAccordanceWithIFRS9),
(5106,51, N'5106',N'Share of profit (loss) of associates and joint ventures accounted for using equity method', N'حصة الشركات الزميلة والمشاريع المشتركة من الربح (الخسارة) التي تمت محاسبتها باستخدام طريقة حقوق المل',@ShareOfProfitLossOfAssociatesAndJointVenturesAccountedForUsingEquityMethod),
(5107,51, N'5107',N'Other income (expense) from subsidiaries, jointly controlled entities and associates', N'دخل (مصروف) آخر من الشركات التابعة والمنشآت الخاضعة لسيطرة مشتركة والشركات الزميلة',@OtherIncomeExpenseFromSubsidiariesJointlyControlledEntitiesAndAssociates),
(5108,51, N'5108',N'Gains (losses) arising from difference between previous amortised cost and fair value of financial a', N'الأرباح (الخسائر) الناجمة عن الفرق بين التكلفة المطفأة السابقة والقيمة العادلة للأصول المالية المعاد',@GainsLossesArisingFromDifferenceBetweenPreviousCarryingAmountAndFairValueOfFinancialAssetsReclassifiedAsMeasuredAtFairValue),
(5109,51, N'5109',N'Cumulative gain (loss) previously recognised in other comprehensive income arising from reclassifica', N'الأرباح (الخسائر) التراكمية المعترف بها سابقا في الدخل الشامل الآخر والناجمة عن إعادة تصنيف الأصول ا',@CumulativeGainLossPreviouslyRecognisedInOtherComprehensiveIncomeArisingFromReclassificationOfFinancialAssetsOutOfFairValueThrou),
(5110,51, N'5110',N'Hedging gains (losses) for hedge of group of items with offsetting risk positions', N'أرباح (خسائر) التحوط فيما يخص التحوط لمجموعة من البنود التي يكون لها مراكز مخاطر متعادلة',@HedgingGainsLossesForHedgeOfGroupOfItemsWithOffsettingRiskPositions),
(52,5, N'52',N'Tax income (expense)', N'دخل (مصروف) الضريبة',@IncomeTaxExpenseContinuingOperations),
(53,5, N'53',N'Profit (loss) from discontinued operations', N'الربح (الخسارة) من العمليات المتوقفة',@ProfitLossFromDiscontinuedOperations)


EXEC [api].[AccountClassifications__Save] --  N'cash-and-cash-equivalents',
	@Entities = @AccountClassifications,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Inserting AccountClassifications: ' + @ValidationErrorsJson
	GOTO Err_Label;
END;
--Declarations
DECLARE @AC1 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1');
DECLARE @AC11 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'11');
DECLARE @AC1101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1101');
DECLARE @AC110101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110101');
DECLARE @AC110102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110102');
DECLARE @AC110103 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110103');
DECLARE @AC110106 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110106');
DECLARE @AC110107 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110107');
DECLARE @AC110108 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110108');
DECLARE @AC110109 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110109');
DECLARE @AC110110 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110110');
DECLARE @AC110111 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110111');
DECLARE @AC110112 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110112');
DECLARE @AC110113 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110113');
DECLARE @AC110114 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110114');
DECLARE @AC110199 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110199');
DECLARE @AC1102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1102');
DECLARE @AC110201 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110201');
DECLARE @AC110202 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110202');
DECLARE @AC1103 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1103');
DECLARE @AC1104 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1104');
DECLARE @AC1105 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1105');
DECLARE @AC110501 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110501');
DECLARE @AC110502 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110502');
DECLARE @AC1106 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1106');
DECLARE @AC110601 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110601');
DECLARE @AC110602 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110602');
DECLARE @AC110603 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110603');
DECLARE @AC1107 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1107');
DECLARE @AC1108 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1108');
DECLARE @AC110801 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110801');
DECLARE @AC110802 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110802');
DECLARE @AC110803 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110803');
DECLARE @AC110804 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110804');
DECLARE @AC110805 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110805');
DECLARE @AC110806 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110806');
DECLARE @AC110807 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110807');
DECLARE @AC110899 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'110899');
DECLARE @AC1109 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1109');
DECLARE @AC1110 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1110');
DECLARE @AC1111 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1111');
DECLARE @AC1112 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1112');
DECLARE @AC1113 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1113');
DECLARE @AC1114 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1114');
DECLARE @AC12 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'12');
DECLARE @AC1201 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1201');
DECLARE @AC120101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120101');
DECLARE @AC120102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120102');
DECLARE @AC120103 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120103');
DECLARE @AC120104 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120104');
DECLARE @AC120199 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120199');
DECLARE @AC1202 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1202');
DECLARE @AC120201 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120201');
DECLARE @AC120202 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120202');
DECLARE @AC120203 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120203');
DECLARE @AC120204 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120204');
DECLARE @AC120205 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120205');
DECLARE @AC120206 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120206');
DECLARE @AC120207 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120207');
DECLARE @AC120298 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120298');
DECLARE @AC120299 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120299');
DECLARE @AC1203 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1203');
DECLARE @AC1204 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1204');
DECLARE @AC1205 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1205');
DECLARE @AC120501 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120501');
DECLARE @AC120502 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120502');
DECLARE @AC120503 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120503');
DECLARE @AC120504 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120504');
DECLARE @AC1206 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1206');
DECLARE @AC1207 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1207');
DECLARE @AC120701 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120701');
DECLARE @AC120702 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120702');
DECLARE @AC120703 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'120703');
DECLARE @AC1208 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1208');
DECLARE @AC1209 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'1209');
DECLARE @AC2 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'2');
DECLARE @AC20 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'20');
DECLARE @AC2000 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'2000');
DECLARE @AC200001 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'200001');
DECLARE @AC200002 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'200002');
DECLARE @AC200003 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'200003');
DECLARE @AC200004 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'200004');
DECLARE @AC200005 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'200005');
DECLARE @AC200006 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'200006');
DECLARE @AC3 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3');
DECLARE @AC31 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'31');
DECLARE @AC3101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3101');
DECLARE @AC310101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'310101');
DECLARE @AC310102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'310102');
DECLARE @AC3102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3102');
DECLARE @AC3103 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3103');
DECLARE @AC3104 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3104');
DECLARE @AC3105 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3105');
DECLARE @AC310501 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'310501');
DECLARE @AC310502 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'310502');
DECLARE @AC310503 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'310503');
DECLARE @AC3106 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3106');
DECLARE @AC32 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'32');
DECLARE @AC3201 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3201');
DECLARE @AC320101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320101');
DECLARE @AC320102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320102');
DECLARE @AC3202 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3202');
DECLARE @AC320201 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320201');
DECLARE @AC320202 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320202');
DECLARE @AC320203 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320203');
DECLARE @AC320204 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320204');
DECLARE @AC320205 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320205');
DECLARE @AC320206 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320206');
DECLARE @AC320299 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320299');
DECLARE @AC3203 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3203');
DECLARE @AC3204 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3204');
DECLARE @AC320401 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320401');
DECLARE @AC320402 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320402');
DECLARE @AC320403 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'320403');
DECLARE @AC3205 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3205');
DECLARE @AC3206 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'3206');
DECLARE @AC4 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4');
DECLARE @AC41 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'41');
DECLARE @AC4101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4101');
DECLARE @AC410101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'410101');
DECLARE @AC4102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4102');
DECLARE @AC410201 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'410201');
DECLARE @AC4103 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4103');
DECLARE @AC4104 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4104');
DECLARE @AC4105 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4105');
DECLARE @AC4106 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4106');
DECLARE @AC4107 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4107');
DECLARE @AC4108 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4108');
DECLARE @AC4199 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4199');
DECLARE @AC42 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'42');
DECLARE @AC43 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'43');
DECLARE @AC4301 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4301');
DECLARE @AC4302 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4302');
DECLARE @AC4303 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4303');
DECLARE @AC430301 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430301');
DECLARE @AC430302 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430302');
DECLARE @AC430303 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430303');
DECLARE @AC430304 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430304');
DECLARE @AC430305 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430305');
DECLARE @AC430306 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430306');
DECLARE @AC430307 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430307');
DECLARE @AC430308 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430308');
DECLARE @AC4304 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4304');
DECLARE @AC430401 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430401');
DECLARE @AC430402 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430402');
DECLARE @AC430403 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430403');
DECLARE @AC430404 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430404');
DECLARE @AC430405 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430405');
DECLARE @AC430406 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430406');
DECLARE @AC430407 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430407');
DECLARE @AC430499 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430499');
DECLARE @AC4305 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4305');
DECLARE @AC430501 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430501');
DECLARE @AC430502 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430502');
DECLARE @AC4306 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4306');
DECLARE @AC430601 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430601');
DECLARE @AC430602 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430602');
DECLARE @AC430603 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430603');
DECLARE @AC430604 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'430604');
DECLARE @AC4307 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4307');
DECLARE @AC4399 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4399');

DECLARE @AC44 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'44');
DECLARE @AC4401 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4401');
DECLARE @AC4402 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'4402');
DECLARE @AC5 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5');
DECLARE @AC51 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'51');
DECLARE @AC5101 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5101');
DECLARE @AC5102 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5102');
DECLARE @AC5103 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5103');
DECLARE @AC5104 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5104');
DECLARE @AC5105 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5105');
DECLARE @AC5106 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5106');
DECLARE @AC5107 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5107');
DECLARE @AC5108 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5108');
DECLARE @AC5109 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5109');
DECLARE @AC5110 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'5110');
DECLARE @AC52 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'52');
DECLARE @AC53 INT = (SELECT [Id] FROM dbo.AccountClassifications WHERE [Code] = N'53');