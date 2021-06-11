import Core

public protocol DIdentifiable: Hashable {
    associatedtype Id: Hashable
    var id: Id { get }
}

public extension DIdentifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public protocol DSortable {
    static var sorting: (Self, Self) -> Bool { get }
}

public typealias RepositoryItem = DIdentifiable & DSortable

public enum RepositoryError: Swift.Error {
    case objectNotFound
}

public protocol RepositoryProtocol {
    associatedtype M: RepositoryItem

    func find(by id: M.Id) -> M?
    func findAll() -> [M]
    func contains(id: M.Id) -> Bool

    func append(_ model: M)
    func append(_ models: [M])
    func replace(_ models: [M])

    func remove(_ model: M)
    func remove(_ models: [M])
    func removeAll()

    func isEmpty() -> Bool
    func count() -> Int
}

open class CollectionRepository<M>: RepositoryProtocol where M: RepositoryItem {
    
    @Atomic // access to repository can by from multiple threads, as a result we can get a crash. 
    private var storage: AnyStorage<[M]>

    public init(storage: AnyStorage<[M]>) {
        self.storage = storage
    }

    // MARK: - Search
    public func find(by id: M.Id) -> M? {
        $storage.mutate { (storage) in
            Func.find(by: id, in: storage)
        }
    }

    open func findAll() -> [M] {
        $storage.mutate { (storage) in
            storage.read() ?? []
        }
    }
    
    public func contains(id: M.Id) -> Bool {
        $storage.mutate { (storage) in
            Func.contains(id: id, in: storage)
        }
    }

    // MARK: Insert
    public func append(_ model: M) {
        append([model])
    }

    public func append(_ models: [M]) {
        $storage.mutate { (storage) in
            Func.append(models, to: storage)
        }
    }
    
    public func insert(_ model: M) {
        $storage.mutate { (storage) in
            if Func.contains(id: model.id, in: storage) {
                Func.replace([model], to: storage)
            } else {
                Func.append([model], to: storage)
            }
            
        }
    }

    public func replace(_ model: M) {
        $storage.mutate { storage in
            Func.replace([model], to: storage)
        }
    }

    public func replace(_ models: [M]) {
        $storage.mutate { (storage) in
            storage.clear()
            Func.append(models, to: storage)
        }
    }

    // MARK: Remove
    public func remove(_ modelsToRemove: [M]) {
        $storage.mutate { (storage) in
            Func.remove(modelsToRemove, from: storage)
        }
    }

    public func remove(_ model: M) {
        remove([model])
    }

    public func removeAll() {
        $storage.mutate { (storage) in
            storage.clear()
        }
    }

    // MARK: - Count
    public func isEmpty() -> Bool {
        return $storage.mutate { (storage) in
            // Can be optimized, calculate on insert
            return Func.count(in: storage) == 0
        }
    }

    public func count() -> Int {
        return $storage.mutate { (storage) in
            // Can be optimized, calculate on insert
            return Func.count(in: storage)
        }
    }

    ///  Incapsulate logic from access to storage. As a result, repository becomes simple proxy
    internal struct Func {
        static func remove(_ modelsToRemove: [M], from storage: AnyStorage<[M]>) {
            var items = itemsArray(in: storage)

            modelsToRemove.forEach { item in
                guard let index = items.firstIndex(of: item) else { return }
                items.remove(at: index)
            }

            storage.save(items)
        }

        static func itemsArray(in storage: AnyStorage<[M]>) -> [M] {
            storage.read() ?? []
        }

        static func append(_ models: [M], to storage: AnyStorage<[M]>) {
            let uniqueItems = Set(itemsArray(in: storage) + models)
            let sortedItems = Array(uniqueItems).sorted(by: M.sorting)

            storage.save(sortedItems)
        }

        static func replace(_ modelsToReplace: [M], to storage: AnyStorage<[M]>) {
            let uniqueItems = Set(self.itemsArray(in: storage))
            var uniqueItemsDictionary = Dictionary(grouping: uniqueItems,
                                                   by: { item in item.id })
            modelsToReplace.forEach { model in
                uniqueItemsDictionary[model.id] = [model]
            }
            let sortedItems = Array(uniqueItemsDictionary.values.flatMap { $0 })
                .sorted(by: M.sorting)

            storage.save(sortedItems)
        }

        static func find(by id: M.Id, in storage: AnyStorage<[M]>) -> M? {
            itemsArray(in: storage)
                .first(where: { $0.id == id })
        }
        
        static func contains(id: M.Id, in storage: AnyStorage<[M]>) -> Bool {
            Func.find(by: id, in: storage) != nil
        }

        static func count(in storage: AnyStorage<[M]>) -> Int {
            itemsArray(in: storage).count
        }
    }
}
