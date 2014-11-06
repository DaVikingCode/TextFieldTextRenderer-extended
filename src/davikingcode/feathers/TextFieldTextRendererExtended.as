package davikingcode.feathers
{
	
	import feathers.controls.text.TextFieldTextRenderer;

	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class TextFieldTextRendererExtended extends TextFieldTextRenderer
	{
		private static const HELPER_POINT:Point = new Point();
		
		/**
		 * called when a successfully parsed html section is clicked.
		 * receives three arguments :
		 * - tag name ("a" for links)
		 * - tag attributes in the form of an object ( object.href = "link" )
		 * - text string (the text of the clicked html content)
		 */
		public var clickHandler:Function;
		public var onSectionsCreated:Function;
		
		public var debugVisuals:Boolean = false;
		public var boundariesInflation:int = 0;
		
		public var doCharRectsFor:Array = ["a"];
		
		public var htmlSections:Vector.<HtmlSection>;
		
		private var _saveYposition:uint;
		
		public function TextFieldTextRendererExtended()
		{
			this.isHTML = true;
			htmlSections = new Vector.<HtmlSection>();
		}
		
		override protected function commit():void
		{
			super.commit();
			
			htmlSections.length = 0;
			
			if (isHTML)
				stage.addEventListener(EnterFrameEvent.ENTER_FRAME, parseHTML);
		}
		
		protected function parseHTML(e:EnterFrameEvent):void
		{
			if (!this.textField)
				return;
			
			stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, parseHTML);
			
			findHtmlSection(this.textField.htmlText, this.textField.text);
			
			doSections();
		
		}
		
		override public function dispose():void
		{
			
			if (htmlSections)
			{
				for each (var section:HtmlSection in htmlSections)
					section.destroy();
				htmlSections.length = 0;
				
				htmlSections = null;
			}
			
			super.dispose();
		}
		
		protected function findHtmlSection(htmlText:String, realText:String):void
		{
			var endHtmlPos:int = htmlText.length;
			
			var isInsideTag:Boolean = false;
			var tagContent:String = "";
			var tagId:int = -1;
			
			var tagTracker:Dictionary = new Dictionary();
			var openedNum:Dictionary = new Dictionary();
			
			var lastOpenTagPos:int = -1;
			
			var char:String;
			
			for (var htmlPos:int = 0; htmlPos < endHtmlPos; htmlPos++)
			{
				char = htmlText.charAt(htmlPos).toLowerCase();
				
				if (!isInsideTag)
				{
					for (var j:int = 0; j < HtmlSection.OPENTAG.length; j++)
						if (char == HtmlSection.OPENTAG[j])
						{
							isInsideTag = true;
							lastOpenTagPos = htmlPos;
							tagId = j;
						}
					
				}
				
				if (isInsideTag)
					tagContent += char;
				
				if (char == HtmlSection.CLOSETAG[tagId])
				{
					
					isInsideTag = false;
					
					var match:Array = tagContent.match(/<\/?(\w+)[^>]*>/i);
					
					if (!match)
						continue;
					
					var tagName:String = match[match.length - 1];
					
					if (HtmlSection.TAGNAMES.lastIndexOf(tagName) > -1)
					{
						if (tagContent.indexOf("/") == 1)
						{
							var arr:Array = tagTracker[tagName];
							var lastUnclosedSection:HtmlSection;
							for (var i:int = arr.length - 1; i > -1; i--)
							{
								lastUnclosedSection = arr[i] as HtmlSection;
								if (lastUnclosedSection.closed == false)
									break;
							}
							
							lastUnclosedSection.htmlEndPos = htmlPos;
							lastUnclosedSection.closed = true;
							
							lastUnclosedSection.textStartPos = htmlPosToTextPos(lastUnclosedSection.htmlStartPos);
							lastUnclosedSection.textEndPos = htmlPosToTextPos(lastUnclosedSection.htmlEndPos);
							
							lastUnclosedSection.attributes = extractAttributes(lastUnclosedSection.startTagContent);
						}
						else
						{
							
							if (lastOpenTagPos > -1)
							{
								//create tag tracker entry
								if (!(tagName in tagTracker))
									tagTracker[tagName] = [];
								
								if (!(tagName in openedNum))
									openedNum[tagName] = 0;
								
								var section:HtmlSection = new HtmlSection();
								section.htmlStartPos = lastOpenTagPos;
								section.tagName = tagName;
								section.startTagContent = tagContent;
								
								tagTracker[tagName].push(section);
								section.ID = openedNum[tagName]++;
							}
							
						}
					}
					
					lastOpenTagPos = -1;
					tagContent = "";
					tagId = -1;
				}
			}
			
			for each (var sects:Array in tagTracker)
				for each (var s:HtmlSection in sects)
					htmlSections.push(s);
		}
		
		protected function extractAttributes(str:String):Object
		{
			var out:Object = {};
			var matches:Array = str.match(/(href|title|target)="([^"]+)"/ig);
			if (!matches)
				return null;
			
			for each (var s:String in matches)
			{
				var m:Array = s.match(/(href|title|target)="([^"]+)"/i);
				if (!m)
					continue;
				
				m.shift();
				
				out[m[0]] = m[1];
			}
			return out;
		}
		
		protected function htmlPosToTextPos(htmlPosition:int = 0):int
		{
			var out:int = 0;
			
			var endHtmlPos:int = htmlPosition;
			
			var htmlText:String = this.textField.htmlText;
			
			var isInsideTag:Boolean = false;
			var tagContent:String = "";
			var tagId:int = -1;
			var char:String;
			
			for (var htmlPos:int = 0; htmlPos <= endHtmlPos; htmlPos++)
			{
				char = htmlText.charAt(htmlPos).toLowerCase();
				out++;
				
				if (!isInsideTag)
				{
					for (var j:int = 0; j < HtmlSection.OPENTAG.length; j++)
						if (char == HtmlSection.OPENTAG[j])
						{
							isInsideTag = true;
							tagId = j;
						}
					
				}
				
				if (isInsideTag)
				{
					out--;
					tagContent += char;
				}
				
				if (char == HtmlSection.CLOSETAG[tagId])
				{
					
					if (tagId > -1)
						out += HtmlSection.TAGREPLACELENGTH[tagId];
					
					if (tagContent.substr(0, 3) == "</p")
						out++;
					
					if (tagContent.substr(0, 3) == "<br")
						out++;
					
					isInsideTag = false;
					tagContent = "";
					tagId = -1;
				}
				
			}
			
			return out;
		}
		
		protected function doSections():void
		{
			
			for each (var section:HtmlSection in htmlSections)
			{
				if (doCharRectsFor.indexOf(section.tagName) < 0)
					continue;
				
				var lineJumpApprox:int = 5;
				var lineRect:Rectangle = new Rectangle();
				var lines:int = 0;
				
				for (var i:int = section.textStartPos; i < section.textEndPos; i++)
				{
					var r:Rectangle = this.textField.getCharBoundaries(i);
					if (!r)
						continue;
					
					r.inflate(boundariesInflation, boundariesInflation);
					
					if (!lineRect)
					{
						lineRect = r;
						section.charRects.push(lineRect);
						continue;
					}
					
					if (r.y > lineRect.top + lineJumpApprox)
					{
						section.charRects.push(lineRect);
						lineRect = r;
						lines++;
						continue;
					}
					
					lineRect = lineRect.union(r);
					
				}
				
				section.charRects.push(lineRect);
				
				if (section.tagName == "a")
				{
					var href:String = section.attributes.href;
					section.clickable = true;
				}
				
				if (debugVisuals)
				{
					for each (var b:Rectangle in section.charRects)
					{
						if (b.width == 0 || b.height == 0)
							continue;
						
						var color:uint = 0x00FF00;
						
						var q:Quad = new Quad(b.width, b.height, color);
						q.x = b.x;
						q.y = b.y;
						q.touchable = false;
						section.quads.push(q);
						addChild(q);
					}
				}
				
			}
			
			if(onSectionsCreated != null)
				onSectionsCreated(htmlSections);
		}
		
		/**
		 * @private
		 */
		protected function touchHandler(event:TouchEvent):void
		{
			if (clickHandler == null || !(clickHandler is Function))
				return;
			
			if (!this._isHTML)
				return;
			
			var touchBegan:Touch = event.getTouch(this, TouchPhase.BEGAN);
			
			if (touchBegan)
				_saveYposition = touchBegan.globalY;
			
			var touchEnded:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touchEnded && _saveYposition <= touchEnded.globalY + 10 && _saveYposition >= touchEnded.globalY - 10)
			{
				
				touchEnded.getLocation(this, HELPER_POINT);
				
				if (!this.textField)
					return;
				
				var clickedSections:Array = [];
				
				for each (var s:HtmlSection in htmlSections)
				{
					if (!s.clickable)
						continue;
					
					for each (var r:Rectangle in s.charRects)
					{
						if (r.containsPoint(HELPER_POINT))
						{
							clickedSections.push(s);
						}
					}
				}
				
				if (clickedSections.length > 0)
				{
					clickHandler(clickedSections);
				}
			}
		
		}
		
		override public function set isHTML(value:Boolean):void
		{
			super.isHTML = value;
			if (this._isHTML)
				this.addEventListener(TouchEvent.TOUCH, touchHandler);
			else
				this.removeEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		public function get nativeTextField():TextField
		{
			validate();
			
			return textField;
		}
	
	}
}
