//
//  CustomVisionService.swift
//  altoriaPolice_new
//
//  Created by 伊藤永光 on 2019/02/24.
//  Copyright © 2019 Nito. All rights reserved.
//

import Foundation

class CustomVisionService{
    var preductionUrl = "https://southcentralus.api.cognitive.microsoft.com/customvision/v2.0/Prediction/81c929bd-9fac-4bb9-bfa2-b756c7a6815a/image?iterationId=af86fb03-3148-4e5b-b6a2-0fe8551fdbf9"
    var predictionKey = "f2aec95daea047cc8154d378978e886d"
    var contentType = "application/octet-stream"
    
    var defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    
    //@escapinggで定義することでスコープ外からもアクセスすることができるという意味だと思われる
    //クロージャで使うらしい。
    func predict(image: Data, completion: @escaping (CustomVisionResult?, Error?) -> Void){
        var urlRequest = URLRequest(url: URL(string: preductionUrl)!)
        urlRequest.addValue(predictionKey, forHTTPHeaderField: "Prediction-Key")
        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        dataTask?.cancel()
        
        //ここのresponseでjsonデータを入手している。dataがjsonの中身、responseが帰ってきているのか判定?
        dataTask = defaultSession.uploadTask(with: urlRequest, from: image) { data, response, error in defer {self.dataTask = nil}
            
            if let error = error{
                completion(nil, error)
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200{
                //Jsonserialization.jsonObjectはJsonのパースを行い、anyで返すか、パースできなければerrorを返すようにしている
                //try?はerrorを無視して実行するのに使うらしい
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let result = try? CustomVisionResult(json: json!){//ここでresultにjsonデータを投げている
                    completion(result, nil)
                }
            }
        }
        dataTask?.resume()
    }
}
