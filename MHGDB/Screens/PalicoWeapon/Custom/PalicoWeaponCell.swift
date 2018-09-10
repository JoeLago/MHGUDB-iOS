//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class PalicoWeaponCell: CustomCell<PalicoWeapon> {
    static let identifier = String(describing: PalicoWeaponCell.self)
    
    let mainStack = UIStackView(axis: .horizontal, spacing: 8, distribution: .fill)
    let descriptionStack = UIStackView(axis: .vertical, spacing: 4)
    let detailsStack = UIStackView(axis: .vertical, spacing: 4)
    let titleStack = UIStackView(axis: .horizontal, spacing: 4)
    let iconView = UIImageView()
    let nameLabel = UILabel()
    let meleeLabel = UILabel()
    let rangedLabel = UILabel()
    let sharpnessView = SharpnessView()
    let balanceLabel = UILabel()
    
    override var model: PalicoWeapon? {
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
    
    private func populateCell(weapon: PalicoWeapon) {
        iconView.image = UIImage(named: weapon.icon ?? "")
        nameLabel.text = weapon.name
        
        let melee = NSMutableAttributedString(string: "Melee: ")
        melee.append(NSMutableAttributedString(damage: weapon.attackMelee,
                                               element: weapon.element,
                                               elementDamage: weapon.elementMelee,
                                               affinity: weapon.affinityMelee))
        meleeLabel.attributedText = melee
        
        let ranged = NSMutableAttributedString(string: "Ranged: ")
        ranged.append(NSMutableAttributedString(damage: weapon.attackRanged,
                                                element: weapon.element,
                                                elementDamage: weapon.elementRanged,
                                                affinity: weapon.affinityRanged))
        rangedLabel.attributedText = ranged
        
        sharpnessView.sharpness = weapon.sharpness
        
        balanceLabel.text = weapon.balance.string
        balanceLabel.textAlignment = .center
    }
    
    func addViews() {
        nameLabel.font = Font.titleMedium
        nameLabel.textColor = Color.Text.primary
        meleeLabel.font = Font.subTitle
        meleeLabel.textColor = Color.Text.primary
        rangedLabel.font = Font.subTitle
        rangedLabel.textColor = Color.Text.primary
        balanceLabel.font = Font.subTitle
        balanceLabel.textColor = Color.Text.secondary
        
        contentView.addSubview(mainStack)
        
        mainStack.addArrangedSubview(descriptionStack)
        mainStack.addArrangedSubview(detailsStack)
        
        descriptionStack.addArrangedSubview(titleStack)
        descriptionStack.addArrangedSubview(meleeLabel)
        descriptionStack.addArrangedSubview(rangedLabel)
        titleStack.addArrangedSubview(iconView)
        titleStack.addArrangedSubview(nameLabel)
        
        detailsStack.addArrangedSubview(sharpnessView)
        detailsStack.addArrangedSubview(balanceLabel)
        
        mainStack.matchParent(top: 6, left: 16, bottom: 6, right: 16)
        iconView.heightConstraint(30)
        iconView.widthConstraint(30)
        sharpnessView.heightConstraint(15)
        sharpnessView.widthConstraint(80)
    }
}
