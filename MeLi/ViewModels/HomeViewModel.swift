//
//  HomeViewModel.swift
//  MeLi
//
//  Created by Mario Jaramillo on 17/04/21.
//

import Foundation
import RxCocoa

class HomeViewModel {
    
    var items : BehaviorRelay<[Product]> = BehaviorRelay(value: [])
    var searchResult: SearchResultResponse? //viewmodel
    var delegate: HomeViewModelDelegate?
    
    
    
    
    //MARK: - Functions
    
    /**
         Calls the search API with the entered search string. Handles the completion block and updates the UI accordingly

         - Parameters:
            - searchText: The text query to be searched
    */
    
    func searchProducts(searchText: String) {
        
        items.accept([]) //clear previous search results
        
        NetworkingHelper.searchProducts(searchText: searchText) { [weak self] (response, searchResult) in
            
            guard let self = self else { return }
            
            switch response {
            
            case .ok:
                
                self.searchResult = searchResult  //saves the searchResult globally in order to allow pagination
                let products = searchResult?.results ?? []
                self.items.accept(products)
                self.delegate?.didFinishSearching(error: false)
                
            case .error:
                
                self.delegate?.didFinishSearching(error: true)
            }
        }
    }
    
    
    /**
         Checks if there are more available results. Calls the search API with the last saved query, and set the offset to the current amount of results. Handles the completion block and updates the UI accordingly
    */
    
    func searchMoreProducts() {
        
        //Checks if the product count is lesser than the total amount of results for the query
        guard let currentSearchResult = self.searchResult, items.value.count < currentSearchResult.paging.total else { return }
        
        NetworkingHelper.searchProducts(searchText: currentSearchResult.query, offset: items.value.count) { [weak self] (response, searchResult) in
            
            guard let self = self else { return }
            
            switch response {
            
            case .ok:
                
                var products = self.items.value
                products.append(contentsOf: searchResult?.results ?? []) //merge current products with the new results
                self.items.accept(products)
                self.delegate?.didFinishSearching(error: false)
                
            case .error:
                
                print("Error loading more results...")
            }
        }
    }
    
    
    
    /**
         Generates a string with the pagination text
    */
    
    func getProductShowingString() -> String {
        
        return "Mostrando \(items.value.count) de \(self.searchResult?.paging.total ?? 0)"
    }
    
    
    /**
         Calculates the alpha for the pagination label
    */
    
    func getProductShowingAlpha() -> CGFloat {
        
        return items.value.isEmpty ? 0 : 1
    }
    
    
    /**
         Calculates how many products are currently available in the tableView
    */
    
    func areProductsAvailable() -> Bool {
        
        return !items.value.isEmpty
    }
}




//MARK: - HomeViewModel delegate protocol

protocol HomeViewModelDelegate {
    
    func didFinishSearching(error: Bool)
    func didFinishLoadingMoreProducts(error: Bool)
}
