//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import Foundation
import GRDB

class Database {
    static let shared = Database()
    private let dataDbQueue: DatabaseQueue
    private let dbQueue: DatabaseQueue

    enum LoadingError: Error {
        case missingPath
    }
    
    init() {
        do {
            let databaseURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("db.sqlite")
            dbQueue = try DatabaseQueue(path: databaseURL.path)
            dataDbQueue = try DatabaseQueue(path: Bundle.main.path(forResource: "mhgu", ofType: "db")!)

            Log("User db: \(dbQueue.path)")
            Log("Data db: \(dataDbQueue.path)")

            // Need to fix this so it's only called on version update
            update()

            try dbQueue.inDatabase { db in
                try db.execute("ATTACH DATABASE ? AS database", arguments: [dataDbQueue.path])
            }
        } catch {
            fatalError("Could not load DB: \(error)")
        }
    }

    func write(_ sql: String, arguments: StatementArguments? = nil) {
        do {
            try dbQueue.write { db in
                try db.execute(sql, arguments: arguments)
            }
        } catch {
            Log(error: "\(error)")
        }
    }
    
    func fetch<T: RowConvertible>(_ query: String) -> T? {
        do {
            return try dbQueue.inDatabase { db in
                return try T.fetchOne(db, query)
            }
        } catch {
            return nil
        }
    }
    
    func fetch<T: RowConvertible>(_ query: String, params: [DatabaseValueConvertible?]? = nil) -> [T] {
        do {
            return try dbQueue.inDatabase { db in
                var arguments: StatementArguments? = nil
                if let params = params {
                    arguments = StatementArguments(params)
                }
                
                return try T.fetchAll(db, query, arguments: arguments, adapter: nil)
            }
        } catch let error as DatabaseError {
            print(error.description)
            
        } catch let error as NSError {
            print(error.description)
        }
        
        // Should this just fail?
        return [T]()
    }
    
    func getStrings(_ query: String, column: String = "value") -> [String] {
        // this implementation is silly
        RowString.column = column
        let rows = fetch(query) as [RowString]
      let values = rows.compactMap { $0.value }
        return values
    }
    
    func fetch<T: RowConvertible>(select: String, order: String? = nil, filter: String? = nil, search: String? = nil) -> [T] {
        var params = [DatabaseValueConvertible?]()
      
        let hasFilter = (filter?.count ?? 0) > 0
        var finalFilter = ""
        
        if hasFilter || search != nil {
            finalFilter += "WHERE "
        }
        
        if let filter = filter {
            finalFilter += filter
        }
        
        if let search = search, search.count > 0 {
            finalFilter += (hasFilter ? " AND " : "") + "name LIKE ?"
            params.append("%\(search)%")
        }
        
        let query = "\(select) \(finalFilter) \(order ?? "")"
        
        return fetch(query, params: params)
    }
}

class RowString: RowConvertible {
    static var column = "value"
    let value: String?
    required init(row: Row) {
        value = row[RowString.column]
    }
}

private class Version: RowConvertible {
    let version: Int
    required init(row: Row) {
        version = row["version"] ?? 0
    }
}
