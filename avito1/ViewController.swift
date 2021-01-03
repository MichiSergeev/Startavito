//
//  ViewController.swift
//  avito1
//
//  Created by Mikhail Sergeev on 03.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var closeIconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var blockView: UICollectionView!
    @IBOutlet weak var actionButton: UIButton!
    
    var dataJSON: TopLevelJSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parsingJSON()
        startSetting()
        print(dataJSON)
        // Do any additional setup after loading the view.
    }
    
    
    func startSetting() {
        closeIconImage.image = UIImage(named: "CloseIconTemplate")
        
    }
    
    func parsingJSON() {
        let urlJSON = Bundle.main.url(forResource: "result", withExtension: "json")
        if let data = try? Data(contentsOf: urlJSON!) {
            let decoder = JSONDecoder()
            if let json = try? decoder.decode(TopLevelJSON.self, from: data) {
                dataJSON = json
            }
        }
    }
    
}

