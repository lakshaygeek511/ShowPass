import Foundation

class HomeViewModel {
    private(set) var trendingMovies: [Movie] = []
    private(set) var nowPlayingMovies: [Movie] = []
    
    var moviesDidUpdate: (() -> Void)?
    
    func fetchMovies() {
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.fetchTrendingMovies { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let response):
                self?.trendingMovies = response.results
            case .failure(let error):
                print("Error fetching trending movies: \(error)")
            }
        }
        
        group.enter()
        NetworkManager.shared.fetchNowPlayingMovies { [weak self] result in
            defer { group.leave() }
            switch result {
            case .success(let response):
                self?.nowPlayingMovies = response.results
            case .failure(let error):
                print("Error fetching now playing movies: \(error)")
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.moviesDidUpdate?()
        }
    }
} 