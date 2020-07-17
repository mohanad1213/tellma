﻿INSERT INTO @Accounts([Index], [AccountTypeId], [ClassificationId],[Code],[Name],[Name2],[CurrencyId],[CenterId], [ResourceDefinitionId],[ContractDefinitionId], [NotedContractDefinitionId]) VALUES
(11010100,@Land,@AC110101, '11010100', N'Land -', N'أراضي -',@XXX,NULL, @LandMemberRD,NULL,NULL),
(11010200,@Buildings,@AC110102, '11010200', N'Buildings -', N'مباني -',@XXX,NULL, @BuildingsMemberRD,NULL,NULL),
(11010300,@Machinery,@AC110103, '11010300', N'Machinery -', N'الالات -',@XXX,NULL, @MachineryMemberRD,NULL,NULL),
(11010310,@Machinery,@AC110103, '11010310', N'Power generating assets', N'أصول مولدة للطاقة',@XXX,NULL, @PowerGeneratingAssetsMemberRD,NULL,NULL),
(11010600,@MotorVehicles,@AC110106, '11010600', N'Motor Vehicles -', N'العربات -',@XXX,NULL, @MotorVehiclesMemberRD,NULL,NULL),
(11010700,@FixturesAndFittings,@AC110107, '11010700', N'Fixtures and fittings -', N'التركيبات والتجهيزات -',@XXX,NULL, @FixturesAndFittingsMemberRD,NULL,NULL),
(11010710,@FixturesAndFittings,@AC110107, '11010710', N'Network infrastructure', N'البنية التحتية للشبكة',@XXX,NULL, @NetworkInfrastructureMemberRD,NULL,NULL),
(11010720,@FixturesAndFittings,@AC110107, '11010720', N'Leasehold improvements', N'تحسينات عقارية',@XXX,NULL, @LeaseholdImprovementsMemberRD,NULL,NULL),
(11010810,@OfficeEquipment,@AC110108, '11010810', N'Office equipment -', N'المعدات المكتبية -',@XXX,NULL, @OfficeEquipmentMemberRD,NULL,NULL),
(11010820,@OfficeEquipment,@AC110108, '11010820', N'Computer equipment', N'معدات الحاسوب',@XXX,NULL, @ComputerEquipmentMemberRD,NULL,NULL),
(11010830,@OfficeEquipment,@AC110108, '11010830', N'Communication and network equipment', N'الاتصالات ومعدات الشبكة',@XXX,NULL, @CommunicationAndNetworkEquipmentMemberRD,NULL,NULL),
(11010900,@BearerPlants,@AC110109, '11010900', N'Bearer plants -', N'النباتات المثمرة -',@XXX,NULL, @BearerPlantsMemberRD,NULL,NULL),
(11011100,@MiningAssets,@AC110111, '11011100', N'Mining assets -', N'أصول التعدين -',NULL,NULL, @MiningAssetsMemberRD,NULL,NULL),
(11011200,@OilAndGasAssets,@AC110112, '11011200', N'Oil and gas assets -', N'أصول النفط والغاز -',@XXX,NULL, @OilAndGasAssetsMemberRD,NULL,NULL),
(11011301,@ConstructionInProgress,@AC110113, '11011301', N'Construction in progress (by project)', N'الإنشاءات قيد الإنجاز (بالمشروع)',@XXX,NULL, NULL,NULL,NULL),
(11019900,@OtherPropertyPlantAndEquipment,@AC110199, '11019900', N'Other property, plant and equipment -', N'الممتلكات والمصانع والمعدات الأخرى -',@XXX,NULL, @OtherPropertyPlantAndEquipmentMemberRD,NULL,NULL),
(11020101,@InvestmentPropertyCompleted,@AC110201, '11020101', N'Investment property completed (by investment)', N'العقارات الاستثمارية المستكملة (بالمشروع)',@XXX,NULL, @InvestmentPropertyCompletedMemberRD,NULL,NULL),
(11020201,@InvestmentPropertyUnderConstructionOrDevelopment,@AC110202, '11020201', N'Inv. prop. under const. or dev.', N'عقارات استثمارية قيد الإنشاء أو التطوير (بالمشروع)',@XXX,NULL, NULL,NULL,NULL),
(11080100,@NoncurrentTradeReceivables,@AC110801, '11080100', N'Non-current trade receivables -', N'الذمم المدينة التجارية غير المتداولة -',NULL,NULL, NULL,@CustomerCD,NULL),
(11080200,@NoncurrentReceivablesDueFromRelatedParties,@AC110802, '11080200', N'Non-current receivables due from related parties -', N'الذمم المدينة غير المتداولة المستحقة من أطراف ذات علاقة -',NULL,NULL, NULL,@CustomerCD,NULL),
(11080501,@NoncurrentValueAddedTaxReceivables,@AC110805, '11080501', N'Non-current value added tax receivables', N'الذمم المدينة لضريبة القيمة المضافة غير المتداولة',@XXX,NULL, NULL,NULL,@SupplierCD),
(11089901,@OtherNoncurrentReceivables,@AC110899, '11089901', N'Non current sundry debtor (by name)', N'ذمم مدينة أخرى غير متداولة (باسم المدين)',NULL,NULL, NULL,NULL,NULL),
(11120000,@NonCurrentLoansExtension,@AC111200, '11120000', N'Non-current staff loans -', N'قروض طويلة الأجل لموظفين -',NULL,NULL, NULL,NULL,NULL),
(11120001,@NonCurrentLoansExtension,@AC111200, '11120001', N'Non-current staff loan (by employee name)', N'سلفيات غير متداولة لموظفين (باسم الموظف)',NULL,NULL, NULL,NULL,NULL),
(12010110,@Merchandise,@AC120101, '12010110', N'Current merchandise', N'السلع الحالية',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010120,@CurrentFoodAndBeverage,@AC120101, '12010120', N'Current food and beverage', N'الأطعمة والمشروبات',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010130,@CurrentAgriculturalProduce,@AC120101, '12010130', N'Current agricultural produce', N'الإنتاج الزراعي الحالي',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010140,@FinishedGoods,@AC120101, '12010140', N'Current finished goods', N'السلع الجاهزة الحالية',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010150,@PropertyIntendedForSaleInOrdinaryCourseOfBusiness,@AC120101, '12010150', N'Property intended for sale in ordinary course of business', N'العقارات المقصود بيعها في السياق العادي للأعمال',@XXX,NULL, NULL,NULL,NULL),
(12010200,@WorkInProgress,@AC120102, '12010200', N'Current work in progress -', N'الأعمال الحالية قيد التنفيذ -',@XXX,NULL, NULL,NULL,NULL),
(12010310,@RawMaterials,@AC120103, '12010310', N'Current raw materials', N'المواد الخام الحالية',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010320,@ProductionSupplies,@AC120103, '12010320', N'Current production supplies', N'مستلزمات الإنتاج الحالية',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010330,@CurrentPackagingAndStorageMaterials,@AC120103, '12010330', N'Current packaging and storage materials', N'مواد التعبئة والتغليف والتخزين الحالية',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010340,@SpareParts,@AC120103, '12010340', N'Current spare parts', N'قطع الغيار الحالية',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010350,@CurrentFuel,@AC120103, '12010350', N'Current fuel', N'الوقود الحالي',@XXX,NULL, NULL,@WarehouseCD,NULL),
(12010400,@CurrentInventoriesInTransit,@AC120104, '12010400', N'Current inventories in transit -', N'المخزون في الطريق -',NULL,NULL, NULL,NULL,NULL),
(12019900,@OtherInventories,@AC120199, '12019900', N'Other current inventories -', N'مخزون حالي آخر -',NULL,NULL, NULL,@WarehouseCD,NULL),
(12020100,@CurrentTradeReceivables,@AC120201, '12020100', N'Current trade receivables -', N'الذمم المدينة االتجارية المتداولة -',NULL,NULL, NULL,@CustomerCD,NULL),
(12020200,@TradeAndOtherCurrentReceivablesDueFromRelatedParties,@AC120202, '12020200', N'Current receivables due from related parties -', N'الذمم المدينة المتداولة المستحقة من أطراف ذات علاقة -',NULL,NULL, NULL,@CustomerCD,NULL),
(12020310,@CurrentPrepayments,@AC120203, '12020310', N'Salary Advances -', N'سلفيات مرتبات',@XXX,NULL, NULL,@EmployeeCD,NULL),
(12020350,@CurrentAdvancesToSuppliers,@AC120203, '12020350', N'Current advances to suppliers', N'سلف حالية للموردين',NULL,NULL, NULL,@SupplierCD,NULL),
(12020380,@CurrentPrepaidExpenses,@AC120203, '12020380', N'Current prepaid expenses', N'المصاريف المدفوعة مسبقا الحالية',NULL,NULL, NULL,@SupplierCD,NULL),
(12020400,@CurrentAccruedIncome,@AC120204, '12020400', N'Current accrued income -', N'الدخل المستحق الحالي -',NULL,NULL, NULL,@CustomerCD,NULL),
(12020500,@CurrentBilledButNotReceivedExtension,@AC120205, '12020500', N'Current billed but not received -', N'فواتير بدون استلام للسلع والخدمات -',NULL,NULL, NULL,@SupplierCD,NULL),
(12020601,@CurrentValueAddedTaxReceivables,@AC120206, '12020601', N'Current value added tax receivables', N'الذمم المدينة لضريبة القيمة المضافة الحالية',@XXX,NULL, NULL,NULL,@SupplierCD),
(12020602,@WithholdingTaxReceivablesExtension,@AC120206, '12020602', N'Withholding tax receivables', N'الذمم المدينة لضريية الخصم',@XXX,NULL, NULL,NULL,@CustomerCD),
(12020700,@CurrentReceivablesFromRentalOfProperties,@AC120207, '12020700', N'Current receivables from rental of properties -', N'الذمم المدينة المتداولة من إيجار العقارات -',NULL,NULL, NULL,NULL,@CustomerCD),
(12020701,@CurrentReceivablesFromRentalOfProperties,@AC120207, '12020701', N'Current receivables from rental of properties (by tenant)', N'الذمم المدينة الحالية من تأجير العقارات (fالمستأجر)',NULL,NULL, NULL,NULL,@CustomerCD),
(12029801,@OtherCurrentReceivables,@AC120298, '12029801', N'Other current receivables (by name)', N'ذمم مدينة متداولة أخرى (باسم المدين)',NULL,NULL, NULL,NULL,NULL),
(12050100,@CurrentLoansExtension,@AC120501, '12050100', N'Staff loans -', N'سلفيات متداولة لموظفين -',NULL,NULL, NULL,@EmployeeCD,NULL),
(12050101,@CurrentLoansExtension,@AC120501, '12050101', N'Staff loan (by employee name)', N'مدينون موظفون (باسم الموظف)',NULL,NULL, NULL,@EmployeeCD,NULL),
(12070110,@CashOnHand,@AC120701, '12070110', N'Cash on hand -', N'النقد في الصندوق -',NULL,NULL, NULL,@CashOnHandAccountCD,NULL),
(12070111,@CashOnHand,@AC120701, '12070111', N'Cash on hand (by custodian)', N'صندوق باسم 1',NULL,NULL, NULL,@CashOnHandAccountCD,NULL),
(12070112,@CashOnHand,@AC120701, '12070112', N'Cash on hand (by custodian)', N'صندوق باسم 1',NULL,NULL, NULL,@CashOnHandAccountCD,NULL),
(12070113,@CashOnHand,@AC120701, '12070113', N'Cash on hand (by custodian)', N'صناديق إضافية (باسم أمين الصندوق)',NULL,NULL, NULL,@CashOnHandAccountCD,NULL),
(12070130,@BalancesWithBanks,@AC120701, '12070130', N'Balances with banks -', N'الأرصدة لدى البنوك',NULL,NULL, NULL,@BankAccountCD,NULL),
(12070131,@BalancesWithBanks,@AC120701, '12070131', N'Balances with banks (bank account 1)', N'حساب بنك 1',NULL,NULL, NULL,@BankAccountCD,NULL),
(12070132,@BalancesWithBanks,@AC120701, '12070132', N'Balances with banks (bank account 2)', N'حساب بنك 2',NULL,NULL, NULL,@BankAccountCD,NULL),
(12070133,@BalancesWithBanks,@AC120701, '12070133', N'More balances with banks (by bank account)', N'أرصدة أخرى لدى البنوك (باسم الحساب)',@XXX,NULL, NULL,@BankAccountCD,NULL),
(12070210,@ShorttermDepositsClassifiedAsCashEquivalents,@AC120702, '12070210', N'Short-term deposits, classified as cash equivalents', N'الودائع قصيرة الأجل، المصنفة على أنها نقد معادل',@XXX,NULL, NULL,NULL,NULL),
(12070240,@ShorttermInvestmentsClassifiedAsCashEquivalents,@AC120702, '12070240', N'Short-term investments, classified as cash equivalents', N'الاستثمارات قصيرة الأجل، المصنفة على أنها نقد معادل',@XXX,NULL, NULL,NULL,NULL),
(12070270,@BankingArrangementsClassifiedAsCashEquivalents,@AC120702, '12070270', N'Other banking arrangements, classified as cash equivalents', N'الترتيبات المصرفية الأخرى، المصنفة على أنها نقد معادل',@XXX,NULL, NULL,NULL,NULL),
(12070310,@OtherCashAndCashEquivalents,@AC120703, '12070310', N'Checks under collection', N'الشيكات تحت التحصيل',@XXX,NULL, NULL,NULL,NULL),
(20000100,@IssuedCapital,@AC200001, '20000100', N'Issued capital -', N'رأس المال المصدر -',@XXX,NULL, NULL,NULL,NULL),
(20000200,@RetainedEarnings,@AC200002, '20000200', N'Retained earnings -', N'الأرباح المستبقاة -',@XXX,NULL, NULL,NULL,NULL),
(20000300,@SharePremium,@AC200003, '20000300', N'Share premium -', N'علاوة إصدار -',@XXX,NULL, NULL,NULL,NULL),
(20000400,@TreasuryShares,@AC200004, '20000400', N'Treasury shares -', N'أسهم الخزينة -',@XXX,NULL, NULL,NULL,NULL),
(20000500,@OtherEquityInterest,@AC200005, '20000500', N'Other equity interest -', N'حصة مالكين أخرى -',@XXX,NULL, NULL,NULL,NULL),
(20000601,@RevaluationSurplus,@AC200006, '20000601', N'Revaluation surplus', N'فائض إعادة التقييم',@XXX,NULL, NULL,NULL,NULL),
(20000602,@ReserveOfExchangeDifferencesOnTranslation,@AC200006, '20000602', N'Reserve of exchange differences on translation', N'احتياطي فروق الصرف من التحويل',@XXX,NULL, NULL,NULL,NULL),
(20000603,@ReserveOfCashFlowHedges,@AC200006, '20000603', N'Reserve of cash flow hedges', N'احتياطي تحوطات التدفقات النقدية',@XXX,NULL, NULL,NULL,NULL),
(20000604,@ReserveOfGainsAndLossesOnHedgingInstrumentsThatHedgeInvestmentsInEquityInstruments,@AC200006, '20000604', N'Reserve of gains and losses on hedging instruments that hedge investments in equity instruments', N'احتياطي الأرباح والخسائر من أدوات التحوط التي تحوط الاستثمارات في أدوات حقوق الملكية',@XXX,NULL, NULL,NULL,NULL),
(20000605,@ReserveOfChangeInValueOfTimeValueOfOptions,@AC200006, '20000605', N'Reserve of change in value of time value of options', N'احتياطي التغير في القيمة الزمنية للخيارات',@XXX,NULL, NULL,NULL,NULL),
(20000606,@ReserveOfChangeInValueOfForwardElementsOfForwardContracts,@AC200006, '20000606', N'Reserve of change in value of forward elements of forward contracts', N'احتياطي التغير في قيمة العناصر الآجلة من العقود الآجلة',@XXX,NULL, NULL,NULL,NULL),
(20000607,@ReserveOfChangeInValueOfForeignCurrencyBasisSpreads,@AC200006, '20000607', N'Reserve of change in value of foreign currency basis spreads', N'احتياطي التغير في قيمة فروقات أسعار العملة الأجنبية',@XXX,NULL, NULL,NULL,NULL),
(20000608,@ReserveOfGainsAndLossesOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome,@AC200006, '20000608', N'Reserve of gains and losses on financial assets measured at fair value through other comprehensive i', N'احتياطي الأرباح والخسائر من الأصول المالية المقاسة بالقيمة العادلة من خلال دخل شامل آخر',@XXX,NULL, NULL,NULL,NULL),
(20000609,@ReserveOfInsuranceFinanceIncomeExpensesFromInsuranceContractsIssuedExcludedFromProfitOrLossThatWillBeReclassifiedToProfitOrLoss,@AC200006, '20000609', N'Reserve of insurance finance income (expenses) from insurance contracts issued excluded from profit ', N'احتياطي للدخل التأمين المالية (النفقات) من عقود التأمين الصادرة استبعادها من الربح أو الخسارة التي س',@XXX,NULL, NULL,NULL,NULL),
(20000610,@ReserveOfInsuranceFinanceIncomeExpensesFromInsuranceContractsIssuedExcludedFromProfitOrLossThatWillNotBeReclassifiedToProfitOrL,@AC200006, '20000610', N'Reserve of insurance finance income (expenses) from insurance contracts issued excluded from profit ', N'الاحتياطي إيرادات التمويل والتأمين (النفقات) من عقود التأمين الصادرة استبعادها من الربح أو الخسارة ا',@XXX,NULL, NULL,NULL,NULL),
(20000611,@ReserveOfFinanceIncomeExpensesFromReinsuranceContractsHeldExcludedFromProfitOrLoss,@AC200006, '20000611', N'Reserve of finance income (expenses) from reinsurance contracts held excluded from profit or loss', N'الاحتياطي إيرادات التمويل (النفقات) من عقود إعادة التأمين التي عقدت استبعادها من ربح أو خسارة',@XXX,NULL, NULL,NULL,NULL),
(20000612,@ReserveOfGainsAndLossesOnRemeasuringAvailableforsaleFinancialAssets,@AC200006, '20000612', N'Reserve of gains and losses on remeasuring available-for-sale financial assets', N'احتياطي الارباح والخسائر الناشئة عن إعادة قياس الأصول المالية المتوافرة برسم البيع',@XXX,NULL, NULL,NULL,NULL),
(20000613,@ReserveOfSharebasedPayments,@AC200006, '20000613', N'Reserve of share-based payments', N'احتياطي الدفعات على أساس الأسهم',@XXX,NULL, NULL,NULL,NULL),
(20000614,@ReserveOfRemeasurementsOfDefinedBenefitPlans,@AC200006, '20000614', N'Reserve of remeasurements of defined benefit plans', N'احتياطي إعادة قياس خطط المنافع المحددة',@XXX,NULL, NULL,NULL,NULL),
(20000615,@AmountRecognisedInOtherComprehensiveIncomeAndAccumulatedInEquityRelatingToNoncurrentAssetsOrDisposalGroupsHeldForSale,@AC200006, '20000615', N'Amount recognised in other comprehensive income and accumulated in equity relating to non-current as', N'المبلغ المعترف به في دخل شامل آخر والمتراكم في حقوق الملكية المتعلقة بأصول غير متداولة أو مجموعات تص',@XXX,NULL, NULL,NULL,NULL),
(20000616,@ReserveOfGainsAndLossesFromInvestmentsInEquityInstruments,@AC200006, '20000616', N'Reserve of gains and losses from investments in equity instruments', N'احتياطي الأرباح والخسائر من الاستثمارات في أدوات حقوق الملكية',@XXX,NULL, NULL,NULL,NULL),
(20000617,@ReserveOfChangeInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiability,@AC200006, '20000617', N'Reserve of change in fair value of financial liability attributable to change in credit risk of liab', N'احتياطي التغير في القيمة العادلة للالتزام المالي المنسوب إلى التغير في مخاطر ائتمان الالتزام',@XXX,NULL, NULL,NULL,NULL),
(20000618,@ReserveForCatastrophe,@AC200006, '20000618', N'Reserve for catastrophe', N'احتياطي الكوارث',@XXX,NULL, NULL,NULL,NULL),
(20000619,@ReserveForEqualisation,@AC200006, '20000619', N'Reserve for equalisation', N'احتياطي التكافؤ',@XXX,NULL, NULL,NULL,NULL),
(20000620,@ReserveOfDiscretionaryParticipationFeatures,@AC200006, '20000620', N'Reserve of discretionary participation features', N'احتياطي خصائص المشاركة الاختيارية',@XXX,NULL, NULL,NULL,NULL),
(20000621,@ReserveOfEquityComponentOfConvertibleInstruments,@AC200006, '20000621', N'Reserve of equity component of convertible instruments', N'احتياطي عنصر حقوق الملكية في الأدوات القابلة للتحويل',@XXX,NULL, NULL,NULL,NULL),
(20000622,@CapitalRedemptionReserve,@AC200006, '20000622', N'Capital redemption reserve', N'احتياطي استرداد رأس المال',@XXX,NULL, NULL,NULL,NULL),
(20000623,@MergerReserve,@AC200006, '20000623', N'Merger reserve', N'احتياطي الدمج',@XXX,NULL, NULL,NULL,NULL),
(20000624,@StatutoryReserve,@AC200006, '20000624', N'Statutory reserve', N'احتياطي قانوني',@XXX,NULL, NULL,NULL,NULL),
(31010100,@NoncurrentProvisionsForEmployeeBenefits,@AC310101, '31010100', N'Non-current provisions for employee benefits -', N'المخصصات غير المتداولة لمنافع الموظفين -',@XXX,NULL, NULL,NULL,NULL),
(31010201,@LongtermWarrantyProvision,@AC310102, '31010201', N'Non-current warranty provision', N'مخصص الضمان غير المتداول',@XXX,NULL, NULL,NULL,NULL),
(31010202,@LongtermRestructuringProvision,@AC310102, '31010202', N'Non-current restructuring provision', N'مخصص إعادة الهيكلة غير المتداول',@XXX,NULL, NULL,NULL,NULL),
(31010203,@LongtermLegalProceedingsProvision,@AC310102, '31010203', N'Non-current legal proceedings provision', N'المخصص غير المتداول للإجراءات القانونية',@XXX,NULL, NULL,NULL,NULL),
(31010204,@NoncurrentRefundsProvision,@AC310102, '31010204', N'Non-current refunds provision', N'مخصص الرديات غير المتداول',@XXX,NULL, NULL,NULL,NULL),
(31010205,@LongtermOnerousContractsProvision,@AC310102, '31010205', N'Non-current onerous contracts provision', N'مخصص العقود المثقلة بالالتزامات غير المتداول',@XXX,NULL, NULL,NULL,NULL),
(31010206,@LongtermProvisionForDecommissioningRestorationAndRehabilitationCosts,@AC310102, '31010206', N'Non-current provision for decommissioning, restoration and rehabilitation costs', N'المخصص غير المتداول لتكاليف التفكيك والإزالة والتأهيل',@XXX,NULL, NULL,NULL,NULL),
(31010299,@LongtermMiscellaneousOtherProvisions,@AC310102, '31010299', N'Non-current miscellaneous other provisions', N'مخصصات أخرى متنوعة غير متداولة',@XXX,NULL, NULL,NULL,NULL),
(32010100,@CurrentProvisionsForEmployeeBenefits,@AC320101, '32010100', N'Current provisions for employee benefits -', N'المخصصات المتداولة لمنافع الموظفين -',@XXX,NULL, NULL,NULL,NULL),
(32010201,@ShorttermWarrantyProvision,@AC320102, '32010201', N'Current warranty provision', N'مخصص الضمان المتداول',@XXX,NULL, NULL,NULL,NULL),
(32010202,@ShorttermRestructuringProvision,@AC320102, '32010202', N'Current restructuring provision', N'مخصص إعادة الهيكلة المتداول',@XXX,NULL, NULL,NULL,NULL),
(32010203,@ShorttermLegalProceedingsProvision,@AC320102, '32010203', N'Current legal proceedings provision', N'مخصص الإجراءات القانونية الحالي',@XXX,NULL, NULL,NULL,NULL),
(32010204,@CurrentRefundsProvision,@AC320102, '32010204', N'Current refunds provision', N'مخصص الرديات المتداول',@XXX,NULL, NULL,NULL,NULL),
(32010205,@ShorttermOnerousContractsProvision,@AC320102, '32010205', N'Current onerous contracts provision', N'المخصص المتداول للعقود المثقلة بالالتزامات',@XXX,NULL, NULL,NULL,NULL),
(32010206,@ShorttermProvisionForDecommissioningRestorationAndRehabilitationCosts,@AC320102, '32010206', N'Current provision for decommissioning, restoration and rehabilitation costs', N'المخصص المتداول لتكاليف الإزالة والترميم وإعادة التأهيل',@XXX,NULL, NULL,NULL,NULL),
(32010207,@ShorttermMiscellaneousOtherProvisions,@AC320102, '32010207', N'Current miscellaneous other provisions', N'مخصصات أخرى متنوعة حالية',@XXX,NULL, NULL,NULL,NULL),
(32020100,@TradeAndOtherCurrentPayablesToTradeSuppliers,@AC320201, '32020100', N'Current trade payables -', N'الذمم الدائنة االتجارية المتداولة -',NULL,NULL, NULL,@SupplierCD,NULL),
(32020200,@TradeAndOtherCurrentPayablesToRelatedParties,@AC320202, '32020200', N'Current payables to related parties -', N'الذمم الدائنة المتداولة إلى الأطراف ذات العلاقة -',NULL,NULL, NULL,@SupplierCD,NULL),
(32020310,@DeferredIncomeClassifiedAsCurrent,@AC320203, '32020310', N'Deferred income classified as current -', N'الدخل المؤجل المصنف على أنه متداول -',NULL,NULL, NULL,@CustomerCD,NULL),
(32020320,@RentDeferredIncomeClassifiedAsCurrent,@AC320203, '32020320', N'Rent deferred income classified as current', N'الدخل المؤجل للإيجار المصنف على أنه جاري',NULL,NULL, NULL,@CustomerCD,NULL),
(32020410,@AccrualsClassifiedAsCurrent,@AC320204, '32020410', N'Accrued expenses - ', N'الاستحقاقات المصنفة على أنها متداولة -',NULL,NULL, NULL,@SupplierCD,NULL),
(32020490,@ShorttermEmployeeBenefitsAccruals,@AC320204, '32020490', N'Short-term employee benefits accruals', N'مستحقات منافع الموظفين قصيرة الاجل',@XXX,NULL, NULL,@EmployeeCD,NULL),
(32020500,@CurrentBilledButNotIssuedExtension,@AC320205, '32020500', N'Current billed but not delivered to trade customers -', N'مطالبات دون تسليم سلع وخدمات إلى الزبائن -',NULL,NULL, NULL,@CustomerCD,NULL),
(32020601,@CurrentValueAddedTaxPayables,@AC320206, '32020601', N'Current value added tax payables', N'الذمم الدائنة لضريبة القيمة المضافة الحالية',@XXX,NULL, NULL,NULL,@CustomerCD),
(32020602,@CurrentExciseTaxPayables,@AC320206, '32020602', N'Current excise tax payables', N'الذمم الدائنة المتداولة للاستبقاء',@XXX,NULL, NULL,NULL,NULL),
(32020603,@CurrentSocialSecurityPayablesExtension,@AC320206, '32020603', N'Current Social Security payables', N'الدائنة الحالية الضمان الاجتماعي',@XXX,NULL, NULL,NULL,@EmployeeCD),
(32020604,@CurrentZakatPayablesExtension,@AC320206, '32020604', N'Current Zakat payables', N'دائنة الزكاة الحالية',@XXX,NULL, NULL,NULL,NULL),
(32020605,@CurrentEmployeeIncomeTaxPayablesExtension,@AC320206, '32020605', N'Current Employee Income tax payables', N'دائنة ضريبة الدخل الحالية موظف',@XXX,NULL, NULL,NULL,@EmployeeCD),
(32020606,@CurrentEmployeeStampTaxPayablesExtension,@AC320206, '32020606', N'Current Employee Stamp tax payables', N'الموظف الحالي دائنة ضريبة الدمغة',@XXX,NULL, NULL,NULL,@EmployeeCD),
(32020607,@ProvidentFundPayableExtension,@AC320206, '32020607', N'Provident fund payable', N'صندوق الادخار تدفع',@XXX,NULL, NULL,NULL,@EmployeeCD),
(32020608,@WithholdingTaxPayableExtension,@AC320206, '32020608', N'Withholding tax payable', N'الضريبة المستحقة',@XXX,NULL, NULL,NULL,@SupplierCD),
(32020609,@CostSharingPayableExtension,@AC320206, '32020609', N'Cost sharing payable', N'تقاسم التكاليف المستحقة',@XXX,NULL, NULL,NULL,@EmployeeCD),
(32020610,@DividendTaxPayableExtension,@AC320206, '32020610', N'Dividend tax payable', N'ضريبة أرباح مستحقة الدفع',@XXX,NULL, NULL,NULL,@PartnerCD),
(32020700,@CurrentRetentionPayables,@AC320207, '32020700', N'Current retention payables - ', N'دائنة الاحتفاظ الحالية -',NULL,NULL, NULL,@SupplierCD,NULL),
(32020701,@CurrentRetentionPayables,@AC320207, '32020701', N'Current retention payables (by contractor)', N'دائنة الاحتفاظ الحالي (قبل المقاول)',NULL,NULL, NULL,NULL,NULL),
(41010101,@RevenueFromSaleOfGoods,@AC410101, '41010101', N'Revenue from sale of goods (by product type and business unit)', N'الإيرادات من بيع السلع (بنوع المنتج ووحدة الأعمال)',@XXX,NULL, NULL,NULL,@CustomerCD),
(41020101,@RevenueFromRenderingOfServices,@AC410201, '41020101', N'Revenue from rendering of services (by service type and business unit)', N'الإيرادات من تقديم الخدمات (بنوع الخدمة ووحدة الأعمال)',@XXX,NULL, NULL,NULL,@CustomerCD),
(41080101,@RevenueFromDividends,@AC410801, '41080101', N'Dividend income (by investment)', N'دخل أرباح الأسهم (باسم المساهمة)',NULL,NULL, NULL,NULL,NULL),
(41990001,@OtherRevenue,@AC419900, '41990001', N'Revenue from sale of byproducts (by item type)', N'إيراد بيع المخلفات (باسم المنتج)',NULL,NULL, NULL,NULL,NULL),
(42000001,@OtherIncome,@AC420000, '42000001', N'Other income 1', N'دخل آخر 1',NULL,NULL, NULL,NULL,NULL),
(42000002,@OtherIncome,@AC420000, '42000002', N'Other income 2', N'دخل آخر 2',NULL,NULL, NULL,NULL,NULL),
(43030101,@InsuranceExpense,@AC430301, '43030101', N'Insurance expense 1', N'مصروف التأمين 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030102,@InsuranceExpense,@AC430301, '43030102', N'Insurance expense 2', N'مصروف التأمين 2',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030201,@ProfessionalFeesExpense,@AC430302, '43030201', N'Professional fees expense 1', N'مصروف الرسوم المهنية 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030202,@ProfessionalFeesExpense,@AC430302, '43030202', N'Professional fees expense 2', N'مصروف الرسوم المهنية 2',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030301,@TransportationExpense,@AC430303, '43030301', N'Transportation expense 1', N'مصروف النقل 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030302,@TransportationExpense,@AC430303, '43030302', N'Transportation expense 2', N'مصروف النقل 2',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030401,@BankAndSimilarCharges,@AC430304, '43030401', N'Bank and similar charges 1', N'الرسوم البنكية والرسوم المشابهة 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030402,@BankAndSimilarCharges,@AC430304, '43030402', N'Bank and similar charges 2', N'الرسوم البنكية والرسوم المشابهة 2',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030501,@TravelExpense,@AC430305, '43030501', N'Travel expense 1', N'مصروفات السفر 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030502,@TravelExpense,@AC430305, '43030502', N'Travel expense 2', N'مصروفات السفر 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030601,@CommunicationExpense,@AC430306, '43030601', N'Communication expense 1', N'مصروفات الاتصالات 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030602,@CommunicationExpense,@AC430306, '43030602', N'Communication expense 2', N'مصروفات الاتصالات 2',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030701,@UtilitiesExpense,@AC430307, '43030701', N'Utilities expense 1', N'المصروفات الخدمية 1',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030702,@UtilitiesExpense,@AC430307, '43030702', N'Utilities expense 2', N'المصروفات الخدمية 2',@XXX,NULL, NULL,NULL,@SupplierCD),
(43030801,@AdvertisingExpense,@AC430308, '43030801', N'Advertising expense 1', N'مصروفات الدعاية 1',NULL,NULL, NULL,NULL,NULL),
(43030802,@AdvertisingExpense,@AC430308, '43030802', N'Advertising expense 2', N'مصروفات الدعاية 2',NULL,NULL, NULL,NULL,NULL),
(43040100,@WagesAndSalaries,@AC430401, '43040100', N'Wages and salaries (itemized)', N'الأجور والرواتب (مفصلة)',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040101,@WagesAndSalaries,@AC430401, '43040101', N'Basic salary', N'الراتب الاساسي',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040102,@WagesAndSalaries,@AC430401, '43040102', N'Transportation Allowance', N'بدل النقل',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040103,@WagesAndSalaries,@AC430401, '43040103', N'Allowance 2', N'بدل/علاوة 2',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040104,@WagesAndSalaries,@AC430401, '43040104', N'Allowance 3', N'بدل/علاوة 3',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040201,@SocialSecurityContributions,@AC430402, '43040201', N'Pension contributions', N'مساهمات في صندوق التقاعد',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040202,@SocialSecurityContributions,@AC430402, '43040202', N'Constribution 2', N'مساهمات 3',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040203,@SocialSecurityContributions,@AC430402, '43040203', N'Constribution 3', N'مساهمات 2',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040301,@OtherShorttermEmployeeBenefits,@AC430403, '43040301', N'Short term benefits 1', N'منافع قصيرة الأجل 1',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040302,@OtherShorttermEmployeeBenefits,@AC430403, '43040302', N'Short term benefits 2', N'منافع قصيرة الأجل 2',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040303,@OtherShorttermEmployeeBenefits,@AC430403, '43040303', N'Short term benefits 3', N'منافع قصيرة الأجل 3',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040601,@TerminationBenefitsExpense,@AC430406, '43040601', N'Termination benefits 1', N'منافع إنهاء 1',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040602,@TerminationBenefitsExpense,@AC430406, '43040602', N'Termination benefits 2', N'منافع إنهاء 2',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43040701,@OtherLongtermBenefits,@AC430407, '43040701', N'Other long-term employee benefits 1', N'منافع الموظفين طويلة الاجل الأخرى 1',NULL,NULL, NULL,NULL,NULL),
(43040702,@OtherLongtermBenefits,@AC430407, '43040702', N'Other long-term employee benefits 2', N'منافع الموظفين طويلة الاجل الأخرى 2',NULL,NULL, NULL,NULL,NULL),
(43049901,@OtherEmployeeExpense,@AC430499, '43049901', N'Other employee expense 1', N'مصروف آخر للموظفين 1',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43049902,@OtherEmployeeExpense,@AC430499, '43049902', N'Other employee expense 2', N'مصروف آخر للموظفين 2',@XXX,NULL, NULL,NULL,@EmployeeCD),
(43050101,@DepreciationExpense,@AC430501, '43050101', N'Depreciation expense (by asset type)', N'مصروف الاستهلاك (حسب نوع الأصول)',@XXX,NULL, NULL,NULL,NULL),
(43050201,@AmortisationExpense,@AC430502, '43050201', N'Amortisation expense (by asset type)', N'مصروف الإطفاء (حسب نوع الأصول)',@XXX,NULL, NULL,NULL,NULL),
(43990001,@OtherExpenseByNature,@AC439900, '43990001', N'Other expenses 1', N'مصاريف أخرى 1',NULL,NULL, NULL,NULL,NULL),
(43990002,@OtherExpenseByNature,@AC439900, '43990002', N'Other expenses 2', N'مصاريف أخرى 2',NULL,NULL, NULL,NULL,NULL),
(44020100,@GainsLossesOnDisposalsOfPropertyPlantAndEquipment,@AC440201, '44020100', N'Gain (loss) on disposal of property, plant and equipment (by asset)', N'الأرباح (الخسائر) من التصرف بالممتلكات والمصانع والمعدات (بالأصل)',NULL,NULL, NULL,NULL,NULL),
(51040001,@FinanceCosts,@AC510400, '51040001', N'Finance costs 1', N'تكاليف التمويل 1',NULL,NULL, NULL,NULL,NULL),
(51040002,@FinanceCosts,@AC510400, '51040002', N'Finance costs 2', N'تكاليف التمويل 2',NULL,NULL, NULL,NULL,NULL),
(62010100,@GainsLossesOnExchangeDifferencesOnTranslationBeforeTax,@AC620101, '62010100', N'Gains (losses) on exchange differences on translation, before tax -', N'الأرباح (الخسائر) من فروق الصرف عند التحويل، قبل الضريبة',NULL,NULL, NULL,NULL,NULL),
(62010200,@ReclassificationAdjustmentsOnExchangeDifferencesOnTranslationBeforeTax,@AC620102, '62010200', N'Reclassification adjustments on exchange differences on translation, before tax -', N'تعديلات إعادة التصنيف على فروق الصرف عند التحويل، قبل الضريبة',NULL,NULL, NULL,NULL,NULL),
(71010001,@CashPaymentsToSuppliersControlExtension,@AC710100, '71010001', N'Cash payments to suppliers control', N'مراقبة دفعيات الموردين',NULL,NULL, NULL,@SupplierCD,NULL),
(71010002,@GoodsAndServicesReceivedFromSuppliersControlExtensions,@AC710100, '71010002', N'Goods/services received from suppliers control', N'مراقبة استلام السلع/الخدمات من الموردين',NULL,NULL, NULL,@SupplierCD,NULL),
(71020001,@CashReceiptsFromCustomersControlExtension,@AC710200, '71020001', N'Cash receipts from customers control', N'مراقبة دفعيات الزبائن',NULL,NULL, NULL,@CustomerCD,NULL),
(71020002,@GoodsAndServicesIssuedToCustomersControlExtension,@AC710200, '71020002', N'Goods/Services delivered to customers control', N'مراقبة تسليم السلع/الخدمات إلى الزبائن',NULL,NULL, NULL,@CustomerCD,NULL),
(71090001,@CashPaymentsToOthersControlExtension,@AC710900, '71090001', N'Cash payments to others control', N'مراقبة الدفعيات إلى الآخرين',NULL,NULL, NULL,NULL,NULL),
(71090002,@CashReceiptsFromOthersControlExtension,@AC710900, '71090002', N'Cash receipts from others control', N'مراقبة الدفعيات من الآخرين',NULL,NULL, NULL,NULL,NULL),
(72000100,@CollectionGuaranteeExtension,@AC720001, '72000100', N'Checks Guarantee -', N'شيكات ضمان',NULL,NULL, NULL,@CustomerCD,NULL),
(72000200,@DishonouredGuaranteeExtension,@AC720002, '72000200', N'Checks Dishonored -', N'شيكات مرتجعة',NULL,NULL, NULL,@CustomerCD,NULL)

EXEC [api].[Accounts__Save]
	@Entities = @Accounts,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Inserting Accounts: ' + @ValidationErrorsJson
	GOTO Err_Label;
END;

DELETE FROM @IndexedIds;
INSERT INTO @IndexedIds([Index], [Id]) SELECT ROW_NUMBER() OVER(ORDER BY [Id]), [Id]  FROM dbo.Accounts
WHERE AccountTypeId IN (SELECT [Id] FROM dbo.AccountTypes WHERE [IsActive] = 0)
-- Detailed rental properties reveivable, staff debtors, sundry debtors
OR CODE IN (N'12020701' , N'12050101', N'12050201')
-- Detailed Cash on hand
OR CODE BETWEEN N'12070111' AND N'12070113'
-- Detaild bank account
OR CODE BETWEEN N'12070131' AND N'12070133'
--OR CODE BETWEEN N'12070131' AND N'12070133'


EXEC [api].[Accounts__Activate]
	@IndexedIds = @IndexedIds,
	@IsActive =0,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

IF @ValidationErrorsJson IS NOT NULL 
BEGIN
	Print 'Accounts: Deactivating: ' + @ValidationErrorsJson
	GOTO Err_Label;
END;