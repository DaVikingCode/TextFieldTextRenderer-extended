package davikingcode.feathers 
{

	import flash.geom.Rectangle;
	import starling.display.Quad;
	public class HtmlSection 
	{
		
		public static const OPENTAG:Array = ["<", "&"];
		public static const CLOSETAG:Array = [">", ";"];
		public static const TAGREPLACELENGTH:Array = [0, 1];
		
		public static const TAGNAMES:Array = ["a"];
		
		public var tagName:String;
		public var attributes:Object;
		
		public var startTagContent:String;
		
		public var htmlStartPos:int = 0;
		public var htmlEndPos:int = 0;

		public var textStartPos:int = 0;
		public var textEndPos:int = 0;
		
		public var closed:Boolean = false;
		
		public var charRects:Vector.<Rectangle>;
		public var quads:Vector.<Quad>;
		
		public var htmlText:String;
		
		public var ID:int;
		
		public var clickable:Boolean = false;
		
		public function HtmlSection() 
		{
			charRects = new Vector.<Rectangle>();
			quads = new Vector.<Quad>();
		}
		
		public function destroy():void
		{
			for each (var q:Quad in quads)
			{
				q.removeEventListeners();
				q.removeFromParent();
			}
			quads.length = 0;
			
			charRects.length = 0;
			attributes = null;
		}
		
	}

}