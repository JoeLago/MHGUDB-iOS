//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class WeaponView: TreeCellView<Weapon> {
    var primaryTextLabel = UILabel()
    var subtitleTextLabel = UILabel()
    var sharpnessesView = SharpnesesView()
    var slotsLabel = UILabel()
    var alternateLabel = UILabel()
    
    var weapon: Weapon! {
        didSet {
            populateCell()
        }
    }
    
    override var model: Weapon? {
        get { return weapon }
        set { weapon = newValue! }
    }
    
    override var isSelected: Bool {
        didSet {
            populateSelected()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func populateCell() {
        primaryTextLabel.text = weapon.name
        sharpnessesView.sharpnesses = weapon.sharpnesses
        populateAttack()
        populateSlots()
        populateAlternate()
    }
    
    private func populateSelected() {
        primaryTextLabel.font = isSelected ? Font.titleBold : Font.title
    }
    
    private func populateAlternate() {
//        if let notes = weapon.noteImageNames {
//            alternateLabel.attributedText = notes.map { $0.attributedImage }.joined(separator: " ")
//        }
//        
//        if let vials = weapon.coatingImageNames {
//            alternateLabel.attributedText = vials.map { $0.attributedImage }.joined(separator: " ")
//        }
    }
    
    private func populateSlots() {
        var slotsString = ""
        var slots = weapon.numSlots ?? 0
        for _ in 0...2 {
            if slots > 0 {
                slotsString += "O"
                slots -= 1
            } else {
                slotsString += "-"
            }
        }
        
        self.slotsLabel.text = slotsString
    }
    
    private func populateAttack() {
        let attack = NSMutableAttributedString()
        attack.append(string: "\(weapon.attack ?? 0) ")

        if let elementAttack = weapon.elementAttack, elementAttack > 0 {
            attack.appendImage(named: (weapon.element?.rawValue ?? "") + ".png")
            attack.append(string: " \(elementAttack)")
        }

        if let element2Attack = weapon.element2Attack, element2Attack > 0 {
            attack.appendImage(named: (weapon.element?.rawValue ?? "") + ".png")
            attack.append(string: " \(element2Attack)")
        }
        
        if weapon.awakenAttack ?? 0 > 0 {
            attack.appendImage(named: (weapon.awakenElement?.rawValue ?? "") + ".png")
            attack.append(string: " \(weapon.awakenAttack ?? 0)")
        }

        if let affinity = weapon.affinity, affinity != 0 {
            attack.append(string: " \(affinity > 0 ? "+" : "")\(affinity)%")
        }

        if let defense = weapon.defense, defense > 0 {
            attack.append(string: " \(defense)def")
        }
        
        subtitleTextLabel.attributedText = attack;
    }
    
    func addViews() {
        addSubview(primaryTextLabel)
        addSubview(subtitleTextLabel)
        addSubview(sharpnessesView)
        addSubview(slotsLabel)
        //sharpnessesView.addSubview(alternateLabel)
        
        for view in subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        subtitleTextLabel.font = Font.subTitle
        
        // The text needs to be set or auto-layout doesn't work for some reason
        primaryTextLabel.text = "FIX ME"
        subtitleTextLabel.text = "FIX ME"
        
        slotsLabel.font = UIFont(name: "Courier", size: 14)
        slotsLabel.text = "OOO"
        
        addConstraints(
            formatStrings: ["H:|-[primary]-(>=pad)-[sharpness(==sharpnessWidth)]-|",
                            "H:|-[subtitle(==primary)]-(>=pad)-[slots(==sharpness)]-|",
                            "V:|-(smallPad)-[primary]-(smallPad)-[subtitle]-(smallPad)-|",
                            "V:|-(smallPad)-[sharpness(==sharpnessHeight)]-(slotsPad)-[slots]-(slotsPad)-|"],
            views: [
                "primary": primaryTextLabel,
                "subtitle": subtitleTextLabel,
                "sharpness": sharpnessesView,
                "slots": slotsLabel
            ],
            metrics: [
                "sharpnessWidth": 75,
                "sharpnessHeight": 23,
                "slotsPad": 3,
                "smallPad": 3,
                "pad": 6,
            ])
        
        //alternateLabel.matchParent()
    }
}
