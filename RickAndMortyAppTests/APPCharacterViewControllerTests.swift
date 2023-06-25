//
//  APPCharacterViewControllerTests.swift
//  RickAndMortyAppTests
//
//  Created by Emerson Balahan Varona on 25/6/23.
//

import XCTest
@testable import RickAndMortyApp

final class APPCharacterViewControllerTests: XCTestCase {
    var viewController: APPCharacterViewController!
    
    override func setUpWithError() throws {
        viewController = APPCharacterViewController()
        viewController.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        super.tearDown()
    }
    
    func testViewDidLoad() throws {
        XCTAssertNotNil(viewController.view)
        XCTAssertEqual(viewController.title, "Characters")
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
        XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.target as? APPCharacterViewController, viewController)
        //XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.action, #selector(viewController.didTapSearch))
    }
    
    /*
    func testDidTapSearch() throws {
        viewController.didTapSearch()
        XCTAssertNotNil(viewController.navigationController?.topViewController as? APPSearchViewController)
    }
     */
    
    /*
    func testAppCharacterListViewDidSelectCharacter() throws {
        // Verificar que se muestra el controlador de detalles al seleccionar un personaje en la vista de lista
        let character = APPCharacter(name: "CharacterName", description: "CharacterDescription")
        viewController.appCharacterListView(viewController.characterListView, didSelectCharacter: character)
        
        do {
            let topViewController = try XCTUnwrap(viewController.navigationController?.topViewController as? APPCharacterDetailViewController)
            XCTAssertEqual(topViewController.viewModel.character, character)
        } catch {
            XCTFail("No se pudo obtener el controlador de detalles o el personaje seleccionado: \(error)")
        }
    }
     */
     
}
