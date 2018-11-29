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
    let icon: Icon
    let value: Int?
    let doShowValue: Bool
    
    init(_ imageName: String, value: Int? = nil, doShowValue: Bool = true) {
        self.init(icon: Icon(name: imageName), value: value, doShowValue: doShowValue)
    }

    init(icon: Icon, value: Int? = nil, doShowValue: Bool = true) {
        self.icon = icon
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
    let imgDim: CGFloat = 20
    let stateFontSize: CGFloat = 16
    let valueFontSize: CGFloat = 14
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
                    addNonZeroImageValue(icon: model.icon, value: model.value)
                } else {
                    addImageValue(icon: model.icon)
                }
            }
        }
    }
    
    func addNonZeroImageValue(icon: Icon, value: Int?) {
        if let value = value, value != 0 {
            addImageValue(icon: icon, value: value)
        } else if value == nil {
            addImageValue(icon: icon)
        }
    }
    
    func addImageValue(icon: Icon, value: Int? = nil) {
        if let attachment = textAttachment(icon: icon, width: imgDim, height: imgDim, fontSize: valueFontSize) {
            attributedText.append(NSAttributedString(attachment: attachment))
        }
        
        if let value = value {
            attributedText.append(string: "\(value)")
        }
        
        attributedText.append(string: "  ")
        
        valuesLabel.attributedText = attributedText
    }

    func textAttachment(icon: Icon, width: CGFloat, height: CGFloat, fontSize: CGFloat) -> NSTextAttachment? {
        guard let image = icon.image else { return nil }
        let font = UIFont.systemFont(ofSize: fontSize)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let mid = font.descender + font.capHeight
        textAttachment.bounds = CGRect(x: 0, y: font.descender - height / 2 + mid + 2, width: width, height: height).integral
        return textAttachment
    }
}
