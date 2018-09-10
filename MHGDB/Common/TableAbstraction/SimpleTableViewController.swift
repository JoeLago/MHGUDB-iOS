//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit


class SimpleCellModel {
    var text: String?
    var imageName: String?
    var selectedBlock: () -> Void = {}
    
    init(text: String?, imageName: String?, selectedBlock: @escaping () -> Void = {}) {
        self.text = text
        self.imageName = imageName
        self.selectedBlock = selectedBlock
    }
}

class SimpleTableViewController: UITableViewController {
    private var cellModels = [SimpleCellModel]()
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCell(text: String?, imageName: String?, viewControllerBlock: @escaping () -> UIViewController) {
        cellModels.append(SimpleCellModel(text: text, imageName: imageName) {
            self.push(viewController: viewControllerBlock())
        })
    }
    
    func addCell(text: String?, imageName: String?, selectedBlock: @escaping () -> Void = {}) {
        cellModels.append(SimpleCellModel(text: text,
                                          imageName: imageName,
                                          selectedBlock: selectedBlock))
    }
    
    func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    public override func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    public override func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "defaultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = cellModels[indexPath.row]
        cell.imageView?.image = UIImage(named: cellModel.imageName ?? "")
        cell.textLabel?.text = cellModel.text ?? ""
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = cellModels[indexPath.row]
        cellModel.selectedBlock()
    }
}
