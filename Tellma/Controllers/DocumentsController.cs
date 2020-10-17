﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.Extensions.Primitives;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Tellma.Controllers.Dto;
using Tellma.Controllers.ImportExport;
using Tellma.Controllers.Templating;
using Tellma.Controllers.Utilities;
using Tellma.Data;
using Tellma.Data.Queries;
using Tellma.Entities;
using Tellma.Services.BlobStorage;
using Tellma.Services.ClientInfo;
using Tellma.Services.MultiTenancy;
using Tellma.Services.Utilities;

namespace Tellma.Controllers
{
    [Route("api/" + BASE_ADDRESS + "{definitionId}")]
    [ApplicationController]
    public class DocumentsController : CrudControllerBase<DocumentForSave, Document, int>
    {
        public const string BASE_ADDRESS = "documents/";

        private readonly DocumentsService _service;

        public DocumentsController(DocumentsService service, IServiceProvider sp) : base(sp)
        {
            _service = service;
        }

        [HttpGet("{docId}/attachments/{attachmentId}")]
        public async Task<ActionResult> GetAttachment(int docId, int attachmentId, CancellationToken cancellation)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var (fileBytes, fileName) = await _service.GetAttachment(docId, attachmentId, cancellation);
                var contentType = ContentType(fileName);
                return File(fileContents: fileBytes, contentType: contentType, fileName);
            }, _logger);
        }

        [HttpPut("assign")]
        public async Task<ActionResult<EntitiesResponse<Document>>> Assign([FromBody] List<int> ids, [FromQuery] AssignArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.Assign(ids, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }
            , _logger);
        }

        [HttpPut("sign-lines")]
        public async Task<ActionResult<EntitiesResponse<Document>>> SignLines([FromBody] List<int> lineIds, [FromQuery] SignArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.SignLines(lineIds, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }
            , _logger);
        }

        [HttpPut("unsign-lines")]
        public async Task<ActionResult<EntitiesResponse<Document>>> UnsignLines([FromBody] List<int> signatureIds, [FromQuery] ActionArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.UnsignLines(signatureIds, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }
            , _logger);
        }

        [HttpPut("close")]
        public async Task<ActionResult<EntitiesResponse<Document>>> Close([FromBody] List<int> ids, [FromQuery] ActionArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.Close(ids, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }, _logger);
        }

        [HttpPut("open")]
        public async Task<ActionResult<EntitiesResponse<Document>>> Open([FromBody] List<int> ids, [FromQuery] ActionArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.Open(ids, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }, _logger);
        }

        [HttpPut("cancel")]
        public async Task<ActionResult<EntitiesResponse<Document>>> Cancel([FromBody] List<int> ids, [FromQuery] ActionArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.Cancel(ids, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }, _logger);
        }

        [HttpPut("uncancel")]
        public async Task<ActionResult<EntitiesResponse<Document>>> Uncancel([FromBody] List<int> ids, [FromQuery] ActionArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.Uncancel(ids, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }, _logger);
        }

        [HttpGet("{docId}/print/{templateId}")]
        public async Task<ActionResult> PrintById(int docId, int templateId, [FromQuery] GenerateMarkupByIdArguments args, CancellationToken cancellation)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var (fileBytes, fileName) = await _service.PrintById(docId, templateId, args, cancellation);
                var contentType = ContentType(fileName);
                return File(fileContents: fileBytes, contentType: contentType, fileName);
            }, _logger);
        }

        [HttpGet("print/{templateId}")]
        public async Task<ActionResult> PrintByFilter(int templateId, [FromQuery] GenerateMarkupByFilterArguments<int> args, CancellationToken cancellation)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var (fileBytes, fileName) = await _service.PrintByFilter(templateId, args, cancellation);
                var contentType = ContentType(fileName);
                return File(fileContents: fileBytes, contentType: contentType, fileName);
            }, _logger);
        }

        [HttpGet("generate-lines/{lineDefId}")]
        public async Task<ActionResult<EntitiesResponse<LineForSave>>> Generate([FromRoute] int lineDefId, [FromQuery] Dictionary<string, string> args, CancellationToken cancellation)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (lines, accounts, custodies, resources, relations, entryTypes, centers, currencies, units) = await _service.Generate(lineDefId, args, cancellation);

                // Related entitiess
                var relatedEntities = new Dictionary<string, IEnumerable<Entity>>
                {
                    { GetCollectionName(typeof(Account)), accounts },
                    { GetCollectionName(typeof(Custody)), custodies },
                    { GetCollectionName(typeof(Resource)), resources },
                    { GetCollectionName(typeof(Relation)), relations },
                    { GetCollectionName(typeof(EntryType)), entryTypes },
                    { GetCollectionName(typeof(Center)), centers },
                    { GetCollectionName(typeof(Currency)), currencies },
                    { GetCollectionName(typeof(Unit)), units }
                };

                // Prepare the result in a response object
                var response = new EntitiesResponse<LineForSave>
                {
                    Result = lines,
                    RelatedEntities = relatedEntities,
                    CollectionName = "", // Not important
                    ServerTime = serverTime,
                };

                // Return
                return Ok(response);
            }, _logger);
        }

        protected override CrudServiceBase<DocumentForSave, Document, int> GetCrudService()
        {
            return _service;
        }

        protected override Extras TransformExtras(Extras extras, CancellationToken cancellation)
        {
            if (extras != null && extras.TryGetValue("RequiredSignatures", out object requiredSignaturesObj))
            {
                var requiredSignatures = requiredSignaturesObj as List<RequiredSignature>;

                var relatedEntities = FlattenAndTrim(requiredSignatures, cancellation);
                requiredSignatures.ForEach(rs => rs.EntityMetadata = null); // Smaller response size

                extras["RequiredSignaturesRelatedEntities"] = relatedEntities;
            }

            return extras;
        }

        private string ContentType(string fileName)
        {
            var provider = new FileExtensionContentTypeProvider();
            if (!provider.TryGetContentType(fileName, out string contentType))
            {
                contentType = "application/octet-stream";
            }

            return contentType;
        }
    }

    public class DocumentsService : CrudServiceBase<DocumentForSave, Document, int>
    {
        private readonly TemplateService _templateService;
        private readonly ApplicationRepository _repo;
        private readonly ITenantIdAccessor _tenantIdAccessor;
        private readonly IBlobService _blobService;
        private readonly IDefinitionsCache _definitionsCache;
        private readonly ISettingsCache _settingsCache;
        private readonly IClientInfoAccessor _clientInfo;
        private readonly ITenantInfoAccessor _tenantInfoAccessor;
        private readonly IHubContext<ServerNotificationsHub, INotifiedClient> _hubContext;
        private readonly IHttpContextAccessor _contextAccessor;

        // Used across multiple methods
        private List<(string, byte[])> _blobsToSave;
        private List<InboxNotificationInfo> _notificationInfos;
        private List<string> _fileIdsToDelete;

        /// <summary>
        /// This is used in preprocessing and validation when a tab entry is null
        /// </summary>
        private static readonly DocumentLineDefinitionEntryForSave DefaultTabEntry = new DocumentLineDefinitionEntryForSave
        {
            PostingDateIsCommon = true,
            MemoIsCommon = true,
            ParticipantIsCommon = true,
            CurrencyIsCommon = true,
            CustodyIsCommon = true,
            ResourceIsCommon = true,
            QuantityIsCommon = true,
            UnitIsCommon = true,
            CenterIsCommon = true,
            Time1IsCommon = true,
            Time2IsCommon = true,
            ExternalReferenceIsCommon = true,
            AdditionalReferenceIsCommon = true
        };

        /// <summary>
        /// Checks if the supplied DocumentLineDefinitionEntryForSave is equivalent to the default one (ignoring Id, LineDefinitionId and EntryIndex properties)
        /// </summary>
        private static bool EqualsDefaultTabEntry(DocumentLineDefinitionEntryForSave tabEntry)
        {
            var desc = Entities.Descriptors.TypeDescriptor.Get<DocumentLineDefinitionEntryForSave>();
            return desc.Properties.All(p =>
            {
                switch (p.Name)
                {
                    case nameof(DocumentLineDefinitionEntryForSave.Id):
                    case nameof(DocumentLineDefinitionEntryForSave.LineDefinitionId):
                    case nameof(DocumentLineDefinitionEntryForSave.EntryIndex):
                        return true; // Those properties don't matter for the comparison
                    default:
                        // Everything else must match
                        var expected = p.GetValue(DefaultTabEntry);
                        var actual = p.GetValue(tabEntry);

                        return (expected == null && actual == null) ||
                            (expected != null && actual != null && expected.Equals(actual));
                }
            });
        }

        public DocumentsService(TemplateService templateService,
            ApplicationRepository repo, ITenantIdAccessor tenantIdAccessor, IBlobService blobService,
            IDefinitionsCache definitionsCache, ISettingsCache settingsCache, IClientInfoAccessor clientInfo,
            ITenantInfoAccessor tenantInfoAccessor, IServiceProvider sp,
            IHubContext<ServerNotificationsHub, INotifiedClient> hubContext, IHttpContextAccessor contextAccessor) : base(sp)
        {
            _templateService = templateService;
            _repo = repo;
            _tenantIdAccessor = tenantIdAccessor;
            _tenantIdAccessor = tenantIdAccessor;
            _blobService = blobService;
            _definitionsCache = definitionsCache;
            _settingsCache = settingsCache;
            _clientInfo = clientInfo;
            _tenantInfoAccessor = tenantInfoAccessor;
            _hubContext = hubContext;
            _contextAccessor = contextAccessor;
        }

        #region Context Params

        private bool? _includeRequiredSignaturesOverride;
        private int? _definitionIdOverride;

        private int TenantId => _tenantIdAccessor.GetTenantId(); // Syntactic sugar

        protected override int? DefinitionId
        {
            get
            {
                if (_definitionIdOverride != null)
                {
                    return _definitionIdOverride;
                }

                string routeDefId = _contextAccessor.HttpContext?.Request?.RouteValues?.GetValueOrDefault("definitionId")?.ToString();
                if (routeDefId != null)
                {
                    if (int.TryParse(routeDefId, out int definitionId))
                    {
                        return definitionId;
                    }
                    else
                    {
                        throw new BadRequestException($"DefinitoinId '{routeDefId}' cannot be parsed into an integer");
                    }
                }

                throw new BadRequestException($"Bug: DefinitoinId could not be determined in {nameof(ResourcesService)}");
            }
        }

        private bool IncludeRequiredSignatures =>
            _includeRequiredSignaturesOverride ?? GetQueryParameter("includeRequiredSignatures")?.ToLower() == "true";

        private string GetQueryParameter(string name)
        {
            var query = _contextAccessor.HttpContext?.Request?.Query;
            if (query != null && query.TryGetValue(name, out StringValues value))
            {
                return value.FirstOrDefault();
            }

            return null;
        }

        private string View => $"{DocumentsController.BASE_ADDRESS}{DefinitionId}";

        private DocumentDefinitionForClient Definition() => _definitionsCache.GetCurrentDefinitionsIfCached()?.Data?.Documents?
            .GetValueOrDefault(DefinitionId.Value) ?? throw new InvalidOperationException($"Document Definition with Id = {DefinitionId} is missing from the cache");

        private LineDefinitionForClient LineDefinition(int lineDefId) => _definitionsCache.GetCurrentDefinitionsIfCached()?.Data?.Lines?
            .GetValueOrDefault(lineDefId) ?? throw new InvalidOperationException($"Line Definition with Id = {lineDefId} is missing from the cache");

        #endregion

        #region State & Workflow

        public async Task<(List<Document>, Extras)> Assign(List<int> ids, AssignArguments args)
        {
            // Check user permissions
            var action = Constants.Read;
            var actionFilter = await UserPermissionsFilter(action, cancellation: default);
            ids = await CheckActionPermissionsBefore(actionFilter, ids);

            // C# Validation 
            if (args.AssigneeId == 0)
            {
                throw new BadRequestException(_localizer[Constants.Error_Field0IsRequired, nameof(args.AssigneeId)]);
            }

            // Execute and return
            using var trx = ControllerUtilities.CreateTransaction();

            // Validate
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var errors = await _repo.Documents_Validate__Assign(
                ids,
                args.AssigneeId,
                args.Comment,
                top: remainingErrorCount
                );

            ControllerUtilities.AddLocalizedErrors(ModelState, errors, _localizer);
            if (!ModelState.IsValid)
            {
                throw new UnprocessableEntityException(ModelState);
            }

            // Actual Assignment
            var notificationInfos = await _repo.Documents__Assign(ids, args.AssigneeId, args.Comment, recordInHistory: true);

            List<Document> data = null;
            Extras extras = null;

            if (args.ReturnEntities ?? false)
            {
                (data, extras) = await GetByIds(ids, args, action, cancellation: default);
            }

            // Check user permissions again
            await CheckActionPermissionsAfter(actionFilter, ids, data);

            // Notify relevant parties
            await _hubContext.NotifyInboxAsync(TenantId, notificationInfos);

            trx.Complete();
            return (data, extras);
        }

        public async Task<(List<Document>, Extras)> SignLines(List<int> lineIds, SignArguments args)
        {
            var returnEntities = args.ReturnEntities ?? false;

            // C# Validation 
            if (string.IsNullOrWhiteSpace(args.RuleType))
            {
                throw new BadRequestException(_localizer[Constants.Error_Field0IsRequired, nameof(args.RuleType)]);
            }

            // Execute and return
            using var trx = ControllerUtilities.CreateTransaction();

            // Validate
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var errors = await _repo.Lines_Validate__Sign(
                lineIds,
                args.OnBehalfOfUserId,
                args.RuleType,
                args.RoleId,
                args.ToState,
                top: remainingErrorCount
                );

            ControllerUtilities.AddLocalizedErrors(ModelState, errors, _localizer);
            if (!ModelState.IsValid)
            {
                throw new UnprocessableEntityException(ModelState);
            }

            // Sign
            var documentIds = await _repo.Lines__SignAndRefresh(
                lineIds,
                args.ToState,
                args.ReasonId,
                args.ReasonDetails,
                args.OnBehalfOfUserId,
                args.RuleType,
                args.RoleId,
                args.SignedAt ?? DateTimeOffset.Now,
                returnIds: returnEntities);

            if (returnEntities)
            {
                var response = await GetByIds(documentIds.ToList(), args, Constants.Read, cancellation: default);

                trx.Complete();
                return response;
            }
            else
            {
                trx.Complete();
                return default;
            }
        }

        public async Task<(List<Document>, Extras)> UnsignLines(List<int> signatureIds, ActionArguments args)
        {
            var returnEntities = args.ReturnEntities ?? false;

            // C# Validation 
            // Goes here

            // Execute and return
            using var trx = ControllerUtilities.CreateTransaction();

            // Validate
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var errors = await _repo.LineSignatures_Validate__Delete(signatureIds, top: remainingErrorCount);
            ControllerUtilities.AddLocalizedErrors(ModelState, errors, _localizer);

            if (!ModelState.IsValid)
            {
                throw new UnprocessableEntityException(ModelState);
            }

            // Unsign
            var documentIds = await _repo.LineSignatures__DeleteAndRefresh(signatureIds, returnIds: returnEntities);
            if (returnEntities)
            {
                var response = await GetByIds(documentIds.ToList(), args, Constants.Read, cancellation: default);

                trx.Complete();
                return response;
            }
            else
            {
                trx.Complete();
                return default;
            }
        }

        public async Task<(List<Document>, Extras)> Close(List<int> ids, ActionArguments args)
        {
            return await UpdateDocumentState(ids, args, nameof(Close));
        }

        public async Task<(List<Document>, Extras)> Open(List<int> ids, ActionArguments args)
        {
            return await UpdateDocumentState(ids, args, nameof(Open));
        }

        public async Task<(List<Document>, Extras)> Cancel(List<int> ids, ActionArguments args)
        {
            return await UpdateDocumentState(ids, args, nameof(Cancel));
        }

        public async Task<(List<Document>, Extras)> Uncancel(List<int> ids, ActionArguments args)
        {
            return await UpdateDocumentState(ids, args, nameof(Uncancel));
        }

        private async Task<(List<Document>, Extras)> UpdateDocumentState(List<int> ids, ActionArguments args, string transition)
        {
            // Check user permissions
            var action = "State";
            var actionFilter = await UserPermissionsFilter(action, cancellation: default);
            ids = await CheckActionPermissionsBefore(actionFilter, ids);

            // C# Validation 
            // TODO

            // Transaction
            using var trx = ControllerUtilities.CreateTransaction();

            // Validate
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var errors = transition switch
            {
                nameof(Close) => await _repo.Documents_Validate__Close(DefinitionId.Value, ids, top: remainingErrorCount),
                nameof(Open) => await _repo.Documents_Validate__Open(DefinitionId.Value, ids, top: remainingErrorCount),
                nameof(Cancel) => await _repo.Documents_Validate__Cancel(DefinitionId.Value, ids, top: remainingErrorCount),
                nameof(Uncancel) => await _repo.Documents_Validate__Uncancel(DefinitionId.Value, ids, top: remainingErrorCount),
                _ => throw new BadRequestException($"Unknown transition {transition}"),
            };

            ControllerUtilities.AddLocalizedErrors(ModelState, errors, _localizer);
            if (!ModelState.IsValid)
            {
                throw new UnprocessableEntityException(ModelState);
            }

            var notificationInfos = transition switch
            {
                nameof(Close) => await _repo.Documents__Close(ids),
                nameof(Open) => await _repo.Documents__Open(ids),
                nameof(Cancel) => await _repo.Documents__Cancel(ids),
                nameof(Uncancel) => await _repo.Documents__Uncancel(ids),
                _ => throw new BadRequestException($"Unknown transition {transition}"),
            };

            List<Document> data = null;
            Extras extras = null;

            if (args.ReturnEntities ?? false)
            {
                (data, extras) = await GetByIds(ids, args, action, cancellation: default);
            }

            // Check user permissions again
            await CheckActionPermissionsAfter(actionFilter, ids, data);

            // Non-transactional stuff
            await _hubContext.NotifyInboxAsync(TenantId, notificationInfos);

            // Commit and return
            trx.Complete();
            return (data, extras);
        }

        #endregion

        public async Task<(byte[] FileBytes, string FileName)> GetAttachment(int docId, int attachmentId, CancellationToken cancellation)
        {
            // This enforces read permissions
            string attachments = nameof(Document.Attachments);
            var (doc, _) = await GetById(docId, new GetByIdArguments
            {
                Select = $"{attachments}/{nameof(Attachment.FileId)},{attachments}/{nameof(Attachment.FileName)},{attachments}/{nameof(Attachment.FileExtension)}"
            },
            cancellation);

            // Get the blob name
            var attachment = doc?.Attachments?.FirstOrDefault(att => att.Id == attachmentId);
            if (attachment != null && !string.IsNullOrWhiteSpace(attachment.FileId))
            {
                // Get the bytes
                string blobName = BlobName(attachment.FileId);
                var fileBytes = await _blobService.LoadBlob(blobName, cancellation);

                // Get the content type
                var fileName = $"{attachment.FileName ?? "Attachment"}.{attachment.FileExtension}";
                return (fileBytes, fileName);
            }
            else
            {
                throw new NotFoundException<int>(attachmentId);
            }
        }


        public async Task<(byte[] FileBytes, string FileName)> PrintByFilter([FromRoute] int templateId, [FromQuery] GenerateMarkupByFilterArguments<int> args, CancellationToken cancellation)
        {
            var collection = "Document";
            var defId = DefinitionId;
            var def = Definition();

            if (def.MarkupTemplates == null || !def.MarkupTemplates.Any(e => e.MarkupTemplateId == templateId))
            {
                // A proper UI will only allow the user to use supported template
                throw new BadRequestException($"The requested templateId {templateId} is not one of the supported templates for document definition {DefinitionId}");
            }

            var template = await _repo.Query<MarkupTemplate>().FilterByIds(new int[] { templateId }).FirstOrDefaultAsync(cancellation);
            if (template == null)
            {
                // Shouldn't happen in theory cause of previous check, but just to be extra safe
                throw new BadRequestException($"The template with Id {templateId} does not exist");
            }

            // The errors below should be prevented through SQL validation, but just to be safe
            if (template.Usage != MarkupTemplateConst.QueryByFilter)
            {
                throw new BadRequestException($"The template with Id {templateId} does not have the proper usage");
            }

            if (template.MarkupLanguage != MimeTypes.Html)
            {
                throw new BadRequestException($"The template with Id {templateId} is not an HTML template");
            }

            if (template.Collection != collection)
            {
                throw new BadRequestException($"The template with Id {templateId} does not have Collection = '{collection}'");
            }

            if (template.DefinitionId != defId)
            {
                throw new BadRequestException($"The template with Id {templateId} does not have DefinitionId = '{defId}'");
            }

            // Onto the printing itself
            var templates = new string[] { template.DownloadName, template.Body };
            var culture = TemplateUtil.GetCulture(args, await _repo.GetTenantInfoAsync(cancellation));

            var preloadedQuery = new QueryByFilterInfo(collection, defId, args.Filter, args.OrderBy, args.Top, args.Skip, args.I);
            var inputVariables = new Dictionary<string, object>
            {
                ["$Source"] = $"{collection}/{defId}",
                ["$Filter"] = args.Filter,
                ["$OrderBy"] = args.Filter,
                ["$Top"] = args.Filter,
                ["$Skip"] = args.Filter,
                ["$Ids"] = args.I
            };

            // Generate the output
            string[] outputs;
            try
            {
                outputs = await _templateService.GenerateMarkup(templates, inputVariables, preloadedQuery, culture, cancellation);
            }
            catch (TemplateException ex)
            {
                throw new BadRequestException(ex.Message);
            }

            var downloadName = outputs[0];
            var body = outputs[1];

            // Change the body to bytes
            var bodyBytes = Encoding.UTF8.GetBytes(body);

            // Do some sanitization of the downloadName
            if (string.IsNullOrWhiteSpace(downloadName))
            {
                var tenantInfo = await _repo.GetTenantInfoAsync(cancellation);
                var titlePlural = tenantInfo.Localize(def.TitlePlural, def.TitlePlural2, def.TitlePlural3);
                if (args.I != null && args.I.Count > 0)
                {
                    downloadName = $"{titlePlural} ({args.I.Count})";
                }
                else
                {
                    int from = args.Skip + 1;
                    int to = Math.Max(from, args.Skip + args.Top);
                    downloadName = $"{titlePlural} {from}-{to}";
                }
            }

            if (!downloadName.ToLower().EndsWith(".html"))
            {
                downloadName += ".html";
            }

            // Return as a file
            return (bodyBytes, downloadName);
        }

        public async Task<(byte[] FileBytes, string FileName)> PrintById(int docId, int templateId, [FromQuery] GenerateMarkupArguments args, CancellationToken cancellation)
        {
            var collection = "Document";
            var defId = DefinitionId;
            var def = Definition();

            if (def.MarkupTemplates == null || !def.MarkupTemplates.Any(e => e.MarkupTemplateId == templateId))
            {
                // A proper UI will only allow the user to use supported template
                throw new BadRequestException($"The requested templateId {templateId} is not one of the supported templates for document definition {DefinitionId}");
            }

            var template = await _repo.Query<MarkupTemplate>().FilterByIds(new int[] { templateId }).FirstOrDefaultAsync(cancellation);
            if (template == null)
            {
                // Shouldn't happen in theory cause of previous check, but just to be extra safe
                throw new BadRequestException($"The template with Id {templateId} does not exist");
            }

            // The errors below should be prevented through SQL validation, but just to be safe
            if (template.Usage != MarkupTemplateConst.QueryById)
            {
                throw new BadRequestException($"The template with Id {templateId} does not have the proper usage");
            }

            if (template.MarkupLanguage != MimeTypes.Html)
            {
                throw new BadRequestException($"The template with Id {templateId} is not an HTML template");
            }

            if (template.Collection != collection)
            {
                throw new BadRequestException($"The template with Id {templateId} does not have Collection = '{collection}'");
            }

            if (template.DefinitionId != defId)
            {
                throw new BadRequestException($"The template with Id {templateId} does not have DefinitionId = '{defId}'");
            }

            // Onto the printing itself

            var templates = new string[] { template.DownloadName, template.Body };
            var culture = TemplateUtil.GetCulture(args, await _repo.GetTenantInfoAsync(cancellation));

            var preloadedQuery = new QueryByIdInfo(collection, defId, docId.ToString());
            var inputVariables = new Dictionary<string, object>
            {
                ["$Source"] = $"{collection}/{defId}",
                ["$Id"] = docId
            };

            // Generate the output
            string[] outputs;
            try
            {
                outputs = await _templateService.GenerateMarkup(templates, inputVariables, preloadedQuery, culture, cancellation);
            }
            catch (TemplateException ex)
            {
                throw new BadRequestException(ex.Message);
            }

            var downloadName = outputs[0];
            var body = outputs[1];

            // Change the body to bytes
            var bodyBytes = Encoding.UTF8.GetBytes(body);

            // Do some sanitization of the downloadName
            if (string.IsNullOrWhiteSpace(downloadName))
            {
                downloadName = docId.ToString();
            }

            if (!downloadName.ToLower().EndsWith(".html"))
            {
                downloadName += ".html";
            }

            // Return as a file
            return (bodyBytes, downloadName);
        }

        public override async Task<(Document, Extras)> GetById(int id, GetByIdArguments args, CancellationToken cancellation)
        {
            var (entity, extras) = await base.GetById(id, args, cancellation);

            // TODO it's more accurate to do this from the client side (e.g. if the user views a cached document)
            if (entity.OpenedAt == null)
            {
                var userInfo = await _repo.GetUserInfoAsync(cancellation);
                var userId = userInfo.UserId.Value;

                if (entity.AssigneeId == userId)
                {
                    // Mark the entity's OpenedAt both in the DB and in the returned entity
                    var assignedAt = entity.AssignedAt.Value;
                    var openedAt = DateTimeOffset.Now;
                    var infos = await _repo.Documents__Preview(entity.Id, assignedAt, openedAt);
                    entity.OpenedAt = openedAt;

                    // Notify the user
                    var tenantId = _tenantIdAccessor.GetTenantId();
                    await _hubContext.NotifyInboxAsync(tenantId, infos);
                }
            }

            return (entity, extras);
        }

        public async Task<(
            List<LineForSave> lines,
            List<Account> accounts,
            List<Custody> custodies,
            List<Resource> resources,
            List<Relation> relations,
            List<EntryType> entryTypes,
            List<Center> centers,
            List<Currency> currencies,
            List<Unit> units
            )> Generate(int lineDefId, Dictionary<string, string> args, CancellationToken cancellation)
        {
            // TODO: Permissions (?)

            var lineDef = LineDefinition(lineDefId);

            // Better args will contain only the defined parameter keys and all the defined parameter keys (with possible null values)
            var betterArgs = new Dictionary<string, string>();
            foreach (var param in lineDef.GenerateParameters)
            {
                var value = args.GetValueOrDefault(param.Key);

                // Ensure all required signatures are supplied
                if (param.Visibility == Visibility.Required && string.IsNullOrWhiteSpace(value))
                {
                    var tenantInfo = await _repo.GetTenantInfoAsync(cancellation);
                    var paramLabel = tenantInfo.Localize(param.Label, param.Label2, param.Label3);
                    var msg = _localizer[Constants.Error_Field0IsRequired, paramLabel];
                    throw new BadRequestException(msg);
                }

                betterArgs[param.Key] = value;
            }

            // Call the SP
            return await _repo.Lines__Generate(lineDefId, betterArgs, cancellation);
        }

        protected override IRepository GetRepository()
        {
            string filter = $"{nameof(Document.DefinitionId)} {Ops.eq} {DefinitionId}";
            return new FilteredRepository<Document>(_repo, filter);
        }

        protected override async Task<IEnumerable<AbstractPermission>> UserPermissions(string action, CancellationToken cancellation)
        {
            var permissions = (await _repo.PermissionsFromCache(View, action, cancellation)).ToList();

            // Add a special permission that lets you see the documents that were assigned to you
            permissions.AddRange(DocumentServiceUtil.HardCodedPermissions(action));

            return permissions;
        }

        private DocumentDefinitionForClient CurrentDefinition
        {
            get
            {
                DocumentDefinitionForClient result = null;
                var definitions = _definitionsCache.GetCurrentDefinitionsIfCached()?.Data?.Documents;
                if (definitions != null)
                {
                    definitions.TryGetValue(DefinitionId.Value, value: out result);
                }

                return result;
            }
        }

        protected override Query<Document> Search(Query<Document> query, GetArguments args)
        {
            var prefix = CurrentDefinition?.Prefix;
            var map = new List<(string Prefix, int DefinitionId)>
            {
                (prefix, DefinitionId.Value)
            };
            return DocumentServiceUtil.SearchImpl(query, args, map);
        }

        protected override async Task<Extras> GetExtras(IEnumerable<Document> result, CancellationToken cancellation)
        {
            if (IncludeRequiredSignatures)
            {
                // DocumentIds parameter
                var docIds = result.Select(doc => new IdListItem { Id = doc.Id });
                if (!docIds.Any())
                {
                    return await base.GetExtras(result, cancellation);
                }

                var docIdsTable = RepositoryUtilities.DataTable(docIds);
                var docIdsTvp = new SqlParameter("@DocumentIds", docIdsTable)
                {
                    TypeName = $"[dbo].[IdList]",
                    SqlDbType = System.Data.SqlDbType.Structured
                };

                var query = _repo.Query<RequiredSignature>()
                    .AdditionalParameters(docIdsTvp)
                    .Expand($"{nameof(RequiredSignature.Role)},{nameof(RequiredSignature.Custodian)},{nameof(RequiredSignature.User)},{nameof(RequiredSignature.SignedBy)},{nameof(RequiredSignature.OnBehalfOfUser)},{nameof(RequiredSignature.ProxyRole)}")
                    .OrderBy(nameof(RequiredSignature.LineId));

                var requiredSignatures = await query.ToListAsync(cancellation);

                return new Extras
                {
                    ["RequiredSignatures"] = requiredSignatures
                };
            }
            else
            {
                return await base.GetExtras(result, cancellation);
            }
        }

        protected override async Task<List<DocumentForSave>> SavePreprocessAsync(List<DocumentForSave> docs)
        {
            var docDef = Definition();

            // Creating new entities forbidden if the definition is archived
            if (docs.Any(e => e?.Id == 0) && docDef.State == DefStates.Archived) // Insert
            {
                var msg = _localizer["Error_DefinitionIsArchived"];
                throw new BadRequestException(msg);
            }

            var settings = _settingsCache.GetCurrentSettingsIfCached().Data;
            var functionalId = settings.FunctionalCurrencyId;

            var jvDefId = _definitionsCache.GetCurrentDefinitionsIfCached()?.Data?.ManualJournalVouchersDefinitionId;
            var manualLineDefId = _definitionsCache.GetCurrentDefinitionsIfCached()?.Data?.ManualLinesDefinitionId;

            bool isJV = DefinitionId == jvDefId;

            // Set default values
            docs.ForEach(doc =>
            {
                // Set all IsCommon values that are invisible to FALSE
                if (isJV)
                {
                    // Those are always true in JV
                    doc.PostingDateIsCommon = true;
                    doc.MemoIsCommon = true;
                }
                else
                {
                    doc.MemoIsCommon ??= (docDef.MemoVisibility /* Or MemoIsCommonVisibility ? */ != null && (doc.MemoIsCommon ?? false));
                    doc.PostingDateIsCommon = docDef.PostingDateVisibility && (doc.PostingDateIsCommon ?? false);
                }


                doc.ParticipantIsCommon = docDef.ParticipantVisibility && (doc.ParticipantIsCommon ?? false);
                doc.CenterIsCommon = docDef.CenterVisibility && (doc.CenterIsCommon ?? false);
                doc.CurrencyIsCommon = docDef.CurrencyVisibility && (doc.CurrencyIsCommon ?? false);
                doc.ExternalReferenceIsCommon = docDef.ExternalReferenceVisibility && (doc.ExternalReferenceIsCommon ?? false);
                doc.AdditionalReferenceIsCommon = docDef.AdditionalReferenceVisibility && (doc.AdditionalReferenceIsCommon ?? false);

                // Defaults that make the code simpler later
                doc.Clearance ??= 0; // Public
                doc.Lines ??= new List<LineForSave>();
                doc.Attachments ??= new List<AttachmentForSave>();

                doc.Lines.ForEach(line =>
                {
                    // Line defaults
                    line.Entries ??= new List<EntryForSave>();
                    line.Boolean1 ??= false;
                });
            });

            var lineDefinitions = _definitionsCache.GetCurrentDefinitionsIfCached()?.Data?.Lines;

            // Maps every line definition Id to a bunch of delegates that check 
            var checks = new Dictionary<int, IEnumerable<Action<LineForSave>>>();

            // Set common header values on the lines
            docs.ForEach(doc =>
            {
                // All fields that aren't marked  as common, set them to
                // null, the UI makes them invisible anyways
                doc.PostingDate = doc.PostingDateIsCommon.Value ? doc.PostingDate : null;
                doc.ParticipantId = doc.ParticipantIsCommon.Value ? doc.ParticipantId : null;
                doc.CenterId = doc.CenterIsCommon.Value ? doc.CenterId : null;
                doc.CurrencyId = doc.CurrencyIsCommon.Value ? doc.CurrencyId : null;

                // System IsSystem to false by default
                doc.Lines.ForEach(line => line.Entries.ForEach(entry => entry.IsSystem ??= false));

                // For JVs some properties are always copied across to the lines
                if (isJV)
                {
                    doc.Lines.ForEach(line =>
                    {
                        line.PostingDate = doc.PostingDate;
                        line.Memo = doc.Memo;
                    });
                }

                // All fields that are marked as common, copy the common value across to the 
                // lines and entries, we deal with the lines one definitionId at a time
                foreach (var linesGroup in doc.Lines.GroupBy(e => e.DefinitionId.Value))
                {
                    if (!lineDefinitions.TryGetValue(linesGroup.Key, out LineDefinitionForClient lineDef))
                    {
                        // Validation takes care of this later on
                        continue;
                    }

                    // Silently remove entries that are out of bounds (they could be a relic from a time when the definition specified more entries)
                    doc.LineDefinitionEntries.RemoveAll(e => e.LineDefinitionId == linesGroup.Key && e.EntryIndex >= lineDef.Entries.Count);

                    var isForm = lineDef.ViewDefaultsToForm;
                    var tabEntries = new DocumentLineDefinitionEntryForSave[lineDef.Entries.Count];
                    foreach (var tabEntry in doc.LineDefinitionEntries.Where(e => e.LineDefinitionId == linesGroup.Key))
                    {
                        if (tabEntry.EntryIndex < 0)
                        {
                            continue; // Validation takes care of this later
                        }

                        if (tabEntries[tabEntry.EntryIndex.Value] != null)
                        {
                            continue; // Validation takes care of this later
                        }

                        tabEntries[tabEntry.EntryIndex.Value] = tabEntry;
                    }

                    foreach (var line in linesGroup)
                    {
                        // If the number of entries is not the same as the definition specifies, fix that
                        while (line.Entries.Count < lineDef.Entries.Count)
                        {
                            // If less, add the missing entries
                            var entryDef = lineDef.Entries[line.Entries.Count];
                            line.Entries.Add(new EntryForSave { IsSystem = false });
                        }

                        // Copy the direction from the definition
                        for (var i = 0; i < line.Entries.Count; i++)
                        {
                            if (line.DefinitionId != manualLineDefId)
                            {
                                line.Entries[i].Direction = lineDef.Entries[i].Direction;
                            }
                        }

                        #region IsCommon Behavior

                        // Copy common values from the headers if they are marked inherits from header
                        // IMPORTANT: Keep in sync with after the SQL preprocess
                        foreach (var colDef in lineDef.Columns)
                        {
                            if (colDef.ColumnName == nameof(Line.Memo))
                            {
                                if (CopyFromDocument(colDef, doc.MemoIsCommon))
                                {
                                    line.Memo = doc.Memo;
                                }
                                else
                                {
                                    var tabEntry = tabEntries.FirstOrDefault() ?? DefaultTabEntry;
                                    if (CopyFromTab(colDef, tabEntry.MemoIsCommon, isForm))
                                    {
                                        line.Memo = tabEntry.Memo;
                                    }
                                }
                            }
                            else if (colDef.ColumnName == nameof(Line.PostingDate))
                            {
                                if (CopyFromDocument(colDef, doc.PostingDateIsCommon))
                                {
                                    line.PostingDate = doc.PostingDate;
                                }
                                else
                                {
                                    var tabEntry = tabEntries.FirstOrDefault() ?? DefaultTabEntry;
                                    if (CopyFromTab(colDef, tabEntry.PostingDateIsCommon, isForm))
                                    {
                                        line.PostingDate = tabEntry.PostingDate;
                                    }
                                }
                            }
                            else
                            {
                                if (colDef.EntryIndex >= line.Entries.Count ||
                                    colDef.EntryIndex >= lineDef.Entries.Count ||
                                    colDef.EntryIndex < 0)
                                {
                                    // To avoid index out of bounds exception
                                    continue;
                                }

                                // Copy the common values
                                var entry = line.Entries[colDef.EntryIndex];
                                var tabEntry = tabEntries[colDef.EntryIndex] ?? DefaultTabEntry;

                                switch (colDef.ColumnName)
                                {
                                    case nameof(Entry.ParticipantId):
                                        if (CopyFromDocument(colDef, doc.ParticipantIsCommon))
                                        {
                                            entry.ParticipantId = doc.ParticipantId;
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.ParticipantIsCommon, isForm))
                                        {
                                            entry.ParticipantId = tabEntry.ParticipantId;
                                        }
                                        break;

                                    case nameof(Entry.CurrencyId):
                                        if (CopyFromDocument(colDef, doc.CurrencyIsCommon))
                                        {
                                            entry.CurrencyId = doc.CurrencyId;
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.CurrencyIsCommon, isForm))
                                        {
                                            entry.CurrencyId = tabEntry.CurrencyId;
                                        }
                                        break;

                                    case nameof(Entry.CustodyId):
                                        if (CopyFromTab(colDef, tabEntry.CustodyIsCommon, isForm))
                                        {
                                            entry.CustodyId = tabEntry.CustodyId;
                                        }
                                        break;

                                    case nameof(Entry.ResourceId):
                                        if (CopyFromTab(colDef, tabEntry.ResourceIsCommon, isForm))
                                        {
                                            entry.ResourceId = tabEntry.ResourceId;
                                        }
                                        break;

                                    case nameof(Entry.Quantity):
                                        if (CopyFromTab(colDef, tabEntry.QuantityIsCommon, isForm))
                                        {
                                            entry.Quantity = tabEntry.Quantity;
                                        }
                                        break;

                                    case nameof(Entry.UnitId):
                                        if (CopyFromTab(colDef, tabEntry.UnitIsCommon, isForm))
                                        {
                                            entry.UnitId = tabEntry.UnitId;
                                        }
                                        break;

                                    case nameof(Entry.CenterId):
                                        if (CopyFromDocument(colDef, doc.CenterIsCommon))
                                        {
                                            entry.CenterId = doc.CenterId;
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.CenterIsCommon, isForm))
                                        {
                                            entry.CenterId = tabEntry.CenterId;
                                        }
                                        break;

                                    case nameof(Entry.Time1):
                                        if (CopyFromTab(colDef, tabEntry.Time1IsCommon, isForm))
                                        {
                                            entry.Time1 = tabEntry.Time1;
                                        }
                                        break;

                                    case nameof(Entry.Time2):
                                        if (CopyFromTab(colDef, tabEntry.Time2IsCommon, isForm))
                                        {
                                            entry.Time2 = tabEntry.Time2;
                                        }
                                        break;

                                    case nameof(Entry.ExternalReference):
                                        if (CopyFromDocument(colDef, doc.ExternalReferenceIsCommon))
                                        {
                                            entry.ExternalReference = doc.ExternalReference;
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.ExternalReferenceIsCommon, isForm))
                                        {
                                            entry.ExternalReference = tabEntry.ExternalReference;
                                        }
                                        break;

                                    case nameof(Entry.AdditionalReference):
                                        if (CopyFromDocument(colDef, doc.AdditionalReferenceIsCommon))
                                        {
                                            entry.AdditionalReference = doc.AdditionalReference;
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.AdditionalReferenceIsCommon, isForm))
                                        {
                                            entry.AdditionalReference = tabEntry.AdditionalReference;
                                        }
                                        break;
                                }
                            }
                        }

                        #endregion
                    }
                }
            });

            // SQL server preprocessing
            await _repo.Documents__Preprocess(DefinitionId.Value, docs);

            var tabEntryDesc = Entities.Descriptors.TypeDescriptor.Get<DocumentLineDefinitionEntryForSave>();

            // C# Processing after SQL
            docs.ForEach(doc =>
            {
                // Remove empty tab entries
                doc.LineDefinitionEntries?.RemoveAll(EqualsDefaultTabEntry);

                // Lines preprocessing
                doc.Lines.ForEach(line =>
                {
                    line.Entries.ForEach(entry =>
                    {
                        // If currency is functional, make sure that Value = MonetaryValue
                        if (entry.CurrencyId == settings.FunctionalCurrencyId)
                        {
                            if (line.DefinitionId == manualLineDefId)
                            {
                                // Manual lines, the value is always entered by the user
                                entry.MonetaryValue = entry.Value;
                            }
                            else
                            {
                                // Smart lines, the monetary value is always entered by the user
                                entry.Value = entry.MonetaryValue;
                            }
                        }

                        // Other logic
                    });
                });

                ////// handle subtle exchange rate rounding bugs. IF...
                // (1) All non-manual entries have the same non-functional currency
                // (2) Monetary Value of non-manual entries is balanced
                // (3) Value of non-manual is not balanced
                // => Take the difference and distribute it evenly on the entries
                if (doc.Lines.Count > 0)
                {
                    var smartEntries = doc.Lines.Where(line => line.DefinitionId != manualLineDefId).SelectMany(line => line.Entries);
                    if (smartEntries.Any())
                    {
                        var currencyId = smartEntries.First().CurrencyId;
                        if (currencyId != functionalId &&
                            smartEntries.All(entry => entry.CurrencyId == currencyId) &&
                            smartEntries.Sum(entry => entry.Direction.Value * (entry.MonetaryValue ?? 0)) == 0)
                        {
                            var valueDifference = smartEntries.Sum(entry => entry.Direction.Value * (entry.MonetaryValue ?? 0));
                            if (valueDifference != 0)
                            {
                                //// This variable will equal the smallest amount that can be represented
                                //// in the functional currency. E.g. for USD it's 0.01
                                //decimal adjustment = 1.0m;
                                //for (byte i = 0; i < settings.FunctionalCurrencyDecimals; i++)
                                //{
                                //    adjustment *= 0.1m;
                                //}

                                //// TODO: 
                                //smartEntries.First().Value += adjustment;
                            }
                        }
                    }
                }
            });

            #region IsCommon Double Check

            // Ensure IsCommon is still honored
            // IMPORTANT: Keep in sync with part before the SQL preprocess
            docs.ForEach(doc =>
            {
                // All fields that are marked as common, copy the common value across to the 
                // lines and entries, we deal with the lines one definitionId at a time
                foreach (var linesGroup in doc.Lines.GroupBy(e => e.DefinitionId.Value))
                {
                    if (!lineDefinitions.TryGetValue(linesGroup.Key, out LineDefinitionForClient lineDef))
                    {
                        // Validation takes care of this later on
                        continue;
                    }

                    var isForm = lineDef.ViewDefaultsToForm;
                    var tabEntries = new DocumentLineDefinitionEntryForSave[lineDef.Entries.Count];
                    foreach (var tabEntry in doc.LineDefinitionEntries.Where(e => e.LineDefinitionId == linesGroup.Key))
                    {
                        if (tabEntry.EntryIndex < 0)
                        {
                            continue; // Validation takes care of this later
                        }

                        if (tabEntries[tabEntry.EntryIndex.Value] != null)
                        {
                            continue; // Validation takes care of this later
                        }

                        tabEntries[tabEntry.EntryIndex.Value] = tabEntry;
                    }

                    foreach (var line in linesGroup)
                    {
                        // Copy common values from the headers if they are marked inherits from header
                        foreach (var colDef in lineDef.Columns)
                        {
                            if (colDef.ColumnName == nameof(Line.Memo))
                            {
                                if (CopyFromDocument(colDef, doc.MemoIsCommon))
                                {
                                    if (line.Memo != doc.Memo)
                                    {
                                        throw new InvalidOperationException($"[Bug] {nameof(doc.MemoIsCommon)}=true, but {nameof(line.Memo)} of line of type {lineDef.TitleSingular} was changed in preprocess from '{doc.Memo}' to '{line.Memo}'");
                                    }
                                }
                                else
                                {
                                    var tabEntry = tabEntries.FirstOrDefault() ?? DefaultTabEntry;
                                    if (CopyFromTab(colDef, tabEntry.MemoIsCommon, isForm))
                                    {
                                        if (line.Memo != tabEntry.Memo)
                                        {
                                            throw new InvalidOperationException($"[Bug] {nameof(tabEntry.MemoIsCommon)}=true, but {nameof(line.Memo)} of line of type {lineDef.TitleSingular} was changed in preprocess from '{tabEntry.Memo}' to '{line.Memo}'");
                                        }
                                    }
                                }
                            }
                            else if (colDef.ColumnName == nameof(Line.PostingDate))
                            {
                                if (CopyFromDocument(colDef, doc.PostingDateIsCommon))
                                {
                                    line.PostingDate = doc.PostingDate;
                                    if (line.PostingDate != doc.PostingDate)
                                    {
                                        throw new InvalidOperationException($"[Bug] {nameof(doc.PostingDateIsCommon)}=true, but {nameof(line.PostingDate)} of line of type {lineDef.TitleSingular} was changed in preprocess from {doc.PostingDate:yyyy-MM-dd} to '{line.PostingDate:yyyy-MM-dd}'");
                                    }
                                }
                                else
                                {
                                    var tabEntry = tabEntries.FirstOrDefault() ?? DefaultTabEntry;
                                    if (CopyFromTab(colDef, tabEntry.PostingDateIsCommon, isForm))
                                    {
                                        if (line.PostingDate != tabEntry.PostingDate)
                                        {
                                            throw new InvalidOperationException($"[Bug] {nameof(tabEntry.PostingDateIsCommon)}=true, but {nameof(line.PostingDate)} of line of type {lineDef.TitleSingular} was changed in preprocess from {doc.PostingDate:yyyy-MM-dd} to '{line.PostingDate:yyyy-MM-dd}'");
                                        }
                                    }
                                }
                            }
                            else
                            {
                                if (colDef.EntryIndex >= line.Entries.Count ||
                                    colDef.EntryIndex >= lineDef.Entries.Count ||
                                    colDef.EntryIndex < 0)
                                {
                                    // To avoid index out of bounds exception
                                    continue;
                                }

                                // Copy the common values
                                var entry = line.Entries[colDef.EntryIndex];
                                var tabEntry = tabEntries[colDef.EntryIndex] ?? DefaultTabEntry;

                                switch (colDef.ColumnName)
                                {
                                    case nameof(Entry.ParticipantId):
                                        if (CopyFromDocument(colDef, doc.ParticipantIsCommon))
                                        {
                                            if (entry.ParticipantId != doc.ParticipantId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.ParticipantId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {doc.ParticipantId} to {entry.ParticipantId}");
                                            }
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.ParticipantIsCommon, isForm))
                                        {
                                            if (entry.ParticipantId != tabEntry.ParticipantId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.ParticipantId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.ParticipantId} to {entry.ParticipantId}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.CurrencyId):
                                        if (CopyFromDocument(colDef, doc.CurrencyIsCommon))
                                        {
                                            if (entry.CurrencyId != doc.CurrencyId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.CurrencyId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {doc.CurrencyId} to {entry.CurrencyId}");
                                            }
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.CurrencyIsCommon, isForm))
                                        {
                                            if (entry.CurrencyId != tabEntry.CurrencyId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.CurrencyId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.CurrencyId} to {entry.CurrencyId}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.CustodyId):
                                        if (CopyFromTab(colDef, tabEntry.CustodyIsCommon, isForm))
                                        {
                                            entry.CustodyId = tabEntry.CustodyId;
                                        }
                                        break;

                                    case nameof(Entry.ResourceId):
                                        if (CopyFromTab(colDef, tabEntry.ResourceIsCommon, isForm))
                                        {
                                            entry.ResourceId = tabEntry.ResourceId;
                                            if (entry.ResourceId != tabEntry.ResourceId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.ResourceId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.ResourceId} to {entry.ResourceId}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.Quantity):
                                        if (CopyFromTab(colDef, tabEntry.QuantityIsCommon, isForm))
                                        {
                                            if (tabEntry.Quantity != entry.Quantity)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.Quantity)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.Quantity} to {entry.Quantity}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.UnitId):
                                        if (CopyFromTab(colDef, tabEntry.UnitIsCommon, isForm))
                                        {
                                            if (tabEntry.UnitId != entry.UnitId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.UnitId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.UnitId} to {entry.UnitId}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.CenterId):
                                        if (CopyFromDocument(colDef, doc.CenterIsCommon))
                                        {
                                            if (entry.CenterId != doc.CenterId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.CenterId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {doc.CenterId} to {entry.CenterId}");
                                            }
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.CenterIsCommon, isForm))
                                        {
                                            if (entry.CenterId != tabEntry.CenterId)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.CenterId)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.CenterId} to {entry.CenterId}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.Time1):
                                        if (CopyFromTab(colDef, tabEntry.Time1IsCommon, isForm))
                                        {
                                            if (entry.Time1 != tabEntry.Time1)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.Time1)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.Time1} to {entry.Time1}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.Time2):
                                        if (CopyFromTab(colDef, tabEntry.Time2IsCommon, isForm))
                                        {
                                            if (entry.Time2 != tabEntry.Time2)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.Time2)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.Time2} to {entry.Time2}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.ExternalReference):
                                        if (CopyFromDocument(colDef, doc.ExternalReferenceIsCommon))
                                        {
                                            if (entry.ExternalReference != doc.ExternalReference)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.ExternalReference)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {doc.ExternalReference} to {entry.ExternalReference}");
                                            }
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.ExternalReferenceIsCommon, isForm))
                                        {
                                            if (entry.ExternalReference != tabEntry.ExternalReference)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.ExternalReference)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.ExternalReference} to {entry.ExternalReference}");
                                            }
                                        }
                                        break;

                                    case nameof(Entry.AdditionalReference):
                                        if (CopyFromDocument(colDef, doc.AdditionalReferenceIsCommon))
                                        {
                                            if (entry.AdditionalReference != doc.AdditionalReference)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.AdditionalReference)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {doc.AdditionalReference} to {entry.AdditionalReference}");
                                            }
                                        }
                                        else if (CopyFromTab(colDef, tabEntry.AdditionalReferenceIsCommon, isForm))
                                        {
                                            if (entry.AdditionalReference != tabEntry.AdditionalReference)
                                            {
                                                throw new InvalidOperationException($"[Bug] IsCommon = true, but {nameof(entry.AdditionalReference)} of EntryIndex = {colDef.EntryIndex} of line of type {lineDef.TitleSingular} was changed in preprocess from {tabEntry.AdditionalReference} to {entry.AdditionalReference}");
                                            }
                                        }
                                        break;
                                }
                            }
                        }
                    }
                }
            });

            #endregion

            return docs;
        }

        // Helper function #1
        private static bool CopyFromDocument(LineDefinitionColumnForClient colDef, bool? docIsCommon)
        {
            return colDef.InheritsFromHeader >= InheritsFrom.DocumentHeader && (docIsCommon ?? false);
        }

        // Helper function #2 (Works in conjunction with helper func #1)
        static bool CopyFromTab(LineDefinitionColumnForClient colDef, bool? tabIsCommon, bool isForm)
        {
            return !isForm && colDef.InheritsFromHeader >= InheritsFrom.TabHeader && (tabIsCommon ?? false);
        }

        protected override async Task SaveValidateAsync(List<DocumentForSave> docs)
        {
            // Find lines with duplicate Ids
            var duplicateLineIds = docs.SelectMany(doc => doc.Lines) // All lines
                .Where(line => line.Id != 0).GroupBy(line => line.Id).Where(g => g.Count() > 1) // Duplicate Ids
                .SelectMany(g => g).ToDictionary(line => line, line => line.Id); // to dictionary

            // Find entries with duplicate Ids
            var duplicateEntryIds = docs.SelectMany(doc => doc.Lines).SelectMany(line => line.Entries)
                .Where(entry => entry.Id != 0).GroupBy(entry => entry.Id).Where(g => g.Count() > 1)
                .SelectMany(g => g).ToDictionary(entry => entry, entry => entry.Id);

            // Find documents with duplicate Serial numbers
            var duplicateSerialNumbers = docs.Where(doc => doc.SerialNumber > 0)
                .GroupBy(doc => doc.SerialNumber).Where(g => g.Count() > 1).SelectMany(g => g)
                .ToDictionary(doc => doc, doc => doc.SerialNumber.Value);

            var settings = _settingsCache.GetCurrentSettingsIfCached().Data;
            var docDef = Definition();
            var meta = GetMetadataForSave();
            var defs = _definitionsCache.GetCurrentDefinitionsIfCached()?.Data;
            var lineDefs = defs?.Lines;
            var manualLineDefId = defs?.ManualLinesDefinitionId;

            ///////// Document Validation
            for (int docIndex = 0; docIndex < docs.Count; docIndex++)
            {
                var doc = docs[docIndex];

                if (!docDef.IsOriginalDocument)
                {
                    // If not an original document, the serial number is required
                    if (doc.SerialNumber == null || doc.SerialNumber == 0)
                    {
                        ModelState.AddModelError($"[{docIndex}].{nameof(doc.SerialNumber)}",
                            _localizer[Constants.Error_Field0IsRequired, _localizer["Document_SerialNumber"]]);
                    }
                    else if (duplicateSerialNumbers.ContainsKey(doc))
                    {
                        var serial = duplicateSerialNumbers[doc];
                        ModelState.AddModelError($"[{docIndex}].{nameof(doc.SerialNumber)}",
                            _localizer["Error_TheSerialNumber0IsDuplicated", FormatSerial(serial, docDef.Prefix, docDef.CodeWidth)]);
                    }
                }

                if (doc.PostingDateIsCommon.Value && doc.PostingDate != null)
                {
                    // Date cannot be in the future
                    if (doc.PostingDate > DateTime.Today.AddDays(1))
                    {
                        ModelState.AddModelError($"[{docIndex}].{nameof(doc.PostingDate)}",
                            _localizer["Error_DateCannotBeInTheFuture"]);
                    }

                    // Date cannot be before archive date
                    if (doc.PostingDate <= settings.ArchiveDate && docDef.DocumentType >= 2)
                    {
                        var archiveDate = settings.ArchiveDate.ToString("yyyy-MM-dd");
                        ModelState.AddModelError($"[{docIndex}].{nameof(doc.PostingDate)}",
                            _localizer["Error_DateCannotBeBeforeArchiveDate1", archiveDate]);
                    }
                }

                ////////// LineDefinitionEntries Validation
                if (doc.LineDefinitionEntries != null)
                {
                    // Remove duplicates
                    var duplicateTabEntries = doc.LineDefinitionEntries
                        .GroupBy(e => (e.LineDefinitionId, e.EntryIndex))
                        .Where(g => g.Count() > 1)
                        .SelectMany(g => g)
                        .ToHashSet();

                    // Make sure EntryIndex is not below 0
                    for (int tabEntryIndex = 0; tabEntryIndex < doc.LineDefinitionEntries.Count; tabEntryIndex++)
                    {
                        var tabEntry = doc.LineDefinitionEntries[tabEntryIndex];
                        if (tabEntry.EntryIndex < 0)
                        {
                            var path = $"[{docIndex}].{nameof(doc.LineDefinitionEntries)}[{tabEntryIndex}].{nameof(tabEntry.EntryIndex)}";
                            var msg = "Entry index cannot be negative";
                            ModelState.AddModelError(path, msg);
                        }

                        if (duplicateTabEntries.Contains(tabEntry))
                        {
                            var path = $"[{docIndex}].{nameof(doc.LineDefinitionEntries)}[{tabEntryIndex}].{nameof(tabEntry.EntryIndex)}";
                            var msg = $"Entry index {tabEntry.EntryIndex} is duplicated for the same LineDefinitionId '{tabEntry.LineDefinitionId}'";
                            ModelState.AddModelError(path, msg);
                        }
                    }
                }

                ///////// Line Validation
                for (int lineIndex = 0; lineIndex < doc.Lines.Count; lineIndex++)
                {
                    var line = doc.Lines[lineIndex];

                    if (!lineDefs.TryGetValue(line.DefinitionId.Value, out LineDefinitionForClient lineDef))// We checked earlier if this is null
                    {
                        ModelState.AddModelError(LinePath(docIndex, lineIndex, nameof(Line.DefinitionId)),
                            _localizer["Error_UnknownLineDefinitionId0", line.DefinitionId]);

                        continue;
                    }

                    // Prevent duplicate line Ids
                    if (duplicateLineIds.ContainsKey(line))
                    {
                        // This error indicates a bug
                        var id = duplicateLineIds[line];
                        ModelState.AddModelError(LinePath(docIndex, lineIndex, nameof(Line.Id)),
                            _localizer["Error_TheEntityWithId0IsSpecifiedMoreThanOnce", id]);
                    }

                    if (!doc.PostingDateIsCommon.Value && line.PostingDate != null)
                    {
                        // Date cannot be in the future
                        if (line.PostingDate > DateTime.Today.AddDays(1))
                        {
                            ModelState.AddModelError(LinePath(docIndex, lineIndex, nameof(Line.PostingDate)),
                                _localizer["Error_DateCannotBeInTheFuture"]);
                        }

                        // Date cannot be before archive date
                        if (line.PostingDate <= settings.ArchiveDate && docDef.DocumentType >= 2)
                        {
                            var archiveDate = settings.ArchiveDate.ToString("yyyy-MM-dd");
                            ModelState.AddModelError(LinePath(docIndex, lineIndex, nameof(Line.PostingDate)),
                                _localizer["Error_DateCannotBeBeforeArchiveDate1", archiveDate]);
                        }
                    }

                    ///////// Entry Validation
                    for (int entryIndex = 0; entryIndex < line.Entries.Count; entryIndex++)
                    {
                        var entry = line.Entries[entryIndex];
                        // Prevent duplicate entry Ids
                        if (duplicateEntryIds.ContainsKey(entry))
                        {
                            var id = duplicateEntryIds[entry];
                            ModelState.AddModelError(EntryPath(docIndex, lineIndex, entryIndex, nameof(Entry.Id)),
                                _localizer["Error_TheEntityWithId0IsSpecifiedMoreThanOnce", id]);
                        }

                        // Value must be positive
                        if (entry.Value < 0)
                        {
                            string fieldLabel = null;
                            if (line.DefinitionId == manualLineDefId)
                            {
                                fieldLabel = entry.Direction == -1 ? _localizer["Credit"] : _localizer["Debit"];
                            }
                            else
                            {
                                var columnDef = lineDef.Columns.FirstOrDefault(e => e.EntryIndex == entryIndex && e.ColumnName == nameof(Entry.Value));
                                if (columnDef != null)
                                {
                                    fieldLabel = settings.Localize(columnDef.Label, columnDef.Label2, columnDef.Label3);
                                }
                            }

                            if (fieldLabel != null)
                            {
                                ModelState.AddModelError(EntryPath(docIndex, lineIndex, entryIndex, nameof(Entry.Value)),
                                    _localizer["Error_TheField0CannotBeNegative", fieldLabel]);
                            }
                        }

                        // MonetaryValue must be positive
                        if (entry.MonetaryValue < 0)
                        {
                            string fieldLabel = null;
                            if (line.DefinitionId == manualLineDefId)
                            {
                                fieldLabel = _localizer["Entry_MonetaryValue"];
                            }
                            else
                            {
                                var columnDef = lineDef.Columns.FirstOrDefault(e => e.EntryIndex == entryIndex && e.ColumnName == nameof(Entry.MonetaryValue));
                                if (columnDef != null)
                                {
                                    fieldLabel = settings.Localize(columnDef.Label, columnDef.Label2, columnDef.Label3);
                                }
                            }

                            if (fieldLabel != null)
                            {
                                ModelState.AddModelError(EntryPath(docIndex, lineIndex, entryIndex, nameof(Entry.MonetaryValue)),
                                    _localizer["Error_TheField0CannotBeNegative", fieldLabel]);
                            }
                        }

                        // Quantity must be positive
                        if (entry.Quantity < 0)
                        {
                            string fieldLabel = null;
                            if (line.DefinitionId == manualLineDefId)
                            {
                                fieldLabel = _localizer["Entry_Quantity"];
                            }
                            else
                            {
                                var columnDef = lineDef.Columns.FirstOrDefault(e => e.EntryIndex == entryIndex && e.ColumnName == nameof(Entry.Quantity));
                                if (columnDef != null)
                                {
                                    fieldLabel = settings.Localize(columnDef.Label, columnDef.Label2, columnDef.Label3);
                                }
                            }

                            if (fieldLabel != null)
                            {
                                ModelState.AddModelError(EntryPath(docIndex, lineIndex, entryIndex, nameof(Entry.Quantity)),
                                    _localizer["Error_TheField0CannotBeNegative", fieldLabel]);
                            }
                        }

                        // If the currency is functional, value must equal monetary value
                        if (entry.CurrencyId == settings.FunctionalCurrencyId && entry.Value != entry.MonetaryValue)
                        {
                            var currencyName = settings
                                .Localize(settings.FunctionalCurrencyName,
                                            settings.FunctionalCurrencyName2,
                                            settings.FunctionalCurrencyName3);

                            // TODO: Use the proper field name from definition, instead of "Amount"
                            ModelState.AddModelError(EntryPath(docIndex, lineIndex, entryIndex, nameof(Entry.MonetaryValue)),
                                _localizer["TheAmount0DoesNotMatchTheValue1EvenThoughBothIn2", entry.MonetaryValue ?? 0, entry.Value ?? 0, currencyName]);
                        }

                        if (ModelState.HasReachedMaxErrors)
                        {
                            break;
                        }
                    }

                    if (ModelState.HasReachedMaxErrors)
                    {
                        break;
                    }
                }

                if (ModelState.HasReachedMaxErrors)
                {
                    break;
                }

                ///////// Attachment Validation
                for (var attIndex = 0; attIndex < doc.Attachments.Count; attIndex++)
                {
                    var att = doc.Attachments[attIndex];

                    if (att.Id != 0 && att.File != null)
                    {
                        ModelState.AddModelError($"[{docIndex}].{nameof(doc.Attachments)}[{attIndex}]",
                            _localizer["Error_OnlyNewAttachmentsCanIncludeFileBytes"]);
                    }

                    if (att.Id == 0 && att.File == null)
                    {
                        ModelState.AddModelError($"[{docIndex}].{nameof(doc.Attachments)}[{attIndex}]",
                            _localizer["Error_NewAttachmentsMustIncludeFileBytes"]);
                    }

                    if (ModelState.HasReachedMaxErrors)
                    {
                        break;
                    }
                }

                if (ModelState.HasReachedMaxErrors)
                {
                    break;
                }
            }

            // No need to invoke SQL if the model state is full of errors
            if (ModelState.HasReachedMaxErrors)
            {
                return;
            }

            // SQL validation
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var sqlErrors = await _repo.Documents_Validate__Save(DefinitionId.Value, docs, top: remainingErrorCount);

            // Add errors to model state
            ModelState.AddLocalizedErrors(sqlErrors, _localizer);
        }

        private void AddReadOnlyError(int docIndex, string propName)
        {
            if (ModelState.HasReachedMaxErrors)
            {
                return;
            }

            var key = $"[{docIndex}].{propName}";
            if (!ModelState.ContainsKey(key))
            {
                var meta = GetMetadataForSave();
                var propDisplayName = meta.Property(propName)?.Display();
                ModelState.AddModelError(key, _localizer["Error_TheField0IsReadOnly", propDisplayName]);
            }
        }

        private string FormatSerial(int serial, string prefix, int codeWidth)
        {
            var result = serial.ToString();
            if (result.Length < codeWidth)
            {
                result = "00000000000000000".Substring(0, codeWidth - result.Length) + result;
            }

            if (!string.IsNullOrWhiteSpace(prefix))
            {
                result = prefix + result;
            }

            return result;
        }

        private string EntryPath(int docIndex, int lineIndex, int entryIndex, string propName)
        {
            return $"[{docIndex}].{nameof(Document.Lines)}[{lineIndex}].{nameof(Line.Entries)}[{entryIndex}].{propName}";
        }

        private string LinePath(int docIndex, int lineIndex, string propName)
        {
            return $"[{docIndex}].{nameof(Document.Lines)}[{lineIndex}].{propName}";
        }

        protected override async Task<List<int>> SaveExecuteAsync(List<DocumentForSave> entities, bool returnIds)
        {
            _blobsToSave = new List<(string, byte[])>();

            // Prepare the list of attachments with extras
            var attachments = new List<AttachmentWithExtras>();
            foreach (var (doc, docIndex) in entities.Select((d, i) => (d, i)))
            {
                if (doc.Attachments != null)
                {
                    doc.Attachments.ForEach(att =>
                    {
                        var attWithExtras = new AttachmentWithExtras
                        {
                            Id = att.Id,
                            FileName = att.FileName,
                            FileExtension = att.FileExtension,
                            DocumentIndex = docIndex,
                        };

                        // If new attachment 
                        if (att.Id == 0)
                        {
                            // Add extras: file Id and size
                            byte[] file = att.File;
                            string fileId = Guid.NewGuid().ToString();
                            attWithExtras.FileId = fileId;
                            attWithExtras.Size = file.LongLength;

                            // Also add to blobsToCreate
                            string blobName = BlobName(fileId);
                            _blobsToSave.Add((blobName, file));
                        }

                        attachments.Add(attWithExtras);
                    });
                }
            }

            // Save the documents
            var (notificationInfos, fileIdsToDelete, ids) = await _repo.Documents__SaveAndRefresh(
                DefinitionId.Value,
                documents: entities,
                attachments: attachments,
                returnIds: returnIds);

            _notificationInfos = notificationInfos;
            _fileIdsToDelete = fileIdsToDelete;

            // Return the new Ids
            return ids;
        }

        protected override async Task NonTransactionalSideEffectsForSave(List<DocumentForSave> entities, List<Document> data)
        {
            var block = _instrumentation.Block("hub.Notify");

            // Notify affected users
            await _hubContext.NotifyInboxAsync(TenantId, _notificationInfos);

            block.Dispose();

            // Delete the file Ids retrieved earlier if any
            if (_fileIdsToDelete.Any())
            {
                var blobsToDelete = _fileIdsToDelete.Select(fileId => BlobName(fileId));
                await _blobService.DeleteBlobsAsync(blobsToDelete);
            }

            // Save new blobs if any
            if (_blobsToSave.Any())
            {
                await _blobService.SaveBlobsAsync(_blobsToSave);
            }
        }

        protected override async Task DeleteValidateAsync(List<int> ids)
        {
            // SQL validation
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var sqlErrors = await _repo.Documents_Validate__Delete(DefinitionId.Value, ids, top: remainingErrorCount);

            // Add errors to model state
            ModelState.AddLocalizedErrors(sqlErrors, _localizer);
        }

        protected override async Task DeleteExecuteAsync(List<int> ids)
        {
            try
            {
                var (notificationInfos, fileIdsToDelete) = await _repo.Documents__Delete(ids);

                await _hubContext.NotifyInboxAsync(TenantId, notificationInfos);

                // Delete the file Ids retrieved earlier if any
                if (fileIdsToDelete.Any())
                {
                    var blobsToDelete = fileIdsToDelete.Select(fileId => BlobName(fileId));
                    await _blobService.DeleteBlobsAsync(blobsToDelete);
                }
            }
            catch (ForeignKeyViolationException)
            {
                var definition = Definition();
                var tenantInfo = await _repo.GetTenantInfoAsync(cancellation: default);
                var titleSingular = tenantInfo.Localize(definition.TitleSingular, definition.TitleSingular2, definition.TitleSingular3);

                throw new BadRequestException(_localizer["Error_CannotDelete0AlreadyInUse", titleSingular]);
            }
        }

        protected override OrderByExpression DefaultOrderBy()
        {
            return OrderByExpression.Parse($"{nameof(Document.SerialNumber)} desc");
        }

        private string BlobName(string guid)
        {
            return $"{TenantId}/Attachments/{guid}";
        }

        public DocumentsService SetIncludeRequiredSignatures(bool val)
        {
            _includeRequiredSignaturesOverride = val;
            return this;
        }

        public DocumentsService SetDefinitionId(int definitionId)
        {
            _definitionIdOverride = definitionId;
            return this;
        }

        protected override MappingInfo ProcessDefaultMapping(MappingInfo mapping)
        {
            // Remove the attachments, since they cannot be imported in a CSV
            var attachments = mapping.CollectionProperty(nameof(DocumentForSave.Attachments));
            mapping.CollectionProperties = mapping.CollectionProperties.Where(p => p != attachments);

            // Remove the LineTemplateId and Multiplier
            var lines = mapping.CollectionProperty(nameof(Document.Lines));
            var lineTemplateId = lines.SimpleProperty(nameof(LineForSave.TemplateLineId));
            var multiplier = lines.SimpleProperty(nameof(LineForSave.Multiplier));
            lines.SimpleProperties = lines.SimpleProperties.Where(p => p != lineTemplateId && p != multiplier);

            // Fix the newly created gaps, if any
            mapping.NormalizeIndices();

            return base.ProcessDefaultMapping(mapping);
        }

        protected override SelectExpression ParseSelect(string select)
        {
            // We provide a shorthand notation for common and huge select
            // strings, this one is usually requested from the document details
            // screen and it contains over 260 atoms
            var shorthand = "$Details";
            if (select == null)
            {
                return null;
            }
            else if (select.Trim() == shorthand)
            {
                return _detailsSelectExpression;
            }
            else
            {
                select = select.Replace(shorthand, _detailsSelect);
                return base.ParseSelect(select);
            }
        }

        private static readonly string _detailsSelect = string.Join(',', DocDetails.DocumentPaths());
        private static readonly SelectExpression _detailsSelectExpression = new SelectExpression(DocDetails.DocumentPaths().Select(a => SelectAtom.Parse(a)));

    }

    [Route("api/" + DocumentsController.BASE_ADDRESS)]
    [ApplicationController]
    public class DocumentsGenericController : FactWithIdControllerBase<Document, int>
    {
        private readonly DocumentsGenericService _service;

        public DocumentsGenericController(DocumentsGenericService service, IServiceProvider sp) : base(sp)
        {
            _service = service;
        }

        protected override FactWithIdServiceBase<Document, int> GetFactWithIdService()
        {
            return _service;
        }
    }

    public class DocumentsGenericService : FactWithIdServiceBase<Document, int>
    {
        private readonly ApplicationRepository _repo;
        private readonly IDefinitionsCache _definitionsCache;

        public DocumentsGenericService(
            ApplicationRepository repo,
            IDefinitionsCache definitionsCache,
            IServiceProvider sp) : base(sp)
        {
            _repo = repo;
            _definitionsCache = definitionsCache;
        }

        protected override IRepository GetRepository()
        {
            return _repo;
        }

        protected override async Task<IEnumerable<AbstractPermission>> UserPermissions(string action, CancellationToken cancellation)
        {
            // Get all permissions pertaining to documents
            string prefix = DocumentsController.BASE_ADDRESS;
            var permissions = (await _repo.GenericPermissionsFromCache(prefix, action, cancellation)).ToList();

            // Massage the permissions by adding definitionId = definitionId as an extra clause 
            // (since the controller will not filter the results per any specific definition Id)
            foreach (var permission in permissions.Where(e => e.View != "all"))
            {
                string definitionIdString = permission.View.Remove(0, prefix.Length).Replace("'", "''");
                if (!int.TryParse(definitionIdString, out int definitionId))
                {
                    throw new BadRequestException($"Could not parse definition Id {definitionIdString} to a valid integer");
                }

                string definitionPredicate = $"{nameof(Document.DefinitionId)} {Ops.eq} {definitionId}";
                if (!string.IsNullOrWhiteSpace(permission.Criteria))
                {
                    permission.Criteria = $"{definitionPredicate} and ({permission.Criteria})";
                }
                else
                {
                    permission.Criteria = definitionPredicate;
                }
            }

            // Add a special permission that lets you see the documents that were assigned to you
            permissions.AddRange(DocumentServiceUtil.HardCodedPermissions(action));

            // Return the massaged permissions
            return permissions;
        }

        protected override Query<Document> Search(Query<Document> query, GetArguments args)
        {
            // Get a map from all serial prefixes to definitionIds
            var prefixMap = _definitionsCache.GetCurrentDefinitionsIfCached()?
                .Data?.Documents? // Get document definitions for client from the cache
                .Select(e => (e.Value.Prefix, e.Key)) ?? // Select all (Prefix, DefinitionId)
                new List<(string, int)>(); // Avoiding null reference exception at all cost

            return DocumentServiceUtil.SearchImpl(query, args, prefixMap);
        }

        protected override OrderByExpression DefaultOrderBy()
        {
            return OrderByExpression.Parse($"{nameof(Document.PostingDate)} desc");
        }
    }

    internal class DocumentServiceUtil
    {
        /// <summary>
        /// This is needed in both the generic and specific controllers, so we move it out here
        /// </summary>
        internal static Query<Document> SearchImpl(Query<Document> query, GetArguments args, IEnumerable<(string Prefix, int DefinitionId)> prefixMap)
        {
            string search = args.Search;
            if (!string.IsNullOrWhiteSpace(search))
            {
                // IF: the search starts with the serial prefix (case insensitive) then search the serial numbers exclusively 
                var searchLower = search.Trim().ToLower();
                var (prefix, definitionId) = prefixMap.FirstOrDefault(e =>
                    !string.IsNullOrWhiteSpace(e.Prefix) &&
                    searchLower.StartsWith(e.Prefix.ToLower()) &&
                    searchLower.Length > e.Prefix.Length);

                if (definitionId != 0 && int.TryParse(searchLower.Remove(0, prefix.Length), out int serial))
                {
                    var serialNumberProp = nameof(Document.SerialNumber);
                    var definitionIdProp = nameof(Document.DefinitionId);

                    // Prepare the filter string
                    var filterString = $"{serialNumberProp} {Ops.eq} {serial} and {definitionIdProp} {Ops.eq} {definitionId}";

                    // Apply the filter
                    query = query.Filter(filterString);
                }

                // ELSE: search the memo, posting date, etc normally
                else
                {
                    search = search.Replace("'", "''"); // escape quotes by repeating them

                    var memoProp = nameof(Document.Memo);
                    var serialNumberProp = nameof(Document.SerialNumber);
                    var postingDateProp = nameof(Document.PostingDate);

                    // Prepare the filter string
                    var filterString = $"{memoProp} {Ops.contains} '{search}'";

                    // If the search is a number, include documents with that serial number
                    if (int.TryParse(search.Trim(), out int searchNumber))
                    {
                        filterString = $"{filterString} or {serialNumberProp} {Ops.eq} {searchNumber}";
                    }

                    // If the search is a date, include documents with that date
                    if (DateTime.TryParse(search.Trim(), out DateTime searchDate))
                    {
                        filterString = $"{filterString} or {postingDateProp} {Ops.eq} {searchDate:yyyy-MM-dd}";
                    }

                    // Apply the filter
                    query = query.Filter(FilterExpression.Parse(filterString));
                }
            }

            return query;
        }

        internal static IEnumerable<AbstractPermission> HardCodedPermissions(string action)
        {
            if (action == Constants.Read)
            {
                // If someone assigns the document to you, you can read it
                // and forward it to someone else, until it either gets
                // forwarded again (the second condition so that you can 
                // refresh the document immediately after forwarding)
                yield return new AbstractPermission
                {
                    View = "documents", // Not important
                    Action = Constants.Read,
                    Criteria = "AssigneeId eq me OR AssignedById eq me"
                };
            }
        }
    }
}