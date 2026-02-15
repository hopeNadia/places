import XCTest
@testable import places

@MainActor
class CoordinatesFormViewModelTests: XCTestCase {
    var urlService: URLServiceMock!
    var urlOpener: URLOpenerServiceMock!
    var viewModel: CoordinatesFormViewModel!
    
    override func setUp() {
        super.setUp()
        urlService = URLServiceMock()
        urlOpener = URLOpenerServiceMock()
        viewModel = CoordinatesFormViewModel(
            urlService: urlService,
            urlOpener: urlOpener
        )
    }
    
    override func tearDown() {
        urlService = nil
        urlOpener = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_validCoordinates_noErrorShown() {
        viewModel.latitudeInput = "37,7749"
        viewModel.longitudeInput = "-122,4194"
        
        XCTAssertTrue(viewModel.isValidCoordinates)
        XCTAssertFalse(viewModel.isInputErrorVisible)
    }
    
    func test_invalidCoordinates_errorShown() {
        viewModel.latitudeInput = "abc"
        viewModel.longitudeInput = "xyz"
        
        XCTAssertFalse(viewModel.isValidCoordinates)
        XCTAssertTrue(viewModel.isInputErrorVisible)
    }
    
    func test_emptyCoordinates_formIdleState() {
        viewModel.latitudeInput = ""
        viewModel.longitudeInput = ""
        
        XCTAssertFalse(viewModel.isValidCoordinates)
        XCTAssertFalse(viewModel.isInputErrorVisible)
    }
    
    func test_opensUrlForValidCoordinates() {
        viewModel.latitudeInput = "10"
        viewModel.longitudeInput = "20"
        
        viewModel.onCustomCoorinatesSubmit()
        
        XCTAssertEqual(urlService.receivedLat, 10)
        XCTAssertEqual(urlService.receivedLong, 20)
        XCTAssertEqual(urlOpener.openedUrl, urlService.urlToReturn)
    }
    
    func test_doesNothingForInvalidCoordinates() {
        viewModel.latitudeInput = "abc"
        viewModel.longitudeInput = "xyz"
        
        viewModel.onCustomCoorinatesSubmit()
        
        XCTAssertNil(urlOpener.openedUrl)
    }
    
    func test_doesNothingIfUrlIsNil() {
        viewModel.latitudeInput = "10"
        viewModel.longitudeInput = "20"
        urlService.urlToReturn = nil
        
        viewModel.onCustomCoorinatesSubmit()
        
        XCTAssertNil(urlOpener.openedUrl)
    }
}
