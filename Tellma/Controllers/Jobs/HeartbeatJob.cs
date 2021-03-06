﻿using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Threading;
using System.Threading.Tasks;
using System.Transactions;
using Tellma.Data;

namespace Tellma.Controllers.Jobs
{
    /// <summary>
    /// Sends regular heartbeats to the admin database to keep the record of this instance alive.
    /// This prevents orphans adopted by this instance from being adopted again by another
    /// </summary>
    public class HeartbeatJob : BackgroundService
    {
        private readonly AdminRepositoryLite _repo;
        private readonly ILogger<HeartbeatJob> _logger;
        private readonly IServiceProvider _services;
        private readonly InstanceInfoProvider _instanceInfo;
        private readonly JobsOptions _options;

        public HeartbeatJob(AdminRepositoryLite repo, ILogger<HeartbeatJob> logger, IServiceProvider services, InstanceInfoProvider instanceInfo, IOptions<JobsOptions> options)
        {
            _repo = repo;
            _logger = logger;
            _services = services;
            _instanceInfo = instanceInfo;
            _options = options.Value;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while(!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    // Begin serializable transaction
                    using var trx = new TransactionScope(TransactionScopeOption.RequiresNew, new TransactionOptions { IsolationLevel = IsolationLevel.Serializable }, TransactionScopeAsyncFlowOption.Enabled);

                    await _repo.Heartbeat(_instanceInfo.Id, _options.InstanceKeepAliveInSeconds, stoppingToken);

                    trx.Complete();
                } 
                catch (Exception ex)
                {
                    _logger.LogError(ex, $"Error executing {nameof(HeartbeatJob)} at {DateTimeOffset.Now}: {ex.Message}");
                }

                await Task.Delay(_options.InstanceHeartRateInSeconds * 1000, stoppingToken);
            }
        }
    }
}
