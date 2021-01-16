//
//  ViewController.swift
//  avito1
//
//  Created by Mikhail Sergeev on 03.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var closeIconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var specialServiceCollectionView: UICollectionView!
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - Public Properties
    var json: TopLevelJSON? {
        didSet {
            if let json = json {
                visibleSpecialServices = json.result.list.filter({$0.isSelected})
                //                visibleSpecialServices = json.result.list
            }
        }
    }
    
    // MARK: - Private Properties
    private var visibleSpecialServices: [SpecialService] = []
    private var markedItem: Int?
    private var isMarked:Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
        setLayoutForSpecialServiceCollectionView()
    }
    
    // MARK: - Private Methods
    private func initialSetting() {
        if let json = json {
            titleLabel.text = json.result.title
            actionButton.setTitle(json.result.actionTitle, for: .normal)
            closeIconImage.image = UIImage(named: ImageName.close)
        }
    }
    
    private func setLayoutForSpecialServiceCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        specialServiceCollectionView.collectionViewLayout = layout
    }
    
    // MARK: - IBAction
    @IBAction func tappedActionButton(_ sender: Any) {
        var titleAlert: String = ""
        var titleAction: String = ""
        var message: String = ""
        
        if isMarked {
            titleAlert = visibleSpecialServices[markedItem!].title
            titleAction = AlertTitles.gotIt
            let description = visibleSpecialServices[markedItem!].description ?? ""
            let price = description == "" ? visibleSpecialServices[markedItem!].price : "\n" + visibleSpecialServices[markedItem!].price
            message = description + price
        } else {
            titleAlert = AlertTitles.notSelected
            titleAction = AlertTitles.ok
        }
        
        let alert = UIAlertController(title: titleAlert, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return visibleSpecialServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialServiceCell.identifier, for: indexPath) as! SpecialServiceCell
        
        cell.titleLabel.text = visibleSpecialServices[indexPath.item].title
        cell.descriptionLabel.text = visibleSpecialServices[indexPath.item].description
        cell.priceLabel.text = visibleSpecialServices[indexPath.item].price
        
        if markedItem == indexPath.item && isMarked {
            cell.checkmarkImageView.image = UIImage(named: ImageName.checkmark)
        }
        
        Network.loadImageFrom(address: visibleSpecialServices[indexPath.item]) { (data) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                cell.iconImageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! SpecialServiceCell
        
        if markedItem == indexPath.item {
            if isMarked {
                isMarked = false
                selectedCell.checkmarkImageView.image = nil
            } else {
                isMarked = true
                selectedCell.checkmarkImageView.image = UIImage(named: ImageName.checkmark)
            }
        }
        
        if markedItem != indexPath.item {
            isMarked = true
            markedItem = indexPath.item
            selectedCell.checkmarkImageView.image = UIImage(named: ImageName.checkmark)
        }
        
        guard let json = json else {
            return
        }
        
        if isMarked {
            actionButton.setTitle(json.result.selectedActionTitle, for: .normal)
        } else {
            actionButton.setTitle(json.result.actionTitle, for: .normal)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let deselectedCell = collectionView.cellForItem(at: indexPath) as? SpecialServiceCell {
            deselectedCell.checkmarkImageView.image = nil
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 123
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
}

