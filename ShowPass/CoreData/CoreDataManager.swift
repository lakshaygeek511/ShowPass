import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
        context = persistentContainer.viewContext
    }
    
    func saveBookmark(movie: Movie) {
        let entity = MovieEntity(context: context)
        entity.id = Int64(movie.id)
        entity.title = movie.title
        entity.overview = movie.overview
        entity.posterPath = movie.posterPath
        entity.backdropPath = movie.backdropPath
        entity.releaseDate = movie.releaseDate
        entity.voteAverage = movie.voteAverage
        entity.voteCount = Int64(movie.voteCount)
        entity.bookmarkDate = Date()
        
        saveContext()
    }
    
    func removeBookmark(movieId: Int) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let movieToDelete = results.first {
                context.delete(movieToDelete)
                saveContext()
            }
        } catch {
            print("Error removing bookmark: \(error)")
        }
    }
    
    func isMovieBookmarked(movieId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking bookmark status: \(error)")
            return false
        }
    }
    
    func fetchBookmarkedMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "bookmarkDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { entity in
                Movie(id: Int(entity.id),
                     title: entity.title ?? "",
                     overview: entity.overview ?? "",
                     posterPath: entity.posterPath,
                     backdropPath: entity.backdropPath,
                     releaseDate: entity.releaseDate ?? "",
                     voteAverage: entity.voteAverage,
                     voteCount: Int(entity.voteCount))
            }
        } catch {
            print("Error fetching bookmarks: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
} 