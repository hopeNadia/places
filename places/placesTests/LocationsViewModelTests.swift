import XCTest
@testable import places

@MainActor
final class LocationViewModelTests: XCTestCase {
    var locationService: LocationServiceMock!
    var urlService: URLServiceMock!
    var urlOpener: URLOpenerServiceMock!
    var viewModel: LocationsViewModel!
    
    override func setUp() {
        super.setUp()
        locationService = LocationServiceMock()
        urlService = URLServiceMock()
        urlOpener = URLOpenerServiceMock()
        viewModel = LocationsViewModel(
            locationService: locationService,
            urlService: urlService,
            urlOpener: urlOpener
        )
    }
    
    override func tearDown() {
        locationService = nil
        urlService = nil
        urlOpener = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_onAppear_setsLoadingAndFetchesLocationsSuccessfully() async {
        let expectedLocations = [Location.mock1, Location.mock2]
        locationService.locationsToReturn = expectedLocations
        
        viewModel.onAppear()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.viewState, .idle)
        XCTAssertEqual(viewModel.locations, expectedLocations)
    }
    
    func test_onAppear_setsErrorWhenFetchingFails() async {
        locationService.isError = true
        
        viewModel.onAppear()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.viewState, .error)
        XCTAssertNil(viewModel.locations)
    }
    
    func test_onRefresh_callsGetLocations() async {
        let expectedLocations = [Location.mock1]
        locationService.locationsToReturn = expectedLocations
        
        viewModel.onRefresh()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.locations, expectedLocations)
        XCTAssertEqual(viewModel.viewState, .idle)
    }
    
    func test_onShowFormTap_initializesCoordinatesFormViewModel() {
        viewModel.onShowFormTap()
        XCTAssertNotNil(viewModel.coordinatesFormViewModel)
    }
    
    func test_onLocationTap_opensUrlIfAvailable() {
        let location = Location.mock1
        
        viewModel.onLocationTap(location: location)
        
        XCTAssertEqual(urlService.receivedLat, location.lat)
        XCTAssertEqual(urlService.receivedLong, location.long)
        XCTAssertEqual(urlOpener.openedUrl, urlService.urlToReturn)
    }
    
    func test_onLocationTap_doesNothingIfUrlIsNil() {
        urlService.urlToReturn = nil
        let location = Location.mock1
        
        viewModel.onLocationTap(location: location)
        
        XCTAssertNil(urlOpener.openedUrl)
    }
}
