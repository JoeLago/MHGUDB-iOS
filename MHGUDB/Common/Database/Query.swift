//
//  Query.swift
//  MHGDB
//
//  Created by Joe on 5/6/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import Foundation

// Not very intuitive, could use some thought

class Query {
    struct Join {
        let originTable: String
        let originAttribute: String
        let joinTable: String
        let joinTableAs: String?
        let joinAttribute: String

        var query: String {
            let join = "LEFT JOIN \(joinTable)"
            let joinAs = joinTableAs.map { "AS \($0)" } ?? nil
            let joinOn = "ON \(originTable).\(originAttribute) = \(joinAttribute)"
            return [join, joinAs, joinOn].compactMap({ $0 }).joined(separator: " ")
        }
    }

    struct Order {
        enum Direction {
            case asc, dec
        }
        let attribute: String
        let direction: Direction

        var query: String {
            return "\(attribute) \(direction == .asc ? "ASC" : "DESC")"
        }
    }

    struct OrFilter {
        let filters: [Filter]

        var query: String {
            return filters.map({ $0.query }).joined(separator: " OR ")
        }
    }

    struct Filter {
        let attribute: String
        let value: Any
        let comparison: Comparison

        enum Comparison {
            case equal, like, notLike
        }

        var query: String {
            switch (value, comparison) {
            case is (Int, Comparison): return "\(attribute) = \(value)"
            case (_, .like): return "\(attribute) LIKE '%\(value)%'"
            case (_, .notLike): return "\(attribute) NOT LIKE '%\(value)%'"
            default: return "\(attribute) = '\(value)'"
            }
        }

        init(attribute: String, value: Any, comparison: Comparison = .equal) {
            self.attribute = attribute
            self.value = value
            self.comparison = comparison
        }
    }

    struct Column {
        let column: String
        let assign: String?

        var query: String {
            return [column, assign].compactMap({ $0 }).joined(separator: " AS ")
        }
    }

    var table: String
    var columns = [Column]()
    var joins = [Join]()
    var orders = [Order]()
    var filters = [Filter]()
    var orFilters = [OrFilter]()

    var query: String {

        var columnQuery = "*"
        if columns.count > 0 {
            columnQuery = "*, " + columns.map({ $0.query }).joined(separator: ", ")
        }

        let action = "SELECT \(columnQuery) FROM \(table)"
        let join = joins.map({ $0.query }).joined(separator: " ")

        var filter = ""
        if filters.count > 0 || orFilters.count > 0 {
            let allFitlers = filters.map({ $0.query }) + orFilters.map({ $0.query })
            filter = "WHERE " + allFitlers.joined(separator: " AND ")
        }

        var order = "" // nil?
        if orders.count > 0 {
            order = "ORDER BY " + orders.map({ $0.query }).joined(separator: ", ")
        }

        let parts = [action, join, filter, order]
        let query = parts.joined(separator: " ")
        return query
    }

    static var languageId = "en"

    init(table: String, language: Filter? = nil) {
        self.table = table
    }

    init(table: String, addLanguageFilter: Bool) {
        self.table = table
    }

    @discardableResult
    func column(_ column: String, as assign: String? = nil) -> Query {
        columns.append(Column(column: column, assign: assign))
        return self
    }

    @discardableResult
    func join(origin: String, table: String, as named: String? = nil, on: String = "_id", equals: String? = nil, addLanguageFilter: Bool = false) -> Query {
        let joinAttribute = equals ?? named.map { "\($0)._id" } ?? "\(table)._id"
        joins.append(Join(originTable: origin, originAttribute: on, joinTable: table, joinTableAs: named, joinAttribute: joinAttribute))
        return self
    }

    @discardableResult
    func join(table: String, as named: String? = nil, on: String = "_id", equals: String? = nil, addLanguageFilter: Bool = false) -> Query {
        let joinAttribute = equals ?? named.map { "\($0)._id" } ?? "\(table)._id"
        joins.append(Join(originTable: self.table, originAttribute: on, joinTable: table, joinTableAs: named, joinAttribute: joinAttribute))
        return self
    }

    @discardableResult
    func orFilter(_ filters: [Filter]) -> Query {
        orFilters.append(OrFilter(filters: filters))
        return self
    }

    @discardableResult
    func filter(_ attribute: String, equals value: Any) -> Query {
        filters.append(Filter(attribute: attribute, value: value, comparison: .equal))
        return self
    }

    @discardableResult
    func filter(_ attribute: String, contains value: Any) -> Query {
        filters.append(Filter(attribute: attribute, value: value, comparison: .like))
        return self
    }

    @discardableResult
    func filter(_ attribute: String, is comparison: Filter.Comparison, value: Any) -> Query {
        filters.append(Filter(attribute: attribute, value: value, comparison: comparison))
        return self
    }

    @discardableResult
    func filter(id: Any) -> Query {
        filters.append(Filter(attribute: "\(table)._id", value: id, comparison: .equal))
        return self
    }

    @discardableResult
    func order(by attribute: String, direction: Order.Direction = .asc) -> Query {
        orders.append(Order(attribute: attribute, direction: direction))
        return self
    }
}
