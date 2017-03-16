var Localize = require("localize-with-spreadsheet");
var transformer = Localize.fromGoogleSpreadsheet("<PUT_YOUR_GOOGLE_SPREADSHEET_ID_HERE", '*');
transformer.setKeyCol('<PUT_NAME_OF_KEY_COLUMN_HERE>');

var languages = {
	"Base":"CZ"
};

for (var key in languages)
{
	var value = languages[key];
	transformer.save("../Resources/"+key+".lproj/Localizable.strings", { valueCol: value, format: "ios" });
}
