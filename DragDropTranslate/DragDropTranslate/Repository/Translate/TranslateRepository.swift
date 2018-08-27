//
//  TranslateRepository.swift
//  DragDropTranslate
//
//  Created by Thiago Santiago on 8/26/18.
//  Copyright © 2018 Thiago Santiago. All rights reserved.
//

import Foundation

class TranslateRepository {
    typealias  TranslateRepositoryError = ((_ errorMessage: String) -> Void)
    
    typealias TranslateTextSuccess = ((_ response: TranslateData) -> Void)
    func translateText(_ text: String, success: @escaping TranslateTextSuccess, failure: @escaping TranslateRepositoryError) {
        
        let request = TranslateRequest(textDragged: text)
        guard let url = URL(string: Constants.baseUrl+request.endpoint) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    failure(error.localizedDescription)
                } else if let jsonData = responseData {
                  let decoder = JSONDecoder()
                    
                    do {
                        let data = try decoder.decode(TranslateData.self, from: jsonData)
                        success(data)
                    } catch {
                      failure("Error")
                    }
                } else {
                    failure("Data was not retrieved from request")
                }
            }
        }
        task.resume()
    }
}
