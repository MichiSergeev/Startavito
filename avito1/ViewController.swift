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
    
    var dataJSON: TopLevelJSON?
    var checkmark = UIImage(named: "checkmark")
    var visibleBlocks: [InfoBlockJSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsForBlock()
        parsingJSON()
        setLayoutForBlock()
        setCloseIcon()
        
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
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return visibleBlocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // заполняем блоки коллекции
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Block", for: indexPath) as! Block

        cell.titleLabel.text = visibleBlocks[indexPath.item].title
        cell.descriptionLabel.text = visibleBlocks[indexPath.item].description
        cell.priceLabel.text = visibleBlocks[indexPath.item].price
        
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // при нажатии будет добавлять checkmark на ячейку CollectionViewCell
        // и меняется заголовок кнопки выбора опции в зависимости от налиция выбранной опции
        // если опции в итоге нет, 
        actionButton.setTitle(dataJSON?.result.selectedActionTitle, for: .normal)
        
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

