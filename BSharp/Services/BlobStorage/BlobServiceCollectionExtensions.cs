﻿using BSharp.Services.BlobStorage;
using Microsoft.Extensions.Configuration;
using System;

namespace Microsoft.Extensions.DependencyInjection
{
    public static class BlobServiceCollectionExtensions
    {
        /// <summary>
        /// Registers the applications that 
        /// </summary>
        /// <param name="services"></param>
        /// <param name="config"></param>
        /// <returns></returns>
        public static IServiceCollection AddBlobService(this IServiceCollection services, IConfiguration config = null)
        {
            if (services == null)
            {
                throw new ArgumentNullException(nameof(services));
            }

            if(config != null)
            {
                services.Configure<BlobServiceOptions>(config);
            }

            services.AddScoped<IBlobServiceFactory, BlobServiceFactory>();
            services.AddScoped<IBlobService, BlobService>();

            return services;
        }
    }
}
