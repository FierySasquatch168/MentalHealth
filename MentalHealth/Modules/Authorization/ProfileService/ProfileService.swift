//
//  Profile.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    struct ProfileResult: Decodable {
        let username: String?
        let firstName: String?
        let lastName: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
    func fetchProfile(token: String?, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let urlRequest = profileRequest(token: token)
        guard let urlRequest = urlRequest else { return }
        let session = URLSession.shared
        
        let task = session.objectTask(for: urlRequest) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileresult):
                let profile = Profile(
                    username: profileresult.username,
                    name: "\(profileresult.firstName ?? "") \(profileresult.lastName ?? "")",
                    loginName: profileresult.username != nil ? "@\(profileresult.username!)" : "",
                    bio: profileresult.bio)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func profileRequest(token: String?) -> URLRequest? {
        guard let token = token else { return nil }
        var urlRequest = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: Constants().defaultBaseURL)
        
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    
    
    
    
}
