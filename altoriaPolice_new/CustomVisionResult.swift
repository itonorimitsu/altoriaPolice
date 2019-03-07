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
    let Probability: Double
    //ここの変数は非optinal型なのでnilが入る時点でエラーになる(はず)
    //jsonの型を宣言していて,String(文字列)をkeyにしてどんなものでも受け取れるようにしている。
    public init(json: [String: Any]){
        let probability = json["probability"] as? Double
        let tagId = json["tagId"] as? String
        let tag = json["tagName"] as? String
        
        self.TagId = tagId!
        self.Tag = tag!
        self.Probability = probability!
        ///<mytheory> ここでのselfは上記のstructの宣言に準じると思われる。そのためここでnilが入る時点でエラーが発生しないとおかしいので、データは存在していると思われる。代入変数に!でアンラップしているのでnilならアウト
        //!や?はoptiomal型でnilを許容する。また!は暗黙的アンラップ型と呼ばれるオプショナル型
        //?ではoptinal型のオブジェクトに変換されてしまう。!ではoptinal型でラップされたオブジェクトをアンラップすることで元のデータで処理することができる。ただし注意することとして、ここでnilならエラーが発生してしまうことに注意。
    }
}


///<備忘録>
//asはクラスの型変換に用いられる
struct CustomVisionResult{
    let Id: String
    let Project: String
    let Iteration: String
    let Created: String
    let Predictions: [CustomVisionPrediction]
    
    public init(json: [String: Any])throws{
        //このパースではnilが出力される
        print(json)
        let id = json["id"] as? String
        let project = json["project"] as? String
        let iteration = json["iteration"] as? String
        let created = json["created"] as? String
        
        let predictionsJson = json["predictions"] as? [[String: Any]]
        
        //as?は型変換を行うがダウンキャストと呼ばれる手法で行なっている。これは型変換が行われるか場合に用い、行われなかった場合はnilを返す
        
        var predictions = [CustomVisionPrediction]()
        for predictionJson in predictionsJson! {
            do
            {
                let cvp = CustomVisionPrediction(json: predictionJson) //ここでerror。原因はnilが入っているからだと思う
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
