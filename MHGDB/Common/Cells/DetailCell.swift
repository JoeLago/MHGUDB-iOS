//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

protocol DetailCellModel {
    var primary: String? { get }
    var subtitle: String? { get }
    var secondary: String? { get }
    var icon: Icon? { get }
}

// So that implementation is only required for non nil fields
extension DetailCellModel {
    var primary: String? { return nil }
    var subtitle: String? { return nil }
    var secondary: String? { return nil }
    var icon: Icon? { return nil }
}

class DetailCell: UITableViewCell {
    static let identifier = "detailCell"
    
    var primaryTextLabel = UILabel()
    var subtitleTextLabel = UILabel()
    var secondaryTextLabel = UILabel()
    var iconImageView = UIImageView()
    var imageWidthConstraint: NSLayoutConstraint?
    
    var model: DetailCellModel? {
        didSet {
            populateCell()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: DetailCell.identifier)
        //selectionStyle = .none
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
    
    private func populateCell() {
        guard let model = model else {
            Log(error: "DetailCell model not set")
            return
        }

        setIcon(icon: model.icon)
        primaryTextLabel.text = model.primary
        subtitleTextLabel.text = model.subtitle
        secondaryTextLabel.text = model.secondary
    }
    
    func setIcon(icon: Icon?) {
        guard let icon = icon, var image = UIImage(named: icon.name) else {
            hideImage()
            return
        }

        if let tintColor = icon.color?.color {
            image = image.tint(tintColor)
        }

        iconImageView.image = image
        imageWidthConstraint?.constant = 40
    }
    
    func hideImage() {
        // TODO: Fix margins
        imageWidthConstraint?.constant = 0
    }
    
    func addViews() {
        contentView.addSubview(primaryTextLabel)
        contentView.addSubview(secondaryTextLabel)
        contentView.addSubview(subtitleTextLabel)
        contentView.addSubview(iconImageView)
        
        for view in contentView.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        subtitleTextLabel.font = Font.subTitle
        subtitleTextLabel.textColor = Color.Text.primary
        subtitleTextLabel.numberOfLines = 0
        
        secondaryTextLabel.font = Font.title
        secondaryTextLabel.textColor = Color.Text.secondary
        
        iconImageView.contentMode = .scaleAspectFit
        
        addConstraints()
    }
    
    // TODO: Secondary needs compression resistance!
    
    func addConstraints() {
        contentView.addConstraints(
            formatStrings: ["H:|-[image]-[primary]-(>=pad)-[secondary]-|",
                            "H:|-[image]-[subtitle]-(>=pad)-[secondary]-|",
                            "V:|-(pad)-[primary]-(textPad)-[subtitle]-(pad)-|",
                            "V:|-(>=pad)-[image(<=maxImageHeight)]-(>=pad)-|",
                            "V:|-(pad)-[secondary]-(pad)-|"],
            views: [
                "primary": primaryTextLabel,
                "secondary": secondaryTextLabel,
                "subtitle": subtitleTextLabel,
                "image": iconImageView
                ],
            metrics: [
                "maxImageHeight": 30, // Don't want this, should fit in less space than labels
                "textPad": 4,
                "pad": 6
            ])
        
        contentView.addConstraint(
            NSLayoutConstraint(item: iconImageView,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: contentView,
                               attribute: .centerY,
                               multiplier: 1.0,
                               constant: 0))
        
        imageWidthConstraint = NSLayoutConstraint(item: iconImageView,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: 0)
        addConstraint(imageWidthConstraint!)
    }
}
