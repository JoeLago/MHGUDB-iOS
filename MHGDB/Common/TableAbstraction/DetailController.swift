//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

protocol DetailScreen {
    var id: Int { get }
}

// TODO: This does more than just Details, used for lists, rename
class DetailController: UITableViewController {
    var database = Database()
    var sections = [DetailSection]()
    var isToolBarHidden = true
    var hackyButtonRetains = [Any]()
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(section: DetailSection) {
        section.index = sections.count
        sections.append(section)
        section.tableView = tableView // Commenting this line out doesn't break anything, why?!
    }
    
    override func loadView() {
        super.loadView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        // This makes collapse/expand animations very glitchy
        //tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        //tableView.estimatedSectionHeaderHeight = 100
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "home"), style: .plain, target: self, action: #selector(popToRoot))
        
        addLongPressGesture()
    }
    
    @objc func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let page = String.init(describing: type(of: self))
        if let ic = self as? DetailScreen {
            Log(page: page, event: "View", details: "\(ic.id)")
        } else {
            Log(page: page)
        }
        
        navigationController?.isToolbarHidden = isToolBarHidden
        
        // TODO: Shouldn't be here?
        for section in sections {
            section.initialize()
        }
    }
    
    func populateToolbarSegment(items: [String]) -> UISegmentedControl {
        let segment = UISegmentedControl(items: items)
        segment.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 30))
        segment.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        let segmentButton = UIBarButtonItem.init(customView: segment)
        let flexible = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([flexible, segmentButton, flexible], animated: false)
        return segment
    }
    
    func addButton(title: String, options: [String],
                   selected: (@escaping (Int, String) -> Void)) -> UIBarButtonItem {
        
        let manager = SelectionManager(title: title, options: options,
                                       parentController: self, selected: selected)
        hackyButtonRetains.append(manager)
        return manager.button
    }
    
    // Placeholder for segment action
    @objc func reloadData() {
        tableView.reloadData()
    }
}

// MARK - TableView Protocol

extension DetailController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.isCollapsed ? 0 : section.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sections[indexPath.section].cell(row: indexPath.row) ?? UITableViewCell()
        sections[indexPath.section].populate(cell: cell, row: indexPath.row)
        return cell
    }
    
    // TODO: Would rather populate here but Auto Layout not working right
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //sections[indexPath.section].populate(cell: cell, row: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].selected(row: indexPath.row, navigationController: navigationController)
    }
}

// MARK - Collapsabile Sections

extension DetailController: UIGestureRecognizerDelegate {
    
    func addLongPressGesture() {
        let lp = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        lp.minimumPressDuration = 0.3 // Seconds
        lp.delegate = self
        tableView.addGestureRecognizer(lp)
    }
    
    func sectionHasNoHeader(index: Int) -> Bool {
        let section = sections[index]
        return (section.headerView == nil && section.title == nil) || section.numberOfRows == 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHasNoHeader(index: section) ? 0 : 44
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionObject = sections[section]
        
        if sectionHasNoHeader(index: section) {
            return nil
        }
        
        let headerView = sectionObject.headerView ?? HeaderView()
        
        if sectionObject.headerView == nil {
            sectionObject.headerView = headerView
            headerView.text = sectionObject.title
            headerView.isCollapsed = sectionObject.isCollapsed
        }
        
        headerView.section = section
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        gestureRecognizer.delegate = self
        headerView.addGestureRecognizer(gestureRecognizer)
        
        return headerView
    }
    
    @objc func longPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point),
            gestureRecognizer.state == .began {
            //print("Long press on row \(indexPath.row)")
            longPress(indexPath: indexPath)
        }
    }
    
    func longPress(indexPath: IndexPath) {
        sections[indexPath.section].longPress(row: indexPath.row)
    }
    
    @objc func headerTapped(gestureRecognizer: UIGestureRecognizer) {
        if let headerView = gestureRecognizer.view as? HeaderView {
            let section = sections[headerView.section ?? 0]
            toggleSection(section)
            headerView.isCollapsed = section.isCollapsed
        }
    }
    
    func toggleSection(_ section: DetailSection) {
        section.isCollapsed = !section.isCollapsed
        let indexPaths = NSIndexPath.indexPathsFor(section: section.index ?? 0, startRow: 0, count: section.numberOfRows - 1)
        
        tableView.beginUpdates()
        if section.isCollapsed {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        tableView.endUpdates()
    }
}
