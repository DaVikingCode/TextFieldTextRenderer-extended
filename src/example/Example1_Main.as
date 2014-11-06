package example
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(width="800",height="600",frameRate="60",backgroundColor="#E9E9E9")]
	
	public class Example1_Main extends Sprite
	{
		private var _starling:Starling;
		
		protected var _screenWidth:int = 0;
		protected var _screenHeight:int = 0;
		
		private var _baseWidth:int = -1;
		private var _baseHeight:int = -1;
		
		private var _viewport:Rectangle;
		
		private var _viewportBaseRatioWidth:Number = 1;
		private var _viewportBaseRatioHeight:Number = 1;
		
		public function Example1_Main():void
		{
			if (stage)
				init();
			else
				addEventListener(flash.events.Event.ADDED_TO_STAGE, init);

			_baseWidth = 800;
			_baseHeight = 600;
			
		}
		
		private function init(e:flash.events.Event = null):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(flash.events.Event.RESIZE, handleStageResize);
			
			Starling.handleLostContext = true;
			
			_starling = new Starling(Example1_Screen, stage);
			
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starling.stage.addEventListener(starling.events.Event.RESIZE, resetViewport);
		
		}
		
		protected function handleStageResize(e:flash.events.Event):void
		{
			_screenWidth = stage.stageWidth;
			_screenHeight = stage.stageHeight;
			resetScreenSize();
		}
		
		private function onRootCreated(event:starling.events.Event, screen:Example1_Screen):void
		{
			_starling.simulateMultitouch = true;
			_starling.enableErrorChecking = Capabilities.isDebugger;
			_starling.start();
			
			_screenWidth = stage.stageWidth;
			_screenHeight = stage.stageHeight;
			
			resetScreenSize();
			screen.initialize();
		}
		
		private function resetViewport():Rectangle
		{
			if (_baseHeight < 0)
				_baseHeight = _screenHeight;
			if (_baseWidth < 0)
				_baseWidth = _screenWidth;
			
			var baseRect:Rectangle = new Rectangle(0, 0, _baseWidth, _baseHeight);
			var screenRect:Rectangle = new Rectangle(0, 0, _screenWidth, _screenHeight);
			
			_viewport = RectangleUtil.fit(baseRect, screenRect, ScaleMode.SHOW_ALL);
			_viewportBaseRatioWidth = _viewport.width / baseRect.width;
			_viewportBaseRatioHeight = _viewport.height / baseRect.height;
			_viewport.copyFrom(screenRect);
			
			_viewport.x = 0;
			_viewport.y = 0;
			
			if (_starling)
			{
				_starling.stage.stageWidth = screenRect.width / _viewportBaseRatioWidth;
				_starling.stage.stageHeight = screenRect.height / _viewportBaseRatioHeight;
			}
			
			return _viewport;
		}
		
		private function resetScreenSize():void
		{
			if (!_starling)
				return;
			
			resetViewport();
			_starling.viewPort.copyFrom(_viewport);
			
			setupStats();
		}
		
		private function setupStats(hAlign:String = "left", vAlign:String = "top", scale:Number = 1):void
		{
			if (_starling && _starling.showStats)
				_starling.showStatsAt(hAlign, vAlign, scale / _starling.contentScaleFactor);
		}
	
	}

}