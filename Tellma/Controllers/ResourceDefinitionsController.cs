﻿using Tellma.Controllers.Dto;
using Tellma.Controllers.Utilities;
using Tellma.Data;
using Tellma.Data.Queries;
using Tellma.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Threading;
using System;
using Tellma.Services.Utilities;
using System.Linq;

namespace Tellma.Controllers
{
    [Route("api/" + BASE_ADDRESS)]
    [ApplicationController]
    public class ResourceDefinitionsController : CrudControllerBase<ResourceDefinitionForSave, ResourceDefinition, int>
    {
        public const string BASE_ADDRESS = "resource-definitions";

        private readonly ResourceDefinitionsService _service;

        public ResourceDefinitionsController(ResourceDefinitionsService service, IServiceProvider sp) : base(sp)
        {
            _service = service;
        }

        [HttpPut("update-state")]
        public async Task<ActionResult<EntitiesResponse<Document>>> Close([FromBody] List<int> ids, [FromQuery] UpdateStateArguments args)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var serverTime = DateTimeOffset.UtcNow;
                var (data, extras) = await _service.UpdateState(ids, args);
                var response = TransformToEntitiesResponse(data, extras, serverTime, cancellation: default);

                Response.Headers.Set("x-definitions-version", Constants.Stale);
                if (args.ReturnEntities ?? false)
                {
                    return Ok(response);
                }
                else
                {
                    return Ok();
                }
            }, 
            _logger);
        }

        protected override CrudServiceBase<ResourceDefinitionForSave, ResourceDefinition, int> GetCrudService()
        {
            return _service;
        }

        protected override Task OnSuccessfulSave(List<ResourceDefinition> data, Extras extras)
        {
            Response.Headers.Set("x-definitions-version", Constants.Stale);
            return base.OnSuccessfulSave(data, extras);
        }

        protected override Task OnSuccessfulDelete(List<int> ids)
        {
            Response.Headers.Set("x-definitions-version", Constants.Stale);
            return base.OnSuccessfulDelete(ids);
        }
    }

    public class ResourceDefinitionsService : CrudServiceBase<ResourceDefinitionForSave, ResourceDefinition, int>
    {
        private readonly ApplicationRepository _repo;

        private string View => ResourceDefinitionsController.BASE_ADDRESS;

        public ResourceDefinitionsService(ApplicationRepository repo, IServiceProvider sp) : base(sp)
        {
            _repo = repo;
        }

        public async Task<(List<ResourceDefinition>, Extras)> UpdateState(List<int> ids, UpdateStateArguments args)
        {
            // Check user permissions
            var action = "State";
            var actionFilter = await UserPermissionsFilter(action, cancellation: default);
            ids = await CheckActionPermissionsBefore(actionFilter, ids);

            // C# Validation 
            if (string.IsNullOrWhiteSpace(args.State))
            {
                throw new BadRequestException(_localizer[Constants.Error_Field0IsRequired, _localizer["State"]]);
            }

            if (!DefStates.All.Contains(args.State))
            {
                string validStates = string.Join(", ", DefStates.All);
                throw new BadRequestException($"'{args.State}' is not a valid definition state, valid states are: {validStates}");
            }

            // Transaction
            using var trx = ControllerUtilities.CreateTransaction();

            // Validate
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var errors = await _repo.ResourceDefinitions_Validate__UpdateState(ids, args.State, top: remainingErrorCount);
            ControllerUtilities.AddLocalizedErrors(ModelState, errors, _localizer);
            ModelState.ThrowIfInvalid();

            // Execute
            await _repo.ResourceDefinitions__UpdateState(ids, args.State);

            // Prepare response
            List<ResourceDefinition> data = null;
            Extras extras = null;

            if (args.ReturnEntities ?? false)
            {
                (data, extras) = await GetByIds(ids, args, action, cancellation: default);
            }

            // Check user permissions again
            await CheckActionPermissionsAfter(actionFilter, ids, data);

            // Commit and return
            trx.Complete();
            return (data, extras);
        }

        protected override Task<IEnumerable<AbstractPermission>> UserPermissions(string action, CancellationToken cancellation)
        {
            return _repo.PermissionsFromCache(View, action, cancellation);
        }

        protected override IRepository GetRepository()
        {
            return _repo;
        }

        protected override Query<ResourceDefinition> Search(Query<ResourceDefinition> query, GetArguments args)
        {
            string search = args.Search;
            if (!string.IsNullOrWhiteSpace(search))
            {
                search = search.Replace("'", "''"); // escape quotes by repeating them

                var titleP = nameof(ResourceDefinition.TitlePlural);
                var titleP2 = nameof(ResourceDefinition.TitlePlural2);
                var titleP3 = nameof(ResourceDefinition.TitlePlural3);

                var titleS = nameof(ResourceDefinition.TitleSingular);
                var titleS2 = nameof(ResourceDefinition.TitleSingular2);
                var titleS3 = nameof(ResourceDefinition.TitleSingular3);
                var code = nameof(ResourceDefinition.Code);

                query = query.Filter($"{titleS} contains '{search}' or {titleS2} contains '{search}' or {titleS3} contains '{search}' or {titleP} contains '{search}' or {titleP2} contains '{search}' or {titleP3} contains '{search}' or {code} contains '{search}'");
            }

            return query;
        }

        protected override async Task SaveValidateAsync(List<ResourceDefinitionForSave> entities)
        {
            int index = 0;
            entities.ForEach(entity =>
            {
                if (entity.DefaultVatRate < 0m || entity.DefaultVatRate > 1m)
                {
                    var path = $"[{index}].{nameof(ResourceDefinition.DefaultVatRate)}";
                    var msg = _localizer["Error_VatRateMustBeBetweenZeroAndOne"];

                    ModelState.AddModelError(path, msg);
                }

                index++;
            });

            ModelState.ThrowIfInvalid();

            // SQL validation
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var sqlErrors = await _repo.ResourceDefinitions_Validate__Save(entities, top: remainingErrorCount);

            // Add errors to model state
            ModelState.AddLocalizedErrors(sqlErrors, _localizer);
        }

        protected override async Task<List<int>> SaveExecuteAsync(List<ResourceDefinitionForSave> entities, bool returnIds)
        {
            return await _repo.ResourceDefinitions__Save(entities, returnIds: returnIds);
        }

        protected override async Task DeleteValidateAsync(List<int> ids)
        {
            // SQL validation
            int remainingErrorCount = ModelState.MaxAllowedErrors - ModelState.ErrorCount;
            var sqlErrors = await _repo.ResourceDefinitions_Validate__Delete(ids, top: remainingErrorCount);

            // Add errors to model state
            ModelState.AddLocalizedErrors(sqlErrors, _localizer);
        }

        protected override async Task DeleteExecuteAsync(List<int> ids)
        {
            try
            {
                await _repo.ResourceDefinitions__Delete(ids);
            }
            catch (ForeignKeyViolationException)
            {
                throw new BadRequestException(_localizer["Error_CannotDelete0AlreadyInUse", _localizer["ResourceDefinition"]]);
            }
        }
    }
}
