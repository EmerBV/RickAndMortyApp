//
//  APPSearchViewControllerTests.swift
//  RickAndMortyAppTests
//
//  Created by Emerson Balahan Varona on 25/6/23.
//

import XCTest
@testable import RickAndMortyApp

final class APPSearchViewControllerTests: XCTestCase {
    
    var viewController: APPSearchViewController!
    
    override func setUpWithError() throws {
        // Crea una instancia de la configuración
        let config = APPSearchViewController.Config(type: .character)
        
        // Crea una instancia del view model mock
        //viewModel = APPSearchViewViewModelMock(config: config)
        
        // Crea una instancia del view controller con el view model mock
        viewController = APPSearchViewController(config: config)
        //viewController.viewModel = viewModel
        
        // Carga la vista del view controller
        viewController.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        //viewModel = nil
        
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // Verifica que el título sea correcto
        XCTAssertEqual(viewController.title, "Search Characters")
        
        // Verifica que la vista tenga el color de fondo correcto
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        
        // Verifica que se agregue la vista de búsqueda como una subvista de la vista principal
        //XCTAssertTrue(viewController.view.subviews.contains(viewController.searchView))
        
        // Verifica que se configure correctamente el botón de búsqueda
        let searchButton = viewController.navigationItem.rightBarButtonItem
        XCTAssertEqual(searchButton?.title, "Search")
        XCTAssertEqual(searchButton?.style, .done)
        XCTAssertNotNil(searchButton?.target)
        XCTAssertNotNil(searchButton?.action)
        
        // Verifica que el delegado de la vista de búsqueda sea el view controller
        //XCTAssertTrue(viewController.searchView.delegate === viewController)
    }
    
    /*
    func testDidTapExecuteSearch() {
        // Activa el evento de tocar el botón de búsqueda
        viewController.didTapExecuteSearch()
        
        // Verifica que se haya llamado al método executeSearch en el view model
        XCTAssertTrue(viewModel.executeSearchCalled)
    }
     */
    
    
}

/*
 // Mock del view model para utilizar en los tests
 class APPSearchViewViewModelMock: APPSearchViewViewModel {
 
 var executeSearchCalled = false
 
 override func executeSearch() {
 executeSearchCalled = true
 }
 
 }
 */
