//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

class QuestList: DetailController {
    var hubButton: UIBarButtonItem?
    var hubAlert: UIAlertController!
    var keyQuestButton: UIBarButtonItem!
    var onlyKeyQuests = false
    var hub = "Village" // Should we make this an enum?
    
    override init() {
        super.init()
        title = "Quests"
        setupKeyToggle()
        populateSections()
        isToolBarHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't want to use storyboards Apple")
    }
    
    override func loadView() {
        super.loadView()
        
        hubButton = addButton(
            title: "Village", options: database.questHubs(),
            selected: { [unowned self] (index: Int, value: String) in
                if self.onlyKeyQuests {
                    self.toggleKeyQuests()
                }
                self.hubButton!.title = value
                self.hub = value
                self.populateSections()
        })
        
        let flexibleSpace = UIBarButtonItem.flexible()
        toolbarItems = [hubButton!, flexibleSpace, keyQuestButton]
    }
    
    override func reloadData() {
        tableView.reloadData()
    }
    
    func populateSections() {
        sections.removeAll()
        
        let quests = database.quests(keyOnly: onlyKeyQuests, hub: hub)
        for questsPerStar in quests {
            let title = Quest.titleForStars(count: (questsPerStar.first?.stars ?? 0))
            let questSection = SimpleDetailSection(
                data: questsPerStar, title: title, defaultCollapseCount: 0,
                selectionBlock: { [unowned self] (model: DetailCellModel) in
                    self.push(QuestDetails(quest: model as! Quest))
            })
            add(section: questSection)
        }
        
        reloadData()
    }
    
    // MARK - Key Button
    
    func setupKeyToggle() {
        keyQuestButton = UIBarButtonItem(title: "Key Quests", style: .done,
                                         target: self, action: #selector(toggleKeyQuests))
        keyQuestButton.style = onlyKeyQuests ? .done : .plain
    }
    
    @objc func toggleKeyQuests() {
        onlyKeyQuests = !onlyKeyQuests
        keyQuestButton.style = onlyKeyQuests ? .done : .plain
        populateSections()
    }
}

extension Quest: DetailCellModel {
    //var primary: String? { return "\(id ?? 0): \(name ?? "")" }
    var primary: String? { return name }
    var subtitle: String? { return goal }
    var secondary: String? { return progression?.text == "Normal" ? "" : progression?.text }
}
