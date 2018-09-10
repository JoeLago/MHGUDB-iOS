//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class ListGridCell: UICollectionViewCell {
    let label = UILabel()
    let icon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: SimpleCellModel? {
        didSet {
            if let model = model {
                icon.image = UIImage(named: model.imageName ?? "")
                label.text = model.text
            }
        }
    }
    
    func setupViews() {
        let stack = UIStackView(axis: .vertical, spacing: 5, distribution: .fill)
        
        icon.contentMode = .scaleAspectFit
        
        label.font = Font.header
        label.textAlignment = .center
        
        contentView.addSubview(stack)
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        
        icon.widthConstraint(100)
        icon.heightConstraint(100)
        stack.matchParent(top: 0, left: 0, bottom: 10, right: 0)
    }
}

class ListGrid: UICollectionViewController {
    private var cellModels = [SimpleCellModel]()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        super.init(collectionViewLayout: flowLayout)
        collectionView?.register(ListGridCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = Color.Background.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.reloadData()
    }
    
    func addCell(text: String?, imageName: String?, viewControllerBlock: @escaping () -> UIViewController) {
        cellModels.append(SimpleCellModel(text: text, imageName: imageName) {
            self.navigationController?.pushViewController(viewControllerBlock(), animated: true)
        })
    }
    
    func addCell(text: String?, imageName: String?, selectedBlock: @escaping () -> Void = {}) {
        cellModels.append(SimpleCellModel(text: text, imageName: imageName, selectedBlock: selectedBlock))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let cell = cell as? ListGridCell {
            cell.model = cellModels[indexPath.row]
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = cellModels[indexPath.row]
        model.selectedBlock()
    }
}
