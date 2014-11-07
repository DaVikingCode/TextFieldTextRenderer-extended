TextFieldTextRenderer-extended
==============================

Feathers's TextFieldTextRenderer with hyperlink support.

Rectangles are created around the hyperlink (supports line breaks) and a default touch event listener is set up to test if the touch position is inside any of these rectangles, it then calls the clickHandler callback (see below).

The clickHandler callback receives all clicked sections - so it's an array of HtmlSection. The reason for that is that you could have a link inside a link... Why would you do that ? Well it's possible that you might need to be able to click a sentence, and also a word in that sentence, and handle both cases.

Anyway this was created for hyperlinks first, yet you can use it for very different reasons such as  giving parts of the text background colors (see the debugVisuals) , or trigger an event in your code, or know where a specific word is in a text, because the rectangle(s) (there can be more than one if the line breaks) can be used to know the vertical position of a word for text effects or triggers when you scroll that text or whatever.

The onSectionsCreated callback (not used in that example) is called when the html has been fully parsed and the rectangles fitting all the links created. This callback will receive as only argument a Vector.<HtmlSection> .
An HtmlSection contains a Vector or rectangles : HtmlSection.charRects , which you can loop through to get all rectangles of the link.

the attributes property was created to get all of the tag's attribute, it works for fonts/color or p/align for example, but that's it, flash actually gets rid of most possible attributes you can have in an html text unless you use stylesheets... so you'll mostly be using section.attributes.href... you can serialize anything you want in a string and pass it on in the href anyway.

For mobile, the touch area might need to be bigger than exactly the size of the text lines, the boundariesInflation properties help inflate the area.

```actionscript3
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
Till the dread penalty be paid. ]>;

textField.wordWrap = true;
stage.addChild(textField);
```

![httf](https://cloud.githubusercontent.com/assets/2741417/4938073/c3c61d1c-65c8-11e4-9740-d6b48f83fe90.png)

setting debugVisuals to true will create green quads behind the text, exactly the size of the rectangles we hit test with for the hyperlink.

How :
we simply use TextField.getCharBoundaries() for each text characters in the link (so the process can be slow) and then merge rectangles until the line apparently breaks.
It is best not to have variable font sizes in a section of text where you have a link.

The html parser is VERY primitive, the html must be absolutely valid and as minimal as possible - specially since flash tends to add loads of tags by itself in the end - but you can absolutely use font tags to change color for your link's text and so on.

Why :
Not only to be able to touch/click links (which is something important in itself), but also to identify the visual position of some words or even just lines by adding empty a tags with specific href identifiers, specially if they are going to come from an xml file in different languages.
