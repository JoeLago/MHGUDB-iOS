//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit


extension DetailController {
    
    func getPushBlock<T>(_ vcBlock: ((T) -> UIViewController)?) -> ((T) -> Void)? {
        var pushBlock: ((T) -> Void)? = nil
        if let selectionBlock = vcBlock {
            pushBlock = { [unowned self] (model: T) in
                self.push(selectionBlock(model))
            }
        }
        return pushBlock
    }
    
    func addSimpleSection<T: DetailCellModel>(data: [T],
                          title: String? = nil,
                          isCollapsed: Bool = false,
                          selectionBlock: ((T) -> UIViewController)? = nil) {
        
        add(section: SimpleDetailSection(data: data, title: title, isCollapsed: isCollapsed, selectionBlock: getPushBlock(selectionBlock)))
    }
    
    func addCustomSection<T, U: CustomCell<T>>(data: [T],
                          cellType: U.Type,
                          selectionBlock: ((T) -> UIViewController)? = nil) {
        
        add(section: CustomSection<T, U>(title: nil, data: data, header: nil, selectionBlock: getPushBlock(selectionBlock)))
    }
    
    func addCustomSection<T, U: CustomCell<T>>(header: HeaderView,
                          data: [T],
                          cellType: U.Type,
                          selectionBlock: ((T) -> UIViewController)? = nil) {
        
        add(section: CustomSection<T, U>(title: nil, data: data, header: header, selectionBlock: getPushBlock(selectionBlock)))
    }
    
    @discardableResult
    func addCustomSection<T, U: CustomCell<T>>(title: String,
                          data: [T],
                          cellType: U.Type,
                          showCount: Bool = false,
                          selectionBlock: ((T) -> UIViewController)? = nil) -> CustomSection<T, U> {
        let section = CustomSection<T, U>(title: title, data: data, header: nil,
                                          selectionBlock: getPushBlock(selectionBlock))
        section.showCountMinRows = showCount ? 2 : -1
        add(section: section)
        return section
    }
}
