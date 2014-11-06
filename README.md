TextFieldTextRenderer-extended
==============================

Feathers's TextFieldTextRenderer with hyperlink support.

Rectangles are created around the hyperlink (supports line breaks) and a default touch event listener is set up to test if the touch position is inside any of these rectangles, it then calls the clickHandler callback , see below.

For mobile, the touch area might need to be bigger than exactly the size of the text lines, the boundariesInflation properties help inflate the area.

<pre>
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
&lt;![CDATA[The Owls

'Neath their black yews in solemn state
The owls are sitting in a row
Like foreign gods; and even so
&lt;a href="http://www.google.com/search?q=owl+red+eyes&amp;safe=off&amp;source=lnms&amp;tbm=isch&amp;sa=X"&gt;Blink their red eyes;&lt;/a&gt; they meditate.

Quite motionless they hold them thus
Until at last the day is done,
And, driving down the slanting sun,
The sad night is victorious.

They teach the wise who gives &lt;a href="supports line breaks"&gt;them ear
That in&lt;/a&gt; this world he most should fear
All things which loud or restless be.

Who, dazzled by a passing shade,
Follows it, never will be free
Till the dread penalty be paid. ]]&gt;

textField.wordWrap = true;
stage.addChild(textField);

</pre>

![httf](https://cloud.githubusercontent.com/assets/2741417/4938073/c3c61d1c-65c8-11e4-9740-d6b48f83fe90.png)

setting debugVisuals to true will create green quads behind the text, exactly the size of the rectangles we hit test with for the hyperlink.
