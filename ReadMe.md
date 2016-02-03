Project Skeleton
===================

# Instalace

Nainstaluj fastlane
```
sudo gem install fastlane
```

### Stáhni fixcode a file templaty
```
fastlane xcode
```

# Použití Fastlane

#### Posláni beta verze na hockey app
```
fastlane beta
```

### Posláni verze do appstore
```
fastlane appstore
```

### Testy
```
//Otestuj vse
fastlane test

//Specificke testy
fastlane test type:api
fastlane test type:ui
```

### Screenshoty
```
fastlane screenshots
```

### SwiftLint a MemoryLeak check
```
fastlane analyze
```

Kompletní seznam všech metod zde:
[Fastlane README](fastlane/README.md)


## Nastavení
Všechny konstanty se nastavují ve fastlane/Fastfile

Jdu sem pokud chci zmenit:

**app_name** pro dev/beta/appstore

**app_identifier** pro dev/beta/appstore

**slack_url**  channel hook pro posilani zprav o testech, uploadech atd ...

**inhouse/connect app identifier** username pro podepisovani a posilani buildu 

Pokud změním app_name, app_identifier zavolám

```
fastlane xcode
```

aby se mi updatnul xcode. 

V xcode už ideálně nic neměním.


# Testování

## Typy a spouštění testů
Máme tři typy testů

### UnitTests
Většina z testů, data si mockuju přes dummy objekty (nepřipojuju se k API)
### APITests
Testy které mají za úkol zajistit že API jede v pořádku. Budou se na jenkinsovi pouštět periodicky
### UITests
UI testy použité mimo jiné na generování screenshotů


### Spouštění
Test spustím přes `Command+U`

Protože APITesty a UITesty trvají dlouho, na `Development` scheme se mi defaultně spustí jenom `UnitTests`. 

Pokud chci otestovat APITests a UnitTests spustím je přes jejich scheme



## Quick
Používáme framework **Quick** 
https://github.com/Quick/Quick

Testy se píšou do specifikací

```
import Quick
import Nimble
import ReactiveCocoa

//@testable To get access to non-public interface
@testable import SampleTestingProject

class ViewModelSpec: QuickSpec {

	override func spec() {
		describe("View model"){
			var viewModel: ViewModeling!
			context("on network error") {
				beforeEach{
					viewModel = ViewModel(api: ErrorStubApi())
				}
			    it("sets errorMessage property") {
		            viewModel.downloadData()
			        expect(viewModel.errorMessage.value).toEventuallyNot(beNil())
		        }
		}
	}
}

```

**describe** - co testujeme

**context** - vstupni podminky

**it** - samotny test je tady

Myslenka je abych pri failujicim testu vedel co se presne deje. Zaroven syntaxe quicku vede k tomu aby programator popisovat chovani aplikace (Behaviour Driven Testing).  Z jednotlivych popisku se pak vytvori dlouhy nazev xctest v tomhle pripade:

```
View_model__on_network_error__sets_errorMessage_property
```

Pro nastaveni promennych pred testy muzeme pouzit **beforeEach** a **afterEach** 

Pokud chci delat neco casove narocnejsiho napr. vytvoreni in-memory databaze pouziju **beforeSuite** a **afterSuite**. S MagicRecord je to easy:

```
	beforeSuite {
	        MagicalRecord.setDefaultModelFromClass(ViewModelSpec.self)
            MagicalRecord.cleanUp()
            MagicalRecord.setupCoreDataStackWithInMemoryStore()
            
            //Create dummy data
   }
        
  afterSuite {
      MagicalRecord.cleanUp()
  }
```

##Mocking

Mam view model co zavisi na CLLocationManager a chci otestovat co stane kdyz se zmeni poloha

Pokud udelam neco takoveho:

```
	class ViewModel: ViewModeling{
		static let locationManager: CLLocationManager = {
	        return CLLocationManager()
	    }() 
	}
```

tak ViewModel nemuzu otestovat, protoze nemam zpusob jak se dostat k locationManageru. Misto toho si ho predam jako zavislost.

```
class ViewModel: ViewModeling{
	init(locationManager: LocationManager){
	    self.locationManager = locationManager
    }
}
```

Abych ho mohl pozdeji mocknout, musim ho conformnout ke svemu protokolu:

```
protocol LocationManager{
	var location: CLLocation? { get }
}

extension CLLocationManager:LocationManager{}
``` 

A pri testovani uz jen predam nejaky svuj mock:

```
class LocationManagerMock: LocationManager{
    var location: CLLocation? = nil
}

beforeEach {
	viewModel = ViewModel(locationManager: LocationManagerMock())
}
```

##SharedExample
Pokud nejaka kriteria pouzivam vicekrat, muzu si usetrit psani a pouzit Configuration. 

```
class SharedExamplesConfiguration: QuickConfiguration {
  override class func configure(configuration: Configuration) {
	    sharedExamples("something edible") { (sharedExampleContext: SharedExampleContext) in
	    
      it("makes dolphins happy") {
        let dolphin = Dolphin(happy: false)
        let edible = sharedExampleContext()["edible"]
        dolphin.eat(edible)
        expect(dolphin.isHappy).to(beTruthy())
      }
    }
  }
}
```

Pak uz se jenom zavola

```
itBehavesLike("something edible") { ["edible": cod] }
```

A na predanem objektu se spusti vsechny testy z konfigurace


Typickym prikladem je testovani jestli objekt leakuje, konfigurace je v: **MemoryLeakConfiguration.swift**, coz muze byt obcas hodne uzitecny. Staci pridat v closure vytvoreni objektu ktery se ma otestovat. 

```
itBehavesLike("object without leaks"){
	MemoryLeakContext{
		LanguagesTableViewModel(api: GoodStubApi())
     }
}
```

Vevnitr se netestuje nic slozityho, jenom se objektu odeberou reference na nej a testuje se jestli bude nil.


Daji se tak testovat i viewcontrollery:

```
itBehavesLike("object without leaks"){
   MemoryLeakContext{
       let controller = ViewController(viewModel: ViewModelStub())
       
       //Make it load view
       let _ = controller.view
       
       return controller
   }
}
```

# ViewModel a ViewModeling

Vzhledem k tomu ze chceme testovat i view modely, zavedeme konvenci ze kazdy ViewModel implementuje protokol. Abychom nemuseli psat ViewModelProtocol, ViewModelInterface atd ..., pouzijeme konvenci -ing.
 

```
protocol ViewModeling{
	var name: MutableProperty<String> { get } 
}

class ViewModel: ViewModeling{
	let name: MutableProperty<String>
}
```

Protocol a tridu je lepsi mit v jednom souboru, kvuli proklikavani z jinych trid kde bude jako reference vzdycky Protocol.

Zaroven je -ing dobra konvence i pro ostatni protokoly napr. Service: Servicing. Geocoder: Geocoding atd. 

Aby jste si nemysleli ze si to vsechno vymejslim, vetsina konvenci vychazi z:
https://github.com/Swinject/SwinjectMVVMExample 

Kouknete do Templatu, pridal jsem tam sablony ktery nam to trochu ulehci.


# Dependency Injection
Jeste nekoncime, tady teprv zacina opravdovy "deep shit". Pokud ma ale nekdo zkusenosti z webu (treba Nette) muze to preskocit :).

Pokud chci otestovat celou aplikaci, kazda sluzba by mela byt idealne predana jako zavislost abych si ji mohl mocknout. To znamena ze uz nemuzeme pouzivat Singletony, Enumy, Staticke promenne na AppDelegatu atd... 

Ok, proc ale potrebuju Dependency Injection Framework?

Rekneme ze mam sluzbu ImageSearch definovanou takhle:

```
class ImageSearch: ImageSearching{
	init(api: API, imageResizer: ImageResizing)
}
```

API:

```
class SomeAPI: API{
	init(network: Networking)
}
```

Network:

```
class Network: Networking{
	init(baseURL: String, jsonSerializer: JSONSerializing)
}
```

Pro vytvoreni ImageSearch musim zavolat neco takoveho

```
init(){
	ImageSearch(api: API(network: Network(baseURL: baseURL, jsonSerializer: JSONSerializer())), imageResizer: ImageResizer() )
	}
```

Mohl bych si API a ImageResizer predat jako zavislost

```
init(api: API, imageResizer: ImageResizing){
	ImageSearch(api: api, imageResizer: resizer)
}
```

To ale znamena predavani dalsich zavislosti, a spousta psani kodu. A kazda dalsi vrstva si musi zavislosti predavat. Pri vetsim mnozstvi zavislosti pak nepisu nic jinyho nez injekty.


## Swinject
https://github.com/Swinject/Swinject

Misto  toho si zavislosti nadefinuju vsechny na jednom miste:

```
let container = Container()
	container.register(ImageResizing.self) { _ in ImageResizer() }
	container.register(API.self) { _ in SomeAPI(network: Networking.self) }
	container.register(ImageSearching.self) { r in 
	ImageSearch(api:r.resolve(API.self), imageResizer: r.resolve(ImageResizing.self) }
	// ... atd
}
```

A pak uz jenom zavolam 

```
let imageSearch = container.resolve(ImageSearching.self)
```

ktery uz za me vsechno vyresi. Zavislosti se vytvari line, az ve chvili kdy je potrebuje nejaky dalsi objekt.

Jde jim specifikovat Scope

```
container.register(AnimalType.self) { _ in Cat() }
    .inObjectScope(.Container)
```

- ObjectScope.Container - Singleton
- ObjectScope.None - vzdy se vytvori novy objekt
- ObjectScope.Graph (Default) - pres container.resolve() se vytvari novy ale primo ve vytvarejicich closure (pres r.resolve()) se sdileji

Typicky se container inicializuje v AppDelegate, ale pokud je toho tam víc hůř se v tom orientuje.

Proto jsem jsem to dal do speciální třídy `AppContainer`


##Factories

Tohle je fajn, ale to nam uplne neresi problem s vytvarenim novych objektu uvnitr zavislosti

Dejme tomu ze mam ze mam UITableViewController a po kliknuti na radek by se mel otevrit DetailViewController.

Udelam to jednoduse: 
```
let detailViewModel = self.viewModel.cellModels[0]
let controller = DetailViewController(viewModel:detailViewModel)
// ...  pushController(controller)
```

Pak si ale vzpomenu ze bych chtel DetailViewController v testu mocknout, jak to udelam? A taky, co kdyby mel DetailViewController vice zavislosti? Pak si je budu muset predat z TableViewControlleru a jsme tam kde jsme byli.

Muzu si AppContainer ulozit do staticke promenne a zavolat 
```
AppContainer.container.resolve(DetailViewController.self)
```
To mi ale neresi problem s mockovanim ...

Ok, tak si predam AppContainer jako zavislost do TableViewControlleru a zavolam
```
self.container.resolve(DetailViewController.self)
```
Akorat ze objekty by idealne o containeru vubec nemeli vedet a obecne se to oznacuje za anti-pattern. To neni uplne #rokKvality

Lepsi reseni jsou factories.  Misto objektu predam jako zavislost closure (tedy factory) ktera pak na vyzadani objekt vytvori. 

Nadefinuju si typealias

```
typealias DetailViewControllerFactory = (viewModel:DetailViewModeling) -> DetailViewController
```

Parametrem closure budou zavislosti ktere chci dynamicky predat
```
container.register(DetailViewControllerFactory.self){ r in
            return { viewModel in
                return DetailViewController(viewModel: viewModel, somethingElse: r.resolve(SomethingElsing.self) )
            }
        }
```

V kodu pak uz jenom zavolam:

```
let detailViewModel = self.viewModel.cellModels[0]
let controller = self.detailFactory(viewModel:detailViewModel)
```

I Tvrdik by nad tim zaplesal

Vyhodou DI je taky ze pohledem na zavislosti ziskam dobrou predstavu co vlastne ta trida dela. Napr. v prikladu je view model s initem:

```
init(api: API, geocoder: Geocoding, locationManager: LocationManager, detailModelFactory: LanguageDetailModelingFactory) 
```

Z toho vim, ze se pripojuje k API, deje se tam geocoding, pouziva se lokace a pushuje se do detailu.

Pozn: Samozrejme nepocitam ze bysme vsude pouzivali Factory pro kazdej pushnutej controller, tohle je trochu extremni pripad. Zalezi na tom co chci testovat, a pocitam ze controllery budeme testovat minimalne.


# Templaty

Vzhledem k tomu ze vytvareni ViewControlleru s ViewModelem delame furt dokola, udelal jsem na to File Template. 

Pridal jsem tam taky templaty od Quick na vytvareni testu.

Pokud byste chteli pridat dalsi file templaty, staci je pridat do slozky `fastlane\userdata\FileTemplates` a zavolat

```
fastlane xcode
```
coz prekopiruje vsechny templaty do xcode slozky.

![enter image description here](http://new.tinygrab.com/1430ee533229194c0d2c5ad0c127e28e9f2310ad06.png)

![enter image description here](http://new.tinygrab.com/1430ee5332d82817dfa2e51130b5fd2a2a3afa2af1.png)

# Snippety

Stejne tak jde vytvaret CodeSnippety najdete je ve slozce `fastlane\userdata\CodeSnippets`

Pak nezapomente zavolat

```
fastlane xcode 
```


#Snapshot
Fastlane nám taky dokáže ulehčit pořízování snapshotů.

Dejme tomu že chci pořídit screenshoty aplikace ve 3 různých jazycích na 3 zařízeních. To je práce tak na hodinu. A musím to dělat znova s každou verzí.


Místo toho použiju snapshot


Napřed je potřeba napsat UI Test
A přidat `snapshot("JmenoVyslednehoSouboruSeScreenshotem")` na mista kde chci vyfotit obrazovku

```
func testMainScreen() {
        let app = XCUIApplication()
        
        //Wait for pictures to load
        let images = app.images
        let stoppedLoading = NSPredicate(format: "count != 0")
        
        expectationForPredicate(stoppedLoading, evaluatedWithObject: images, handler: nil)
        waitForExpectationsWithTimeout(5, handler: nil)
        
		snapshot("01MainScreenList")
        
        let tablesQuery = app.tables
        tablesQuery.cells.elementBoundByIndex(0).tap()
        
        snapshot("02DetailScreenFirst")
    }
```

Pro nahrání interakcí s aplikací můžu použít record funkci v XCode (když otevřu uitest je to vlevo dole)

Pak už jenom zavolám

```
fastlane screenshots
```

který mi spustí testy a vygeneruje mi obrázky ve složce fastlane/screenshots
na nich ještě zavolá `frameit` který screenshotům přidá iPhone/iPad rámečky 

Pokud zavolám

```
fastlane appstore
```

fastlane automaticky screenshoty vygeneruje a pošle je do iTunes Connect

# Swiftlint

Když zbuilduju aplikaci, swiftlint mi automaticky zkontroluje `Source` a zobrazi mi warningy

Seznam povolenych a zakazanych pravidel nastavim v `.swiftlint.yml`

Pokud ho z nejakyho duvodu nechci spoustet vyhodim Swiftlint Run Phase u Project targetu

Pokud chci opravit nalezene chyby (ty co jsou opravitelne)

```
swiftlint autocorrect
```

# Todos
- lepsi prace s NSError
- Networking
- Groot 

#K Aplikaci

Kdyby jste se divili k cemu je vlastne ta example aplikace, kouknete sem: http://whostolemyunicorn.com/



