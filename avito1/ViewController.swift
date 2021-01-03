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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSetting()
        // Do any additional setup after loading the view.
    }
    
    
    func startSetting() {
        closeIconImage.image = UIImage(named: "CloseIconTemplate")
//        closeIcon.image = UIImage(named: "CloseIconTemplate")
        
    }

}

