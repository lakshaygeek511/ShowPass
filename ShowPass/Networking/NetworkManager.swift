import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "e82191d6cb7fdee93d34c5cad05821e8"
    
    private init() {}
    
    func fetchTrendingMovies(completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let endpoint = "/trending/movie/day"
        performRequest(with: endpoint, completion: completion)
    }
    
    func fetchNowPlayingMovies(completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let endpoint = "/movie/now_playing"
        performRequest(with: endpoint, completion: completion)
    }
    
    func searchMovies(query: String, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let endpoint = "/search/movie"
        let queryItems = [URLQueryItem(name: "query", value: query)]
        performRequest(with: endpoint, queryItems: queryItems, completion: completion)
    }
    
    private func performRequest<T: Decodable>(
        with endpoint: String,
        queryItems: [URLQueryItem] = [],
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var components = URLComponents(string: baseURL + endpoint)
        var allQueryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        allQueryItems.append(contentsOf: queryItems)
        components?.queryItems = allQueryItems
        
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
} 