//
//  OAuth2Service.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private var lastCode: String?
    private var task: URLSessionTask?
    private var urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else { return }
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                print("Auth token is: \(authToken)")
                completion(.success(authToken))
                self.task = nil
                self.lastCode = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func authTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com") else { return nil}
        return URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants().accessKey)"
            + "&&client_secret=\(Constants().secretKey)"
            + "&&redirect_uri=\(Constants().redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: url)
    }
    
    
    
    
    
    
    
    
}
