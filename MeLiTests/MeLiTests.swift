//
//  MeLiTests.swift
//  MeLiTests
//
//  Created by Mario Jaramillo on 4/11/21.
//

import XCTest
import UIKit
import Foundation
@testable import MeLi

class MeLiTests: XCTestCase {
    
    var tableView: UITableView!
    private var dataSource: TableViewDataSource!
    private var delegate: TableViewDelegate!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 400), style: .plain)
        let itemXib = UINib.init(nibName: "ProductCell",
                                        bundle: nil)
        tableView.register(itemXib,
                           forCellReuseIdentifier: "ProductCell")
        dataSource = TableViewDataSource()
        delegate = TableViewDelegate()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testProductConditionName() {
        
        var product = createTestProduct()
        XCTAssertEqual(product.getConditionName(), "Usado")
        
        product.condition = "new"
        XCTAssertEqual(product.getConditionName(), "Nuevo")
    }

    func testHomeViewModel() throws {
        
        let homeViewModel = HomeViewModel()
        var searchResult = SearchResultResponse()
        let paging = Paging(total: 100, offset: 0, limit: 50)
        searchResult.paging = paging
        homeViewModel.searchResult = searchResult

        XCTAssertEqual(homeViewModel.getProductShowingString(), "Mostrando 0 de 100")
        XCTAssertEqual(homeViewModel.getProductShowingAlpha(), 0)
        XCTAssertFalse(homeViewModel.areProductsAvailable())
    }
    
    func testProductDetailViewModel() {
        
        let productDetailViewModel = ProductDetailsViewModel()
        var product = createTestProduct()
        
        XCTAssertEqual(productDetailViewModel.getAvailableStockText(product: product), "Stock disponible: 160")
        XCTAssertEqual(productDetailViewModel.getConditionLabelText(product: product), "Usado | 23 vendidos")
        
        product.condition = "new"
        XCTAssertEqual(productDetailViewModel.getConditionLabelText(product: product), "Nuevo | 23 vendidos")
    }
    
    func testProductCell() {
        
        var product = createTestProduct()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = createCell(indexPath: indexPath)
        cell.product = product
        
        XCTAssertEqual(cell.nameLabel.text, "iPhone 12")
        XCTAssertEqual(cell.shippingLabel.text, "Envío Gratis")
        XCTAssertEqual(cell.shippingLabel.textColor, .systemGreen)
        XCTAssertEqual(cell.priceLabel.text, "$9,870 COP")
        
        product.shipping.free_shipping = false
        cell.product = product
        XCTAssertEqual(cell.shippingLabel.text, "Envío a cargo del comprador")
    }
    
    

}




extension MeLiTests {

    func createCell(indexPath: IndexPath) -> ProductCell {
        
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as! ProductCell
        XCTAssertNotNil(cell)
        
        let view = cell.contentView
        XCTAssertNotNil(view)
        
        return cell
    }
    
    func createTestProduct() -> Product {
        
        var product = Product()
        product.condition = "used"
        product.available_quantity = 160
        product.sold_quantity = 23
        product.title = "iPhone 12"
        product.shipping = Shipping(free_shipping: true)
        product.price = 9870.0
        product.currency_id = "COP"
        
        return product
    }
}

private class TableViewDataSource: NSObject, UITableViewDataSource {

    var items = [Product]()

    override init() {
        super.init()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell",
                                                 for: indexPath)
        return cell
    }
}

private class TableViewDelegate: NSObject, UITableViewDelegate {

}


