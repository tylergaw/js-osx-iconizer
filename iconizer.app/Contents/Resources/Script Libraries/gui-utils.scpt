JsOsaDAS1.001.00bplist00�Vscript_lObjC.import("Cocoa");

function tester (msg) {
	return msg + " in bed";
}

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
}                              �jscr  ��ޭ