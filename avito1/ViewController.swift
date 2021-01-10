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
    
    var selectedItem: Int?
    var isMarked:Bool = false
    var dataJSON: TopLevelJSON?
    var checkmark = UIImage(named: "checkmark")
    var visibleBlocks: [InfoBlockJSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCloseIcon()
        settingsForBlock()
        parsingJSON()
        setLayoutForBlock()
    }
    
    private func settingsForBlock() {
        blockView.dataSource = self
        blockView.delegate = self
    }
    
    private func setLayoutForBlock() {
        let blockLayout = UICollectionViewFlowLayout()
        blockLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        blockView.collectionViewLayout = blockLayout
    }
    
    private func setCloseIcon() {
        closeIconImage.image = UIImage(named: "CloseIconTemplate")
    }
    
    private func parsingJSON() {
        
        let urlJSON = Bundle.main.url(forResource: "result", withExtension: "json")!
        
        if let data = try? Data(contentsOf: urlJSON), let json = try? JSONDecoder().decode(TopLevelJSON.self, from: data) {
            dataJSON = json
//            visibleBlocks = json.result.list.filter({$0.isSelected})
            visibleBlocks = json.result.list
            titleLabel.text = json.result.title
            actionButton.setTitle(json.result.actionTitle, for: .normal)
        }
    }
    
    @IBAction func tappedActionButton(_ sender: Any) {
        // создается Alert с названием выбранного блока
        if isMarked {
            print("Выбрана услуга \(visibleBlocks[selectedItem!].title)")
        } else {
            print("Без услуг")
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return visibleBlocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Block", for: indexPath) as! Block
        cell.titleLabel.text = visibleBlocks[indexPath.item].title
        cell.descriptionLabel.text = visibleBlocks[indexPath.item].description
        cell.priceLabel.text = visibleBlocks[indexPath.item].price
        cell.checkmarkImageView.backgroundColor = .none
        cell.iconImageView.backgroundColor = .none
        cell.iconImageView.image = nil
        cell.checkmarkImageView.image = nil
        
        if selectedItem == indexPath.item && isMarked {
            cell.checkmarkImageView.image = checkmark
        }
        
        // известна проблема при мерцании картинок коллекции/таблицы при быстром скролливании, но в этом проекте лишь 2 видимых (ну или всего 5) картинок малого размера, поэтому я не реализовал дополнительных код для предотвращения подобного явления
        
        if let url = URL(string: visibleBlocks[indexPath.item].icon.values.first!) {
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
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? Block {
                        
            if selectedItem == indexPath.item {
                if isMarked {
                    isMarked = false
                    selectedCell.checkmarkImageView.image = nil
                } else {
                    isMarked = true
                    selectedCell.checkmarkImageView.image = checkmark
                }
            }
            
            if selectedItem != indexPath.item {
                isMarked = true
                selectedItem = indexPath.item
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
        if let deselectedCell = collectionView.cellForItem(at: indexPath) as? Block {
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

