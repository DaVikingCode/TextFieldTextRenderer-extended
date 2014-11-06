package example 
{
	import davikingcode.feathers.HtmlSection;
	import davikingcode.feathers.TextFieldTextRendererExtended;
	import flash.text.Font;
	import flash.text.TextFormat;
	import starling.display.Sprite;
	public class Example1_Screen extends Sprite
	{
		[Embed(source = "font/KENYC___.TTF", fontName = "KENYC___", mimeType = "application/x-font", embedAsCFF = "false")]
		private const KENYC___:Class;
		
		protected var textField:TextFieldTextRendererExtended;
		protected var textFormat:TextFormat;
		
		public function Example1_Screen() 
		{
			Font.registerFont(KENYC___);
		}
		
		public function initialize():void
		{
			textField = new TextFieldTextRendererExtended();
			textField.maxWidth = 800;
			textFormat = new TextFormat("KENYC___", 32, 0x333333);
			textFormat.leading = -21;
			textFormat.letterSpacing = 1;
			
			textField.debugVisuals = true;
			textField.boundariesInflation = 2;
			textField.clickHandler = function(sections:Array):void
				{
					for each(var s:HtmlSection in sections)
					{
						trace("clicked on link :", s.attributes.href);
					}
				};
			
			textField.embedFonts = true;
			textField.textFormat = textFormat;
			textField.isHTML = true;
			textField.text =
<![CDATA[The Owls

'Neath their black yews in solemn state
The owls are sitting in a row
Like foreign gods; and even so
<a href="http://www.google.com/search?q=owl+red+eyes&safe=off&source=lnms&tbm=isch&sa=X">Blink their red eyes;</a> they meditate.

Quite motionless they hold them thus
Until at last the day is done,
And, driving down the slanting sun,
The sad night is victorious.

They teach the wise who gives <a href="supports line breaks">them ear
That in</a> this world he most should fear
All things which loud or restless be.

Who, dazzled by a passing shade,
Follows it, never will be free
Till the dread penalty be paid. ]]>

			textField.wordWrap = true;
				
			stage.addChild(textField);
			
		}
	}

}