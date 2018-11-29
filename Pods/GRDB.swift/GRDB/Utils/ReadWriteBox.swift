import Dispatch

/// A ReadWriteBox grants multiple readers and single-writer guarantees on a value.
final class ReadWriteBox<T> {
    var value: T {
        get { return read { $0 } }
        set { write { $0 = newValue } }
    }
    
    init(_ value: T) {
        self._value = value
        self.queue = DispatchQueue(label: "GRDB.ReadWriteBox", attributes: [.concurrent])
    }
    
    func read<U>(_ block: (T) throws -> U) rethrows -> U {
        return try queue.sync {
            try block(_value)
        }
    }
    
    func write<U>(_ block: (inout T) throws -> U) rethrows -> U {
        return try queue.sync(flags: [.barrier]) {
            try block(&_value)
        }
    }
    
    private var _value: T
    private var queue: DispatchQueue
}

extension ReadWriteBox where T: Numeric {
    func increment() -> T {
        return write { n in
            n += 1
            return n
        }
    }
}
