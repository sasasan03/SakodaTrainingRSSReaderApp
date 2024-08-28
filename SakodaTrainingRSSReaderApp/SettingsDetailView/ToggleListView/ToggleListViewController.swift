//
//  ToggleListViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/09.
//

import UIKit

class ToggleListViewController: UIViewController {

    
    private let repository = SomeListItemRepository()
    private var collectionView: UICollectionView!
//    private var dataSource =
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ToggleListViewController {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        //Itemの高さ44P、幅横幅いっぱい
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        //Layoutに表示するItemを設定する
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //Groupの高さ44P、横幅幅いっぱ
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        
        //アイテムを垂直方向に並べるグループを作成する
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,//グループ全体のサイズを指定
            subitems: [item]//そのグループ内に配置するアイテム（item）を指定
        )
        
        //コレクションビュー全体のセクションを定義
        //セクションには、1つ以上のグループを含むことが可能
        let section = NSCollectionLayoutSection(group: group)//垂直方向
        return UICollectionViewCompositionalLayout(section: section)//１つのグループを持つ
    }
}


struct SomeItem {
    let name: String
}

final class SomeListItemRepository {
    
    private var items = (0..<30).map({ SomeItem(name: "item num: \($0)") })
    
    func numberOfItems() -> Int {
        items.count
    }
    
    func item(at index: Int) -> SomeItem {
        return items[index]
    }
    
}

final class SomeCollectionViewDatasource: NSObject, UICollectionViewDataSource {
    
    private weak var repository: SomeListItemRepository!
    
    init(repository: SomeListItemRepository!) {
        self.repository = repository
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        repository.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = repository.item(at: indexPath.item)
        return collectionView.dequeueConfiguredReusableSupplementary(
//            using: ,
//            for:
        )
    }
    
    
}
