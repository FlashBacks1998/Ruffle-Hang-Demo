package;

import openfl.display.Loader;
import openfl.utils.ByteArray;
import openfl.events.Event;
import haxe.Timer;
import haxe.ui.components.Button;
import haxe.ui.components.TextArea;
import haxe.ui.Toolkit;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.text.TextFormatAlign;
import openfl.text.TextFormat;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.display.MovieClip;
import openfl.Lib;

class Main extends Sprite {
	final confirmstr = "I understand, I will close my webpage upon hang";
	var warningstr = "";
	var label:TextField = null;
	var format:TextFormat = null;
	var labelbg:Shape = null;
	var confirm:TextArea = null;
	var confirmbtn:Button = null;
	var mcbackground:MovieClip = null;

	public function new() {
		super();

		///---SETUP The Background---///

		warningstr = "WARNING: The following content will HANG YOUR WEBPAGE \n\nYou will not be able to access/click anything inside of your current webpage. In order to fix the issue after you have ran the bug you simply must close your webpage. \n\nPlease type (or copy and past) \n'"
		+ confirmstr
		+ "'\nin the textbox then click the button";

		format = new TextFormat();
		format.size = 18;
		format.align = TextFormatAlign.CENTER;
		label = new TextField();
		label.text = warningstr;
		label.width = 600;
		label.height = 300;
		label.wordWrap = true;
		label.setTextFormat(format);

		labelbg = new Shape();
		labelbg.graphics.beginFill(0xF5DEB3); // Wheat color
		labelbg.graphics.drawRect(0, 0, 600 + 32, 300 + 32);
		labelbg.graphics.endFill();

		addChild(labelbg);
		addChild(label);

		///---SETUP The Toolkit---///
		Toolkit.init();

		confirm = new TextArea();
		confirm.width = labelbg.width;
		confirm.height = 64;

		confirmbtn = new Button();
		confirmbtn.width = labelbg.width;
		confirmbtn.height = 32;
		confirmbtn.textAlign = "center";
		confirmbtn.text = "I understand, procede.";
		confirmbtn.onClick = onConfirmClick;

		addChild(confirm);
		addChild(confirmbtn);

		trace("HELLO WORLD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

		///---FINISH---///
		arrange();
	}

	public function onConfirmClick(_) {
		if (confirm.text.indexOf(confirmstr) < 0) {
			label.text = warningstr + "\n\nYou mispelled something.";
			label.setTextFormat(format);
			return;
		}

		label.text = "Alright, please close the webpage when it hangs!";

		trace("loading");
		// Load the library SWF file as bytes
		Assets.loadBytes("assets/vpmedia_starlingfilters.swf").onComplete(function(bytes:ByteArray) {
			// Create a Loader to load the SWF bytes
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event) {
				trace(loader.content);
				addChild(loader.content);
			});

			// Listen to loading progress
			Assets.loadBytes("assets/vpmedia_starlingfilters.swf").onProgress(function(bytesLoaded:Int, bytesTotal:Int) {
				var percentLoaded:Float = bytesLoaded / bytesTotal * 100;
				trace("Loading progress: " + percentLoaded + "%");
			});

			// Load the SWF bytes into the Loader
			loader.loadBytes(bytes);
		}).onError(function(error:Dynamic) {
			trace("ERROR", error);
		});
	}

	public function arrange() {
		if (mcbackground != null)
			removeChild(mcbackground);

		final bitmapData = Assets.getBitmapData("assets/background.png");
		mcbackground = new MovieClip();
		addChild(mcbackground);
		setChildIndex(mcbackground, 0);

		for (x in 0...Math.ceil(Lib.current.stage.stageWidth / bitmapData.width))
			for (y in 0...Math.ceil(Lib.current.stage.stageHeight / bitmapData.height)) {
				var bitmap = new Bitmap(bitmapData);
				bitmap.x = x * bitmapData.width;
				bitmap.y = y * bitmapData.height;
				mcbackground.addChild(bitmap);
			}

		label.x = (Lib.current.stage.stageWidth - label.width) / 2;
		label.y = (Lib.current.stage.stageHeight - label.height) / 2;
		labelbg.x = (Lib.current.stage.stageWidth - labelbg.width) / 2;
		labelbg.y = (Lib.current.stage.stageHeight - labelbg.height) / 2;
		confirm.x = (Lib.current.stage.stageWidth - confirm.width) / 2;
		confirm.y = labelbg.y + labelbg.height + 32;
		confirmbtn.x = (Lib.current.stage.stageWidth - confirmbtn.width) / 2;
		confirmbtn.y = confirm.y + confirm.height + 32;
	}
}
