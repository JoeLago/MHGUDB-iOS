//
//  Int+TieInterval.swift
//  MHGDB
//
//  Created by Joe on 9/19/17.
//  Copyright © 2017 Gathering Hall Studios. All rights reserved.
//

import Foundation

extension Int {
    var seconds: TimeInterval {
        return TimeInterval(self)
    }
    
    var minutes: TimeInterval {
        return self.seconds * 60
    }
    
    var hours: TimeInterval {
        return self.minutes * 60
    }
    
    var days: TimeInterval {
        return self.hours * 24
    }
    
    var weeks: TimeInterval {
        return self.days * 7
    }
    
    var months: TimeInterval {
        return self.weeks * 4
    }
    
    var years: TimeInterval {
        return self.months * 12
    }
}
