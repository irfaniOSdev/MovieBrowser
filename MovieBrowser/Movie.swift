import Foundation
import Freddy

struct Movie: Codable  {
    var id:Int?
    var posterPath: String?
    var backdrop: String?
    var title: String?
    var releaseDate: String?
    var rating: Double
    var overview: String?

}

extension Movie: JSONDecodable
{
    public init(json value: JSON) throws {
        
        id = try value.getInt(at: "id")
        title = try value.getString(at: "title")
        posterPath = try value.getString(at: "poster_path")
        overview = try value.getString(at: "overview")
        backdrop = try value.getString(at: "backdrop_path")
        releaseDate = try value.getString(at: "release_date")
        rating = try value.getDouble(at: "vote_average")

    }
}
struct Genre: Codable
{
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
}

struct MovieVideo: Codable  {
    var id: String?
    var iso63: String?
    var iso31: String?
    var key: String?
    var name: String?
    var site: String?
    var size: Int?
    var type: String?
}

extension MovieVideo: JSONDecodable
{
    
    public init(json value: JSON) throws {
        
        id = try value.getString(at: "id")
        iso63 = try value.getString(at: "iso_639_1")
        iso31 = try value.getString(at: "iso_3166_1")
        key = try value.getString(at: "key")
        name = try value.getString(at: "name")
        site = try value.getString(at: "site")
        size = try value.getInt(at: "size")
        type = try value.getString(at: "type")
        
    }
}

struct MovieDetails: Codable  {
    let id: Int
    let title: String?
    var overview: String?
    var coverPath: String?
    var voteAvarage: Decimal?
    let releaseDate: String
    var backdropPath: String?
    var budget: Int?
    var revenue: Int?
    var runtime: Int?
    var genres: [Genre]?
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case coverPath = "poster_path"
        case voteAvarage = "vote_average"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case budget
        case revenue
        case runtime
        case genres = "genres"

    }
}
