//
//  RequestManager.swift
//  funi
//
import Foundation

class RequestManager {
    let session: URLSession
    
    init() {
        session = URLSession.shared
    }
    
    func makeImageSearch(forTerm searchText: String, pageNumber: Int, completionHandler: @escaping ((_ result: RequestResult<[ImageAlbum]>) -> ()) ) {
        let request = prepareRequest(searchTerms: searchText, pageNumber: pageNumber)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil || data == nil {
                DispatchQueue.main.async {
                    if error != nil {
                        completionHandler(RequestResult.fail(error!))
                    } else {
                        completionHandler(RequestResult.fail(APIError.missingData))
                    }
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                
                //LOG
                let prettyResponse = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                print("JG response \(String(decoding: prettyResponse, as: UTF8.self))")
                
                
                let parser = Parser()
                let gallery = parser.parseResponse(json)
                
                DispatchQueue.main.async {
                    completionHandler(RequestResult.success(gallery))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(RequestResult.fail(APIError.serialization))
                }
            }
        }.resume()
    }
    
    func prepareRequest(searchTerms: String, pageNumber: Int) -> URLRequest {
//        print("pageNumber \(pageNumber)")
        let urlString = "https://api.imgur.com/3/gallery/search/time/\(pageNumber)?q=\(searchTerms)&q_type=jpg"
        let encodedStringURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedStringURL!)!
        var request = URLRequest(url: url)
        let clientID = "<#T##Insert your client ID#>"
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return request
    }
    
}
