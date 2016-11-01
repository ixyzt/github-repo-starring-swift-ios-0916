//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    static var completeJSON = [[String:Any]]()
    
    class func getRepositories(completionHandler: @escaping ([[String: Any]]?)->()) {
        
        let urlString = "https://api.github.com/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        if let unwrappedURL = url {
            
            let dataTask = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
                
                
                // checks for internet accessibility
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    
                    if let unwrappeddata = data {
                        print("I'm running")
                        do {
                            let responseJSON = try
                                JSONSerialization.jsonObject(with: unwrappeddata, options: [])
//                            dump(responseJSON)
                            self.completeJSON = responseJSON as! [[String : Any]]
                            dump(self.completeJSON)
                            completionHandler(self.completeJSON)
                        } catch {
                            
                        }
                    }
                }
            })
            dataTask.resume()
        }
    }
    
//    class func getRepositoriesWithCompletion(_ completion: @escaping ([Any]) -> ()) {
//        let urlString = "\(Secrets.apiURL)/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
//        let url = URL(string: urlString)
//        let session = URLSession.shared
//        
//        guard let unwrappedURL = url else { fatalError("Invalid URL") }
//        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
//            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
//            
//            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
//                if let responseArray = responseArray {
//                    completion(responseArray)
//                    print(responseArray)
//                }
//            }
//        }) 
//        task.resume()
//    }
    
    class func checkIfRepositoryIsStarred(fullName: String,  completion:  @escaping (Bool) -> () ) {
        
        let urlString = "\(Secrets.apiURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            
            // checks for internet accessibility
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 204 {
                print("Checked: \(fullName)'s repository is starred")
                completion(true)
            } else if httpResponse.statusCode == 404 {
                print("Checked: \(fullName)'s repository is NOT starred")
                completion(false)
            }
        })
        dataTask.resume()
    }
    
    class func starRepository(fullName: String, completion: @escaping () -> ()) {
        let urlString = "\(Secrets.apiURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = URL(string: urlString)
        
        guard let urlCheck = url else { return }
        
        var urlRequest = URLRequest(url: urlCheck)
        urlRequest.httpMethod = "PUT"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            print("--------Repository has been starred------------\n\n")
            completion()
        }
        dataTask.resume()
    }
    
    class func unstarRepository(fullName: String, completion: @escaping () -> ()) {
        let urlString = "\(Secrets.apiURL)/user/starred/\(fullName)?access_token=\(Secrets.token)"
        let url = URL(string: urlString)
        
        guard let urlCheck = url else { return }
        
        var urlRequest = URLRequest(url: urlCheck)
        urlRequest.httpMethod = "DELETE"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            print("--------Repository has been unstarred------------\n\n")
            completion()
        }
        dataTask.resume()
    }
}

