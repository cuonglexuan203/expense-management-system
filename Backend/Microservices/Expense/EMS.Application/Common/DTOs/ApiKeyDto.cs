using AutoMapper;
using EMS.Application.Common.Mappings;
using EMS.Core.Entities;

namespace EMS.Application.Common.DTOs
{
    public class ApiKeyDto : IMapFrom<ApiKey>
    {
        public Guid Id { get; set; }
        //public string Key { get; set; } = default!;
        public string Name { get; set; } = default!;
        public string? Description { get; set; }
        public Guid OwnerId { get; set; }
        public DateTimeOffset? CreatedAt { get; set; }
        public DateTimeOffset? ExpiresAt { get; set; }
        public DateTimeOffset? LastUsedAt { get; set; }
        public bool IsActive { get; set; }

        public ICollection<string> Scopes { get; set; } = [];

        public void Mapping(Profile profile)
        {
            profile.CreateMap<ApiKey, ApiKeyDto>()
                .ForMember(e => e.Scopes, opts => opts.MapFrom(src => src.Scopes.Select(s => s.Scope)));
        }
    }

    public class ApiKeyCreationDto
    {
        public string Name { get; set; } = default!;
        public string? Description { get; set; }
        public DateTimeOffset? ExpiresAt { get; set; }
        public IEnumerable<string> Scopes { get; set; } = [];
    }

    public class ApiKeyCreationResultDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = default!;
        public string Key { get; set; } = default!; // Plane text key (shown only once)
        public DateTimeOffset? CreatedAt { get; set; }
        public DateTimeOffset? ExpiresAt { get; set; }
        public IEnumerable<string> Scopes { get; set; } = [];
    }
}
