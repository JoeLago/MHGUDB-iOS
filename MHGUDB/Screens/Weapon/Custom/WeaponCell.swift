//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class WeaponCell: CustomCell<Weapon> {
    static let identifier = String(describing: WeaponCell.self)
    let view = WeaponView()
    
    override var model: Weapon? {
        didSet {
            if let model = model {
                populateCell(weapon: model)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func populateCell(weapon: Weapon) {
        view.weapon = weapon
    }
    
    func addViews() {
        contentView.addSubview(view)
        view.matchParent(top: 4, left: 8, bottom: 4, right: 8)
    }
}
