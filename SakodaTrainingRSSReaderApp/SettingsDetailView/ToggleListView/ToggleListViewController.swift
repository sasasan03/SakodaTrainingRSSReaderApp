//
//  ToggleListViewController.swift
//  SakodaTrainingRSSReaderApp
//
//  Created by sako0602 on 2024/08/09.
//

import UIKit

// MARK: - ViewController
class ToggleListViewController: UIViewController {
    
    private let repository = SomeListItemRepository()
    private var collectionView: UICollectionView!
//    private var dataSource: SomeCollectionViewDatasource!//🟥🟦
//    private var dataSource: UICollectionViewDiffableDataSource<Int, SomeItem.ID>!//🟨DiffableDataSource
    private var dataSource: UICollectionViewDiffableDataSource<SomeSection, SomeItem.ID>!//🟨🟨DiffableDataSourceで複数のセクション対応
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()//flowLayoutを使ってViewを作成することができる。FlowLayoutは縦・横方向のスクロールも可能
        )
        setupConstraints()// 制約をかけ、場所も指定する
//        dataSource = SomeCollectionViewDatasource(repository: repository)//🟥🟦１つのセクション
        dataSource = makeDataSource(for: collectionView,repository: repository)//🟨
        applySnapshot()//🟨
//        collectionView.dataSource = dataSource//🟥🟦
//        collectionView.reloadData()//🟥🟦
    }
}


extension ToggleListViewController {//🟨
    
    func makeDataSource(//🟨🟨複数のCellの登録
        for collectionView: UICollectionView,
        repository: SomeListItemRepository
    ) -> UICollectionViewDiffableDataSource<SomeSection,SomeItem.ID> { //🟪
        let mainCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell,SomeItem> { cell,indexPath,item in
            cell.contentConfiguration = MyContentConfiguration(name: item.name)
        }
        let secondaryCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell,SomeItem> { cell,indexPath,item in
            cell.contentConfiguration = MyContentConfiguration(name: item.name)
        }
        return UICollectionViewDiffableDataSource<SomeSection,SomeItem.ID>(
            collectionView: collectionView
        ) { [weak repository] collectionView, indexPath, id in
            let item = repository?.item(id: id)
            switch indexPath.section {
            case 0:
                return collectionView.dequeueConfiguredReusableCell(
                    using: mainCellRegistration,
                    for: indexPath,
                    item: item
                )
            case 1:
                return collectionView.dequeueConfiguredReusableCell(
                    using: secondaryCellRegistration, 
                    for: indexPath,
                    item: item
                )
            default: fatalError()
            }
        }
    }
    
    
//    func makeDataSource(//🟨🟨
//        for collectionView: UICollectionView,
//        repository: SomeListItemRepository
//    ) -> UICollectionViewDiffableDataSource<SomeSection, SomeItem.ID>  {
//        let cellRegstration = UICollectionView.CellRegistration<SomeCollectionViewCell,SomeItem> {
//            cell, indexPath, item in
//            cell.name = item.name
//        }
//        
//        return UICollectionViewDiffableDataSource<SomeSection, SomeItem.ID>(
//            collectionView: collectionView
//        ){
//            [weak repository] collectionView, indexPath, id in
//            let item = repository?.item(id: id)
//            return collectionView.dequeueConfiguredReusableCell(
//                using: cellRegstration,//セルの設定方法（たとえば、セルにどのデータを表示するかなど）を定義するためのもの
//                for: indexPath,//どの位置にこのセルが表示されるかを指定
//                item: item
//            )
//        }
//        
//    }
    
//    func makeDataSource( //🟨
//        for collectionView: UICollectionView,
//        repository: SomeListItemRepository
//    ) -> UICollectionViewDiffableDataSource<Int, SomeItem.ID> {
//        
//        let cellRegstration = UICollectionView.CellRegistration<SomeCollectionViewCell,SomeItem> {
//             cell, indexPath, item in
//            cell.name = item.name
//        }
//        
//        return UICollectionViewDiffableDataSource<Int, SomeItem.ID>(//『Int』はセクションを表す
//            collectionView: collectionView
//        ) {// 以下：cellに対して、ID検索し、一致したもの入れる
//            [weak repository] collectionView, indexPath, id in
//            let item = repository?.item(id: id)
//            return collectionView.dequeueConfiguredReusableCell(
//                using: cellRegstration,
//                for: indexPath,
//                item: item
//            )
//        }
//    }
    
}

extension ToggleListViewController {
    
//    private func applySnapshot(){// 🟨
//        var snapShot = NSDiffableDataSourceSnapshot<Int,SomeItem.ID>()
//        snapShot.appendSections([0])// セクションの識別子として『0』を追加し、このセクションに対してアイテムを設定する準備を行う。
//        snapShot.appendItems(repository.ids())// セクション 『0』 に対して、repository.ids() から取得したアイテムを追加する。
//        dataSource.apply(snapShot)
//    }

    private func applySnapshot(){// 🟨🟨
        var snapShot = NSDiffableDataSourceSnapshot<SomeSection,SomeItem.ID>()
        let sections = repository.sections()
        snapShot.appendSections(sections)
        sections.forEach { sectoin in
            snapShot.appendItems(repository.ids(in: sectoin), toSection: sectoin)
        }
        dataSource.apply(snapShot)
    }
    
}


extension ToggleListViewController {//🟥🟦🟨
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

// MARK: - ⭐️⭐️エンティティ⭐️⭐️
struct SomeItem: Identifiable {
    let id = UUID()// 🟨DiffableDataSourceから使用
    let name: String
    let isFavorite: Bool
}

// MARK: - ⭐️⭐️セクションのEnum

enum SomeSection: CaseIterable {
    case mian
    case secondary
}

// MARK: - ⭐️⭐️リポジトリー⭐️⭐️
final class SomeListItemRepository {
    
    private var items0 = (0..<30).map({
        SomeItem(
            name: "item num: \($0)",
            isFavorite: $0 % 2 != 0
        )
    })
    
    private var items1 = (0..<30).map({
        SomeItem(
            name: "fruits num ：\($0)",
            isFavorite: $0 % 2 == 0
        )
    })
    
    private var items: [SomeItem] { items0 + items1 }//🟨🟨
    
    func sections() -> [SomeSection] { //🟨🟨
        SomeSection.allCases
    }
    
    func ids(in section: SomeSection) -> [SomeItem.ID] {//🟨🟨
        switch section {
        case .mian:
            return items0.map({ $0.id })
        case .secondary:
            return items1.map({ $0.id })
        }
    }
    
    func item(id: SomeItem.ID) -> SomeItem? {//🟨🟨
        items.first{ $0.id == id }
    }
    
    //🟨 アイテムの数ではなく、IDの配列を返すようにする
//    func ids() -> [SomeItem.ID] {
//        items0.map({ $0.id })
//    }
    
    //🟨 アイテムをID検索で取得してくるようにする
//    func item(id: SomeItem.ID) -> SomeItem? {
//        items0.first { $0.id == id }
//    }
    
    //🟦複数セクションを扱う場合
//    func numberOfSection() -> Int { // 🟦
//        2
//    }
    //🟦
//    func numberOfItems(inSection section: Int) -> Int { // 🟦
//        switch section {
//        case 0: return items0.count
//        case 1: return items1.count
//        default: return 0
//        }
//    }
//    
//    //🟦
//    func item(at indexPath: IndexPath) -> SomeItem? { // 🟦
//        switch indexPath.section {
//        case 0: return items0[indexPath.item]
//        case 1: return items1[indexPath.item]
//        default: return nil
//        }
//    }
    // 🟥一つのセクションの場合に使用
//    func numberOfItems() -> Int { //🟥サンプルコード１で使用
//        items.count
//    }
    // 🟥
//    func item(at index: Int) -> SomeItem { //🟥サンプルコード１で使用
//        return items[index]
//    }
    
}


// MARK: - ⭐️⭐️データソース⭐️⭐️DifableDataSourceでは使用しない❌
//final class SomeCollectionViewDatasource: NSObject, UICollectionViewDataSource {//🟥🟦
//    
//    private weak var repository: SomeListItemRepository!
//    
//    init(repository: SomeListItemRepository!) {
//        self.repository = repository
//    }
////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>🟦複数セクション（セクションを縦に並べる）
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        repository.numberOfSection()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        repository.numberOfItems(inSection: section)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = repository.item(at: indexPath)
//        return collectionView.dequeueConfiguredReusableCell(
//            using: cellRegistration,
//            for: indexPath,
//            item: item
//        )
//    }
//
//        let cellRegistration = UICollectionView.CellRegistration<SomeCollectionViewCell,SomeItem>{ cell, index, item in
//            cell.name = item.name
//            if index.item % 2 == 0 {
//                cell.backgroundColor = .green
//            } else {
//                cell.backgroundColor = .white
//            }
//            if item.isFavorite {
//                cell.icon = "figure.baseball"
//            } else {
//                cell.icon = "apple.meditate"
//            }
//        }
//    
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>🟥一つのセクション
    // リポジトリーが保持するItemの数を返す
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        repository.numberOfItems()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // indexPath.item：コレクションビュー内で『特定のセクション』の『特定のアイテム』を指すインデックス
//        let item = repository.item(at: indexPath.item)
//        return collectionView.dequeueConfiguredReusableCell( // 設定されたCellを取り出す。
//            using: cellRegistration, //cellRegistrationで設定されたLayout情報を設定する。
//            for: indexPath,
//            item: item
//        )
//    }
//    dataSourceの初期化で値を代入するパターン cell.set(with:~~)
                          // セルの外観や動作を設定          （<>内）セルのクラスとそのセルにバインドするデータ型
//    let cellRegistration = UICollectionView.CellRegistration<SomeCollectionViewCell,SomeItem>{ cell, index, item in
//        cell.name = item.name// SomeCollectionViewCellのプロパティを指す
//        // index：セルの位置に応じて異なる処理を行う
//        if index.item % 2 == 0 { //indexに応じて、cellの背景色を変更する。
//            cell.backgroundColor = .green
//        } else {
//            cell.backgroundColor = .white
//        }
//        // item：データモデルに含まれるプロパティを使ってセルの内容を設定
//        if item.isFavorit {
//            cell.icon = "figure.baseball"
//        } else {
//            cell.icon = "apple.meditate"
//        }
//    }
//    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>🟥一つのセクション
//}

//MARK: - ⭐️⭐️セル⭐️⭐️
final class SomeCollectionViewCell: UICollectionViewCell {
    
    private let nameLabel = UILabel()
    private var iconImage = UIImageView()
    
    // nameに変更を検知し、nameLabelへnameの値を代入する
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    // iconの変更を検知し、UIImageのnamedへ代入する
    var icon: String = "" {
        didSet {
            iconImage.image = UIImage(systemName: icon)
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
    
    //セルが再利用される直前に、セルの状態を初期化するために使われる。
    //この初期化により、セルが再利用される際に、前のデータが残ったまま表示されることを防ぐ。
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


//MARK: - ⭐️⭐️ContentConfiguration⭐️⭐️🟪
//UICollectionViewCellをそのまま使用。サブクラス化は不要。UICollectionViewCell自身がUIContentConfigurationの仕組みに対応しています

// DataSourceからCellに渡したい情報を保持している
struct MyContentConfiguration: UIContentConfiguration {//🟪
    let name: String
    
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell,SomeItem> { cell, indexPath, item in
        cell.contentConfiguration = MyContentConfiguration(name: item.name)//MyContentConfiguration のインスタンスをセット。
    }
    
    // このメソッドがUICollectionViewCellのcontentViewとなる
    func makeContentView() -> any UIView & UIContentView {
        MyContentView(configuration: self)//下
    }
    
    func updated(for state: any UIConfigurationState) -> MyContentConfiguration {
        self//セルの状態（選択された状態、ハイライトされた状態など）に基づいて、コンテンツ構成を更新するために使用されます。
    }
    
}


struct MySecondaryContentConfiguration: UIContentConfiguration {
    
    let name2: String
    
    private let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell,SomeItem> { cell, indexPath, item in
        cell.contentConfiguration = MyContentConfiguration(name: item.name)//MyContentConfiguration のインスタンスをセット。
    }
    
    // このメソッドがUICollectionViewCellのcontentViewとなる
    func makeContentView() -> any UIView & UIContentView {
        MyContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> MySecondaryContentConfiguration {
        self//セルの状態（選択された状態、ハイライトされた状態など）に基づいて、コンテンツ構成を更新するために使用されます。
    }
    
}



//UIView：MyContentViewはUIViewのサブクラス
//UIContentView：DataSourceからconfigurationインスタンスとして表示データが渡され、それをビューに反映することがに期待されている
final class MyContentView: UIView, UIContentView {//🟪
    
    private let nameLabel = UILabel()
    
    var configuration: UIContentConfiguration {//🍔stubとして持つことを強要される
        didSet {
            guard let configuration = configuration as? MyContentConfiguration else { return }
            nameLabel.text = configuration.name
        }
    }
    
    init(configuration: UIContentConfiguration) {//🟨UIContentConfigurationプロトコル型にして差し替え可能
        self.configuration = configuration
        super.init(frame: .zero)
        setupConstraints()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented") }
    
    private func setupConstraints() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
