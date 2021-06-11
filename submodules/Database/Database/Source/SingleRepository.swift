import Core

open class SingleRepository<M> {
    @Atomic
    private var storage: AnyStorage<M>

    public init(storage: AnyStorage<M>) {
        self.storage = storage
    }
    
    open func mutateAndSave(_ mutation: (M?) -> M) {
        $storage.mutate { storage in
            let stateToMutate = storage.read()
            let newState = mutation(stateToMutate)
            storage.save(newState)
        }
    }
    
    open func save(_ model: M) {
        $storage.mutate { storage in
            storage.save(model)
        }
    }

    public func clear() {
        $storage.mutate { storage in
            storage.clear()
        }
    }

    public func item() -> M? {
        $storage.mutate { storage in
            storage.read()
        }
    }

    public func isEmpty() -> Bool {
        $storage.mutate { storage in
            storage.read() == nil
        }
    }
}
