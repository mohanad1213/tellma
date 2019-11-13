﻿CREATE PROCEDURE [dbo].[rpt_BankAccount__Statement]
-- EXEC [dbo].[rpt_BankAccount__Statement](104, '01.01.2015', '01.01.2020')
	@AccountId INT,
	@fromDate Date = '01.01.2000', 
	@toDate Date = '01.01.2100'
AS
BEGIN
	SELECT 	
		[Id],
		[DocumentLineId],
		[DocumentDate],
		[DocumentDefinitionId],
		[SerialNumber],
		[Direction],
		[EntryTypeId],
		[MonetaryValue],
		[Value],
		[VoucherNumericReference] As [CPV_CRV_Ref],
		[Memo],
		[ExternalReference] As [CheckRef],
		[RelatedResourceId] As [OtherPartyCurrency],
		[RelatedAgentId] As [OtherParty],
		[RelatedMonetaryValue] As [OtherPartyAmount]
	FROM [dbo].[fi_Journal](@fromDate, @toDate)
	WHERE [AccountId] = @AccountId;
END;
GO;