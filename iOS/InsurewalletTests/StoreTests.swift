import XCTest
@testable import Insurewallet

@MainActor
final class StoreTests: XCTestCase {
    func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        let ok = store.add(InsurewalletEntry(title: "Test"))
        XCTAssertTrue(ok)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddFailsAtFreeLimit() {
        let store = Store()
        while store.entries.count < Store.freeLimit {
            _ = store.add(InsurewalletEntry(title: "Filler"))
        }
        let result = store.add(InsurewalletEntry(title: "Overflow"))
        XCTAssertFalse(result)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        _ = store.add(InsurewalletEntry(title: "ToDelete"))
        guard let entry = store.entries.first(where: { $0.title == "ToDelete" }) else {
            return XCTFail("entry not found")
        }
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testUpdateChangesTitle() {
        let store = Store()
        _ = store.add(InsurewalletEntry(title: "Original"))
        guard var entry = store.entries.first(where: { $0.title == "Original" }) else {
            return XCTFail("entry not found")
        }
        entry.title = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.title, "Updated")
    }

    func testIsAtFreeLimitFalseInitially() {
        let store = Store()
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testDeleteAtOffsets() {
        let store = Store()
        let before = store.entries.count
        _ = store.add(InsurewalletEntry(title: "OffsetTest"))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before)
    }
}
