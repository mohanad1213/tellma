﻿using System;
using Tellma.Services.Utilities;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Tellma.Services.Email
{
    public class EmailSenderFactory : IEmailSenderFactory
    {
        private readonly GlobalOptions _globalConfig;
        private readonly SendGridEmailSender _sendGridEmailSender;

        public EmailSenderFactory(IOptions<GlobalOptions> globalOptions, SendGridEmailSender sendGridEmailSender)
        {
            _globalConfig = globalOptions.Value;
            _sendGridEmailSender = sendGridEmailSender;
        }

        public IEmailSender Create()
        {
            if(_globalConfig.EmailEnabled)
            {
                return _sendGridEmailSender;
            }
            else
            {
                return new DisabledEmailSender();
            }
        }
    }
}
