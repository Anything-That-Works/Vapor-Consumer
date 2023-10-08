//
//  HttpClient.swift
//  Vapor Consumer
//
//  Created by Promal on 9/10/23.
//

import Foundation
enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

enum HttpMethods: String {
  case POST, GET, PUT, DELETE
}

enum MIMEType: String {
  case JSON = "application/json"
}

enum HttpHeaders: String {
  case contentType = "Content-Type"
}

class HttpClient {
  //MARK: Private init so in can't be initialized randomly
  private init() {}
  //MARK: Shared property to access HttpClient making it singleton
  static let shared = HttpClient()
  
  
  //MARK: Making http request generic
  func fetch<T: Codable>(url: URL) async throws -> [T] {
    //MARK: Making URL request
    let (data, response) = try await URLSession.shared.data(from: url)
    
    //MARK: Checking response status code
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw HttpError.badResponse
    }
    
    //MARK: Decoding data with JSONDecoder
    guard let object = try? JSONDecoder().decode([T].self, from: data) else {
      throw HttpError.errorDecodingData
    }
    
    return object
  }
  
  func sendData<T: Codable>(to url: URL, object: T, httpMethod: String) async throws {
    var request = URLRequest(url: url)
    
    request.httpMethod = httpMethod
    request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
    
    request.httpBody = try? JSONEncoder().encode(object)
    
    let (_, response) = try await URLSession.shared.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw HttpError.badResponse
    }
  }
  
  func delete(at id: UUID, url: URL) async throws {
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethods.DELETE.rawValue
    
    let (_, response) = try await URLSession.shared.data(for: request)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw HttpError.badResponse
    }
  }
}
