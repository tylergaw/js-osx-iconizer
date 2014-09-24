JsOsaDAS1.001.00bplist00�Vscript_�ObjC.import("Cocoa");

var views = [];
var scriptPath = $.NSBundle.mainBundle.pathForResourceOfType('runGulp', 'sh');

var sketchDocInput = createTextField();
var fontNameInput = createTextField("my-fonticon");
var gulpLocInput = createTextField();
var distLocInput = createTextField();
var templateInput = createComboBox(["fontawesome", "foundation"], 0);
var classNameInput = createTextField("s");
var htmlCheckbox = createSwitchButton("Generate HTML", $.NSOnState);
var cssCheckbox = createSwitchButton("Generate CSS", $.NSOnState);

ObjC.registerSubclass({
	name: 'AppDelegate',
	methods: {
		'sketchDocLoc:': {
			types: ['void', ['id']],
			implementation: function (sender) {
				var panel = $.NSOpenPanel.openPanel;
				var allowedTypes = ["sketch"];
				
				panel.title = "Choose Sketch File";
				
				// NOTE: Bridge the JS array to an NSArray when setting allowed types
				panel.allowedFileTypes = $(allowedTypes);
				
				if (panel.runModal == $.NSOKButton) {
					// NOTE: panel.URLs is an ObjectiveC Array not a JS array
					var sketchDocPath = panel.URLs.objectAtIndex(0).path;
					sketchDocInput.stringValue = sketchDocPath;
				}
			}
		},
		'symbolsLoc:': {
			types: ['void', ['id']],
			implementation: function (sender) {
				var panel = $.NSOpenPanel.openPanel;
				panel.title = "Choose Symbols for Sketch Directory";
				panel.canChooseFiles = false;
				panel.canChooseDirectories = true;
				
				if (panel.runModal == $.NSOKButton) {
					// NOTE: panel.URLs is an ObjectiveC Array not a JS array
					var loc = panel.URLs.objectAtIndex(0).path;
					gulpLocInput.stringValue = loc;
					
					if (distLocInput.stringValue.length == 0) {
						// NOTE: Unwrap the objective c string to a JS string
						distLocInput.stringValue = $(loc).js + "/dist";
					}
				}
			}
		},
		'distLoc:': {
			types: ['void', ['id']],
			implementation: function (sender) {
				var panel = $.NSOpenPanel.openPanel;
				panel.title = "Choose Save Location";
				panel.canCreateDirectories = true;
				panel.canChooseFiles = false;
				panel.canChooseDirectories = true;
				
				if (panel.runModal == $.NSOKButton) {
					// NOTE: panel.URLs is an ObjectiveC Array not a JS array
					var loc = panel.URLs.objectAtIndex(0).path;
					distLocInput.stringValue = loc;
				}
			}
		},
		'btnHandler:': {
			types: ['void', ['id']],
			implementation: function (sender) {
				
				var gulpLoc = gulpLocInput.stringValue;
				var sketchDoc = sketchDocInput.stringValue;
				var fontName = fontNameInput.stringValue;
				var className = classNameInput.stringValue;
				var distLoc = distLocInput.stringValue;
				var template = templateInput.stringValue;
				
				var html = (htmlCheckbox.state == $.NSOnState) ? "true" : "false";
				var css = (cssCheckbox.state == $.NSOnState) ? "true" : "false";
				
				var task = $.NSTask.alloc.init;
				task.launchPath = scriptPath;
				
				// Bridge the JS array to an NSArray with $()
				task.arguments = $([gulpLoc, sketchDoc, fontName, className, distLoc, template, html, css]);
												
				var out = $.NSPipe.pipe;
				task.standardOutput = out;
				task.standardError = out;

				task.launch;
				task.waitUntilExit;
				task.release;

				var read = out.fileHandleForReading;
				var dataRead = read.readDataToEndOfFile;
				var stringRead = $.NSString.alloc.initWithDataEncoding(dataRead, $.NSUTF8StringEncoding).autorelease;

				$.NSLog(stringRead);
			}
		}
	}
});

var appDelegate = $.AppDelegate.alloc.init;

var sketchDocButton = createButton("Choose file...");
sketchDocButton.setTarget(appDelegate);
sketchDocButton.setAction("sketchDocLoc:");

var gulpLocButton = createButton("Choose directory...");
gulpLocButton.setTarget(appDelegate);
gulpLocButton.setAction("symbolsLoc:");

var distLocButton = createButton("Choose directory...");
distLocButton.setTarget(appDelegate);
distLocButton.setAction("distLoc:");

// The order of this matters
// If it is before the AppDelegate is init'd, things fail silently.
// I think its the creation of the button that makes the difference.
views.push(
	createTextLabel("Sketch File:"),
	sketchDocInput,
	sketchDocButton,
	createTextLabel("Symbols for Sketch Location:"),
	gulpLocInput,
	gulpLocButton,
	createTextLabel("Save Location:"),
	distLocInput,
	distLocButton,
	createTextLabel("Font Name:"),
	fontNameInput,
	createTextLabel("Class Name:"),
	classNameInput,
	createTextLabel("HTML/CSS Template:"),
	templateInput,
	htmlCheckbox,
	cssCheckbox,
	createMainButton("Create Fonticon")
);

var mask = $.NSTitledWindowMask | $.NSClosableWindowMask | $.NSMiniaturizableWindowMask;
var window = $.NSWindow.alloc.initWithContentRectStyleMaskBackingDefer(
	$.NSMakeRect(0, 0, 340, 1),
	mask,
	$.NSBackingStoreBuffered,
	false
);
	
var contentView = window.contentView;
		
var height = 0;
var container = $.NSView.alloc.initWithFrame($.NSMakeRect(20, 20, 340, 1));
	
views.reverse().forEach(function (val, i, arr) {
	var frame = val.bounds;
	frame.origin.y = height;
		
	height += frame.size.height + 8;
		
	val.setFrame(frame);
	container.addSubview(val);
});
	
var containerFrame = container.frame;
containerFrame.size.height = height;
container.setFrame(containerFrame);
contentView.addSubview(container);
	
var newWindowHeight = window.frame.size.height + (height + 20);
window.setFrameDisplay($.NSMakeRect(0, 0, 340, newWindowHeight), true);
window.center;
window.title = "Iconizer";
window.makeKeyAndOrderFront(window);
appDelegate.window = window;
	
function createTextLabel (val) {
	var label = $.NSTextField.alloc.initWithFrame($.NSMakeRect(0, 0, 300, 16));
	label.setDrawsBackground(false);
	label.setEditable(false);
	label.setBezeled(false);
	label.setSelectable(true);
	
	if (val) {
		label.setStringValue(val);
	}
	
	return label;
}

function createTextField (val) {
	var field = $.NSTextField.alloc.initWithFrame($.NSMakeRect(0, 0, 300, 24));
	
	if (val) {
		field.setStringValue(val);
	}
	
	return field;
}

function createMainButton (title) {
	var btn = createButton(title);
	btn.setTarget(appDelegate);
	btn.setAction("btnHandler:");
	btn.setKeyEquivalent("\r");
	return btn;
}

function createSwitchButton (title, state) {	
	var btn = $.NSButton.alloc.initWithFrame($.NSMakeRect(0, 0, 300, 40));
	btn.setButtonType($.NSSwitchButton);
	btn.setTitle(title);
	
	if (state) {
		btn.setState(state);
	}
	
	return btn;
}

function createButton (title) {
	var btn = $.NSButton.alloc.initWithFrame($.NSMakeRect(0, 0, 300, 40));
	btn.setTitle(title);
	btn.setBezelStyle($.NSRoundedBezelStyle);
	btn.setButtonType($.NSMomentaryLightButton);
	return btn;
}

function createComboBox (items, selectedItemIndex) {
	selectedItemIndex = (selectedItemIndex > -1) ? selectedItemIndex : 0;
	var comboBox = $.NSComboBox.alloc.initWithFrame($.NSMakeRect(0, 0, 300, 25));
	comboBox.addItemsWithObjectValues(items);
	comboBox.selectItemAtIndex(selectedItemIndex);
	return comboBox;
}

function createPopUp (items) {
	var popUp = $.NSPopUpButton.alloc.initWithFramePullsDown($.NSMakeRect(0, 0, 300, 25), false);
	popUp.addItemsWithTitles(items);
	return popUp;
}                              � jscr  ��ޭ