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

    let stack = UIStackView(axis: .horizontal, spacing: 6, distribution: .fill)
    let detailStack = UIStackView(axis: .vertical, spacing: 4)
    var primaryTextLabel = UILabel()
    var subtitleTextLabel = UILabel()
    var secondaryTextLabel = UILabel()
    let imageWrapper = UIView()
    var iconImageView = UIImageView()
    var iconSizeConstraints = [NSLayoutConstraint]()

    var model: DetailCellModel? {
        didSet {
            populateCell()
        }
    }

    var shouldHideImage: Bool {
        didSet {
            imageWrapper.isHidden = shouldHideImage
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        shouldHideImage = false
        super.init(style: .default, reuseIdentifier: DetailCell.identifier)
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

        updateIcon()
        primaryTextLabel.text = model.primary
        subtitleTextLabel.text = model.subtitle
        secondaryTextLabel.text = model.secondary
        subtitleTextLabel.isHidden = model.subtitle == nil

        //stack.spacing = model.spacing
        //iconSizeConstraints.forEach { $0.constant = model.iconSize }
    }

    func updateIcon() {
        guard let image = model?.icon?.image else {
            shouldHideImage = true
            return
        }

        shouldHideImage = false
        iconImageView.image = image
    }

    // For later investigation, scrolling table shows too many blank images for too long
    func updateIconInBackground() {
        iconImageView.image = nil

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let icon = self?.model?.icon, let image = icon.image else {
                DispatchQueue.main.async { [weak self] in
                    self?.shouldHideImage = true
                }
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard self?.model?.icon == icon else { return }
                self?.shouldHideImage = false
                self?.iconImageView.image = image
            }
        }
    }

    func addViews() {
        addSubview(stack)
        imageWrapper.addSubview(iconImageView)
        stack.addArrangedSubview(imageWrapper)
        stack.addArrangedSubview(detailStack)
        stack.addArrangedSubview(secondaryTextLabel)
        detailStack.addArrangedSubview(primaryTextLabel)
        detailStack.addArrangedSubview(subtitleTextLabel)

        [imageWrapper, iconImageView, detailStack, subtitleTextLabel, primaryTextLabel, secondaryTextLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        subtitleTextLabel.font = Font.subTitle
        subtitleTextLabel.textColor = Color.Text.primary
        subtitleTextLabel.numberOfLines = 0
        secondaryTextLabel.font = Font.title
        secondaryTextLabel.textColor = Color.Text.secondary
        iconImageView.contentMode = .scaleAspectFit

        // Constraints

        stack.matchParent(top: 8, left: 12, bottom: 8, right: 16)
        iconImageView.matchParent(top: 0, left: 0, bottom: nil, right: 0)

        addConstraints([
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: imageWrapper.bottomAnchor)
            ].compactMap({ $0 }))

        iconSizeConstraints = [
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)]
        addConstraints(iconSizeConstraints)

        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        primaryTextLabel.setContentHuggingPriority(.required, for: .vertical)
        primaryTextLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        secondaryTextLabel.setContentHuggingPriority(.required, for: .horizontal)
        secondaryTextLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
