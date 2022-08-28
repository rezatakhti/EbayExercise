//
//  FeedImageView.swift
//  RecordList
//
//  Created by Takhti, Gholamreza on 8/25/22.
//

import UIKit

enum ImageLoaderError: Error {
    case unableToComplete
    case invalidResponse
}

protocol FeedImageViewDelegate : AnyObject {
    func imageDidLoad(for url: String, image: UIImage?)
}

class FeedImageView : UIImageView {
    
    weak var delegate : FeedImageViewDelegate?
    
    init(){
        super.init(image: nil)
        self.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available (iOS 15.0, *)
    @discardableResult func loadImage(at urlString: String) async throws -> UIImage? {
        guard let url = higherQualityImageURL(from: urlString)?.absoluteURL else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let image = UIImage(data: data)
        self.image = image
        
        delegate?.imageDidLoad(for: urlString, image: image)
        
        return image
    }
    
    @available (iOS, deprecated: 15.0, message: "Use async version instead")
    func loadImage(at urlString: String, completion: @escaping ((Result<UIImage, ImageLoaderError>) -> ())) {
        guard let url = higherQualityImageURL(from: urlString)?.absoluteURL else {
            completion(.failure(.unableToComplete))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.image = image
                    
                    self?.delegate?.imageDidLoad(for: urlString, image: image)
                    if let image = image {
                        completion(.success(image))
                    }
                }
            }
        }
        task.resume()
    }
    
    private func higherQualityImageURL(from urlString: String) -> URL? {
        guard var url = URLComponents(string: urlString) else { return nil }
        
        
        var subPaths = url.path.components(separatedBy: "/")
        
        if let index = subPaths.firstIndex(where: { $0.contains("100x100") }) {
            subPaths[index] = subPaths[index].replacingOccurrences(of: "100", with: "750")
        }
        url.path = subPaths.joined(separator: "/")
        return url.url
    }
}



