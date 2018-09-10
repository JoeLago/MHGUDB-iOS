//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class MapCell: CustomCell<Location> {
    static let identifier = "mapCell"
    var mapImageView = UIImageView()
    
    override var model: Location? {
        didSet {
            if let model = model, let icon = model.icon {
                mapImageView.image = UIImage(named: icon)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MapCell.identifier)
        selectionStyle = .none
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        contentView.addSubview(mapImageView)
        mapImageView.contentMode = .scaleAspectFit
        mapImageView.matchParent(top: nil, left: 0, bottom: nil, right: 0)
        mapImageView.matchParent(top: 0, left: nil, bottom: 0, right: nil, relatedBy: .greaterThanOrEqual)
        NSLayoutConstraint(item: mapImageView, attribute: .height, relatedBy: .equal,
                           toItem: mapImageView, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }
}
