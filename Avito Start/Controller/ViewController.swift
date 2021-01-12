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
    @IBOutlet weak var specialServiceCollectionView: UICollectionView!
    @IBOutlet weak var actionButton: UIButton!
    
    var markedItem: Int?
    var isMarked:Bool = false
    var dataJSON: TopLevelJSON?
    var checkmark = UIImage(named: "checkmark")
    var visibleSpecialServices: [SpecialService] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCloseIcon()
        parsingJSON()
        setLayoutForSpecialServiceCollectionView()
    }
    
    private func setLayoutForSpecialServiceCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        specialServiceCollectionView.collectionViewLayout = layout
    }
    
    private func setCloseIcon() {
        closeIconImage.image = UIImage(named: "CloseIconTemplate")
    }
    
    
    private func parsingJSON() {
        
        let urlJSON = Bundle.main.url(forResource: "result", withExtension: "json")!
        
        if let data = try? Data(contentsOf: urlJSON), let json = try? JSONDecoder().decode(TopLevelJSON.self, from: data) {
            dataJSON = json
            
            // на экране в коллекции будут только блоки, разрешенные для показа из json
            visibleSpecialServices = json.result.list.filter({$0.isSelected})
            // или
            // на экране в коллекции будут все блоки из json
//            visibleBlocks = json.result.list
            
            titleLabel.text = json.result.title
            actionButton.setTitle(json.result.actionTitle, for: .normal)
        }
    }
    
    @IBAction func tappedActionButton(_ sender: Any) {
        
        enum Titles: String {
            case gotIt = "Понятно"
            case notSelected = "Услуга не выбрана"
            case ok = "OK"
        }
        
        var titleAlert: String = ""
        var titleAction: String = ""
        var message: String = ""
        
        if isMarked {
            titleAlert = visibleSpecialServices[markedItem!].title
            titleAction = Titles.gotIt.rawValue
            let description = visibleSpecialServices[markedItem!].description ?? ""
            let price = description == "" ? visibleSpecialServices[markedItem!].price : "\n" + visibleSpecialServices[markedItem!].price
            message = description + price
        } else {
            titleAlert = Titles.notSelected.rawValue
            titleAction = Titles.ok.rawValue
        }
        
        let alert = UIAlertController(title: titleAlert, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return visibleSpecialServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialServiceCell.identifier, for: indexPath) as! SpecialServiceCell
        cell.titleLabel.text = visibleSpecialServices[indexPath.item].title
        cell.descriptionLabel.text = visibleSpecialServices[indexPath.item].description
        cell.priceLabel.text = visibleSpecialServices[indexPath.item].price
        cell.checkmarkImageView.backgroundColor = .none
        cell.iconImageView.backgroundColor = .none
        cell.iconImageView.image = nil
        cell.checkmarkImageView.image = nil
        
        if markedItem == indexPath.item && isMarked {
            cell.checkmarkImageView.image = checkmark
        }
        
        //мне известно о возможной проблеме при мерцании картинок коллекции/таблицы при быстром скролливании, но в этом проекте лишь 2 видимых (или всего 5) картинок малого размера, поэтому я не реализовал дополнительных код для предотвращения подобного явления
        
        if let url = URL(string: visibleSpecialServices[indexPath.item].icon.values.first!) {
            URLSession.shared.dataTask(with: url) { (data, responce, error) in
                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.iconImageView.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? SpecialServiceCell {
            
            if markedItem == indexPath.item {
                if isMarked {
                    isMarked = false
                    selectedCell.checkmarkImageView.image = nil
                } else {
                    isMarked = true
                    selectedCell.checkmarkImageView.image = checkmark
                }
            }
            
            if markedItem != indexPath.item {
                isMarked = true
                markedItem = indexPath.item
                selectedCell.checkmarkImageView.image = checkmark
            }
            
            if isMarked {
                actionButton.setTitle(dataJSON?.result.selectedActionTitle, for: .normal)
            } else {
                actionButton.setTitle(dataJSON?.result.actionTitle, for: .normal)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let deselectedCell = collectionView.cellForItem(at: indexPath) as? SpecialServiceCell {
            deselectedCell.checkmarkImageView.image = nil
        }
    }
    
}


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

