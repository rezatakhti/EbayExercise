//
//  FeedService.swift
//  RecordList
//
//  Created by Takhti, Gholamreza on 8/24/22.
//

import Foundation

enum FeedError : Error {
    case unableToComplete
    case unableToDecode
    case invalidResponse
}

protocol FeedService {
    associatedtype T : CodableFeedResponse
    associatedtype E : Error
    @available (iOS 15.0, *)
    func getFeed() async throws -> T?
    func getFeed(completion: @escaping ((Result<T, E>) -> ()))
}

class SongFeedService : FeedService {
    let baseURL = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/songs.json"
    
    @available (iOS 15.0, *)
    func getFeed() async throws -> SongFeedResponse? {
        guard let url = URL(string: baseURL) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let feed = try decoder.decode(SongFeedResponse.self, from: data)
                    return feed
                    
                } catch {
                    throw FeedError.unableToDecode
                }
            }
        } catch {
            throw FeedError.unableToComplete
        }
        return nil
    }
    
    @available(iOS, deprecated:15.0, message: "Use async version instead")
    func getFeed(completion: @escaping ((Result<SongFeedResponse, FeedError>) -> ())) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.unableToComplete))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let feed = try decoder.decode(SongFeedResponse.self, from: data)
                        completion(.success(feed))
                    } catch {
                        
                    }
                } else {
                    completion(.failure(.unableToDecode))
                }
        }
        
        task.resume()
    }
    
}
