import Foundation

struct MoviesSearchResponse: Decodable {
    
    let search: [Movie]?
    let totalResults: String?
    let response: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
        case error = "Error"
    }
    
    struct Movie: Decodable {
        let title: String?
        let year: String?
        let imdbID: String?
        let type: String?
        let poster: String?
        let plot: String?
        
        enum CodingKeys: String, CodingKey {
            case title = "Title"
            case year = "Year"
            case imdbID = "imdbID"
            case type = "Type"
            case poster = "Poster"
            case plot = "Plot"
        }
    }
}
