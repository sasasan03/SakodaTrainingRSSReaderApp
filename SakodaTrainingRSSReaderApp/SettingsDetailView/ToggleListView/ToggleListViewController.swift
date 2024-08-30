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
    private var dataSource: SomeCollectionViewDatasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
        
        setupConstraints()
        
        dataSource = SomeCollectionViewDatasource(repository: repository)
        
        collectionView.dataSource = dataSource
        collectionView.reloadData()
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
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


struct SomeItem {
    let name: String
    let isFavorit: Bool
}

final class SomeListItemRepository {
    
    private var items = (0..<30).map({
        SomeItem(
            name: "item num: \($0)",
            isFavorit: $0 % 2 != 0
            )
    })
    
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
    
    //リポジトリーが保持するItemの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        repository.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //indexPath.item：コレクションビュー内で『特定のセクション』の『特定のアイテム』を指すインデックス
        let item = repository.item(at: indexPath.item)
        return collectionView.dequeueConfiguredReusableCell(
            using: cellRegistration,
            for: indexPath,
            item: item
        )
    }
                            //セルの外観や動作を設定           （<>内）セルのクラスとそのセルにバインドするデータ型
    let cellRegistration = UICollectionView.CellRegistration<SomeCollectionViewCell,SomeItem>{ cell, index, item in
        cell.name = item.name//SomeCollectionViewCellのプロパティを指す
        //index：セルの位置に応じて異なる処理を行う
        if index.item % 2 == 0 { //indexに応じて、cellの背景色を変更する。
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .white
        }
        //item：データモデルに含まれるプロパティを使ってセルの内容を設定
        if item.isFavorit {
            cell.icon = "car"
        } else {
            cell.icon = "apple.meditate"
        }
    }
}


final class SomeCollectionViewCell: UICollectionViewCell {
    
    private let nameLabel = UILabel()
    private var iconImage = UIImageView()
    
    //nameに変更を加えたタイミングでLabelへ値が代入する
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    // iconの変更を検知し、UIImageのnamedへ代入する
    var icon: String = "" {
        didSet {
            iconImage.image = UIImage(systemName: icon )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconImage.contentMode = .scaleAspectFit
        setupConstraints()
    }
    
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name = nil
    }
    
    // 制約を設定。nameとiconの位置を調整
    private func setupConstraints(){
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconImage)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                // nameLabel の制約
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: -8),
                // iconImage の制約
                iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                iconImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                iconImage.widthAnchor.constraint(equalToConstant: 24),
                iconImage.heightAnchor.constraint(equalToConstant: 24)
            ]
        )
    }
    
}
