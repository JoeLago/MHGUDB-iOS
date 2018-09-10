//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

protocol ImageLabelCellProtocol {
    var label: String? { get }
    var values: [ImageLabelModel] { get }
}

struct ImageLabelModel {
    let imageName: String
    let value: Int?
    let doShowValue: Bool
    
    init(_ imageName: String, _ value: Int? = nil, doShowValue: Bool = true) {
        self.imageName = imageName
        self.value = value
        self.doShowValue = doShowValue
    }
}

class ImageLabelCellModel: ImageLabelCellProtocol {
    var label: String?
    var values: [ImageLabelModel]
    
    init(values: [ImageLabelModel], label: String? = nil) {
        self.label = label
        self.values = values
    }
}

class ImageLabelCell<T: ImageLabelCellProtocol>: CustomCell<T> {
    let imgDim: CGFloat = 15
    let stateFontSize: CGFloat = 16
    let valueFontSize: CGFloat = 12
    
    var labelText: String?
    var attributedText = NSMutableAttributedString()
    var stateLabel = UILabel()
    var valuesLabel = UILabel()
    var doIncludeState = true
    
    var imageLabelCellModel: T? {
        didSet {
            populateCell()
        }
    }
    
    override var model: T? {
        set { imageLabelCellModel = newValue }
        get { return imageLabelCellModel }
    }
    
    init(model: T?) {
        super.init(style: .default, reuseIdentifier: String(describing: ImageLabelCell.self))
        imageLabelCellModel = model
        selectionStyle = .none
        populateCell()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: String(describing: ImageLabelCell.self))
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeViews() {
        let rows = UIStackView(axis: .vertical, spacing: 8)
        contentView.addSubview(rows)
        if (doIncludeState) {
            rows.addArrangedSubview(stateLabel)
        }
        rows.addArrangedSubview(valuesLabel)
        
        stateLabel.font = UIFont.systemFont(ofSize: stateFontSize)
        stateLabel.textColor = Color.Text.primary
        
        rows.matchParent(top: 8, left: 25, bottom: 8, right: 25)
        
        valuesLabel.numberOfLines = 0
        valuesLabel.font = UIFont.systemFont(ofSize: valueFontSize)
        
        contentView.useConstraintsOnly()
    }
    
    func populateCell() {
        if let imageLabelCellModel = imageLabelCellModel {
            doIncludeState = (imageLabelCellModel.label != nil)
        }
        
        initializeViews()
        
        if let imageLabelCellModel = imageLabelCellModel {
            stateLabel.text = imageLabelCellModel.label
            imageLabelCellModel.values.forEach { (model: ImageLabelModel) in
                if model.doShowValue {
                    addNonZeroImageValue(imageName: model.imageName, value: model.value)
                } else {
                    addImageValue(imageName: model.imageName)
                }
            }
        }
    }
    
    func addNonZeroImageValue(imageName: String, value: Int?) {
        if let value = value, value != 0 {
            addImageValue(imageName: imageName, value: value)
        } else if value == nil {
            addImageValue(imageName: imageName)
        }
    }
    
    func addImageValue(imageName: String, value: Int? = nil) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: 0, y: -(imgDim/4), width: imgDim, height: imgDim)
        attributedText.append(NSAttributedString(attachment: attachment))
        
        if let value = value {
            attributedText.append(string: "\(value)")
        }
        
        attributedText.append(string: "  ")
        
        valuesLabel.attributedText = attributedText
    }
}
