using AutoMapper;
using EMS.Application.Common.Interfaces.DbContext;
using EMS.Application.Features.Chats.Dtos;
using EMS.Core.Enums;
using EMS.Core.Exceptions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EMS.Application.Features.AiTools.Commands.RejectExtractedTransactions
{
    public record RejectExtractedTransactionsCommand(string UserId, int MessageId) : IRequest<List<ExtractedTransactionDto>>;

    public class RejectExtractedTransactionsCommandHandler : IRequestHandler<RejectExtractedTransactionsCommand, List<ExtractedTransactionDto>>
    {
        private readonly ILogger<RejectExtractedTransactionsCommandHandler> _logger;
        private readonly IApplicationDbContext _context;
        private readonly IMapper _mapper;

        public RejectExtractedTransactionsCommandHandler(
            ILogger<RejectExtractedTransactionsCommandHandler> logger,
            IApplicationDbContext context,
            IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }
        public async Task<List<ExtractedTransactionDto>> Handle(RejectExtractedTransactionsCommand request, CancellationToken cancellationToken)
        {
            try
            {
                var query = _context.ExtractedTransactions
                    .Include(e => e.Category)
                    .Where(e => !e.Category!.IsDeleted)
                    .Where(e => !e.IsDeleted
                        && e.ConfirmationStatus == ConfirmationStatus.Pending
                        && !e.ChatExtraction.ChatMessage.IsDeleted
                        && e.ChatExtraction.ChatMessage.Id == request.MessageId);

                var extractedTransactions = await query.ToListAsync();

                if(!extractedTransactions.Any())
                {
                    throw new InvalidTransactionOperationException($"Message {request.MessageId} does not have any pending transaction");
                }

                foreach( var extractedTransaction in extractedTransactions)
                {
                    extractedTransaction.ConfirmationStatus = ConfirmationStatus.Rejected;
                }

                await _context.SaveChangesAsync();

                return _mapper.Map<List<ExtractedTransactionDto>>(extractedTransactions);
            }
            catch
            {
                _logger.LogError("An error occurred while rejecting extracted transactions of message {MsgId}", request.MessageId);
                throw;
            }
        }
    }
}
