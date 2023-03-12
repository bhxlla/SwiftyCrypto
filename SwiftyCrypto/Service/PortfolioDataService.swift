//
//  PortfolioDataService.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 11/03/23.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    let container: NSPersistentContainer
    @Published var portfolio: [Portfolio] = []
    
    init() {
        container = NSPersistentContainer(name: "Crypto")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Error loading CoreData: \(error.localizedDescription)")
            }
            self.fetchPortfolio()
        }
    }
    
    func update(coin: Coin, with amount: Double) {
        if let folio = portfolio.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(folio: folio, amt: amount)
            } else {
                remove(folio: folio)
            }
        } else {
            add(coin: coin, amt: amount)
        }
    }
    
    private func fetchPortfolio() {
        
        let request = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        
        do {
            let result = try container.viewContext.fetch(request)
            portfolio = result
        } catch let error {
            fatalError("Error fetching Portfolio... \(error.localizedDescription)")
        }
        
    }
    
    private func add(coin: Coin, amt: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amt
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("error saving: \(error.localizedDescription)")
        }
    }
    
    private func update(folio: Portfolio, amt: Double) {
        folio.amount = amt
        applyChanges()
    }
    
    private func remove(folio: Portfolio) {
        container.viewContext.delete(folio)
        applyChanges()
    }
    
    private func applyChanges() {
        save()
        fetchPortfolio()
    }
    
}
