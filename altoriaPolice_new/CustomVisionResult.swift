//
//  CustomVisionResult.swift
//  altoriaPolice_new
//
//  Created by 伊藤永光 on 2019/02/24.
//  Copyright © 2019 Nito. All rights reserved.
//

import Foundation

struct CustomVisionPrediction{
    let TagId: String
    let Tag: String
    let Probability: Float
    
    public init(json: [String: Any]){
        let tagId = json["TagId"] as? String
        let tag = json["Tag"] as? String
        let probability = json["Probability"] as? Float
        
        self.TagId = tagId!
        self.Tag = tag!
        self.Probability = probability!
    }
}

struct CustomVisionResult{
    let Id: String
    let Project: String
    let Iteration: String
    let Created: String
    let Predictions: [CustomVisionPrediction]
    
    public init(json: [String: Any])throws{
        let id = json["Id"] as? String
        let project = json["Project"] as? String
        let iteration = json["Iteration"] as? String
        let created = json["Created"] as? String
        
        let predictionsJson = json["Predictions"] as? [[String: Any]]
        
        var predictions = [CustomVisionPrediction]()
        for predictionJson in predictionsJson! {
            do
            {
                let cvp = CustomVisionPrediction(json: predictionJson)
                predictions.append(cvp)
            }
        }
        self.Id = id!
        self.Project = project!
        self.Iteration = iteration!
        self.Created = created!
        self.Predictions = predictions
    }
}
