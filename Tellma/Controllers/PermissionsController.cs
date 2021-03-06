﻿using Tellma.Controllers.Dto;
using Tellma.Data;
using Tellma.Services.ApiAuthentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Threading;
using Tellma.Controllers.Utilities;

namespace Tellma.Controllers
{
    [Route("api/permissions")]
    [ApiController]
    [AuthorizeJwtBearer]
    [ApplicationController]
    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public class PermissionsController : ControllerBase
    {
        private readonly PermissionsService _service;
        private readonly ILogger _logger;

        public PermissionsController(PermissionsService service, ILogger<PermissionsController> logger)
        {
            _service = service;
            _logger = logger;
        }

        [HttpGet("client")]
        public virtual async Task<ActionResult<Versioned<PermissionsForClient>>> PermissionsForClient(CancellationToken cancellation)
        {
            return await ControllerUtilities.InvokeActionImpl(async () =>
            {
                var result = await _service.PermissionsForClient(cancellation);
                return Ok(result);
            }, 
            _logger);
        }
    }

    public class PermissionsService : ServiceBase
    {
        private readonly ApplicationRepository _repo;

        public PermissionsService(ApplicationRepository repo)
        {
            _repo = repo;
        }

        public async Task<Versioned<PermissionsForClient>> PermissionsForClient(CancellationToken cancellation)
        {                
            // Retrieve the user permissions and their current version
            var (version, permissions, reportIds, dashboardIds) = await _repo.Permissions__Load(true, cancellation);

            // Arrange the permission in a DTO that is easy for clients to consume
            var views = new PermissionsForClientViews();
            foreach (var gView in permissions.GroupBy(e => e.View))
            {
                string view = gView.Key;
                Dictionary<string, bool> viewActions = gView
                    .GroupBy(e => e.Action)
                    .ToDictionary(g => g.Key, g => true);

                views[view] = viewActions;
            }

            // Include the report Ids and definitionIds
            var permissionsForClient = new PermissionsForClient
            {
                Views = views,
                ReportIds = reportIds,
                DashboardIds = dashboardIds
            };

            // Tag the permissions for client with their current version
            var result = new Versioned<PermissionsForClient>
            (
                version: version.ToString(),
                data: permissionsForClient
            );

            // Return the result
            return result;
        }
    }
}
