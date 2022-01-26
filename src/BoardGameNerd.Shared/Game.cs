using System.Text.Json.Serialization;

namespace BoardGameNerd.Shared
{
    public class Game
    {
        [JsonPropertyName("gameId")]
        public int? Id { get; set; }

        [JsonPropertyName("rank")]
        public int? Rank { get; set; }

        [JsonPropertyName("name")]
        public string? Name { get; set; }

        [JsonPropertyName("description")]
        public string? Description { get; set; }

        [JsonPropertyName("image")]
        public string? Image { get; set; }

        [JsonPropertyName("thumbnail")]
        public string? Thumbnail { get; set; }

        [JsonPropertyName("averageRating")]
        public decimal? Rating { get; set; }

        [JsonPropertyName("yearPublished")]
        public int? Year { get; set; }

        [JsonPropertyName("mechanics")]
        public string[]? Mechanics { get; set; }

        [JsonPropertyName("isExpansion")]
        public bool? IsExpansion { get; set; } = false;
    }
}
