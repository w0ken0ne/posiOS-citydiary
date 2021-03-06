//
//  LocalDataBase.swift
//  citydiary
//
//  Created by Willian S. on 03/01/22.
//

import CoreData
import Foundation

protocol LocalComplainManagerDelegate {
    func saveResult(succeful: Bool, error: String?)
}

class LocalComplainManager: LocalStorage {
    var fetchedResultsController: NSFetchedResultsController<Complain>!
    var delegate: LocalComplainManagerDelegate?

    static var shared: LocalComplainManager {
        return LocalComplainManager()
    }

    private init() {
    }

    func fetchAll(delegate: NSFetchedResultsControllerDelegate) {
        let fetchRequest: NSFetchRequest<Complain> = Complain.fetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "registeredAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = delegate
        try? fetchedResultsController.performFetch()
    }

    func getNewComplain() -> Complain {
        return Complain(context: context)
    }

    func save() {
        do {
            try context.save()
            delegate?.saveResult(succeful: true, error: nil)
        } catch {
            print(error.localizedDescription)
            delegate?.saveResult(succeful: false, error: error.localizedDescription)
        }
    }

    func delete(_ complain: Complain) {
        context.delete(complain)
        save()
    }
}
