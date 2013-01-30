package org.uzzu.flexunithelper
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;

    import mx.core.UIComponent;
    import mx.managers.ISystemManager;

    import org.flexunit.async.Async;
    import org.fluint.uiImpersonation.IVisualEnvironmentBuilder;
    import org.fluint.uiImpersonation.UIImpersonator;
    import org.fluint.uiImpersonation.VisualTestEnvironmentBuilder;

    /**
     * FlexUnitSystem class offers the function which is needed when performing the complicated test in flexunit.
     * FlexUnitSystem class is 'Singleton' class.
     */
    public class FlexUnitSystem
    {
        /**
         * @private
         */
        protected static var _instance:FlexUnitSystem;

        /**
         * @private
         */
        protected var _as3Root:DisplayObjectContainer;

        /**
         * @private
         */
        protected var _virtualRoot:DisplayObjectContainer;

        /**
         * @private
         */
        protected var _visualRoot:DisplayObjectContainer;

        /**
         * @return  FlexUnitSystem object.
         */
        public static function get instance():FlexUnitSystem
        {
            if (!_instance)
            {
                _instance = new FlexUnitSystem();
            }
            return _instance;
        }

        /**
         * @private
         */
        public static function set instance(value:FlexUnitSystem):void
        {
            _instance = value;
        }

        /**
         * @private
         */
        public function get stage():Stage
        {
            if (_as3Root)
            {
                return _as3Root.stage;
            }
            return systemManager.stage;
        }

        /**
         * @private
         */
        public function get systemManager():ISystemManager
        {
            if (_as3Root)
            {
                return null;
            }
            return application.systemManager;
        }

        /**
         * @private
         */
        public function get application():Object
        {
            if (_as3Root)
            {
                return _as3Root.loaderInfo;
            }

            var klassDef:Class;
            if ((klassDef = tryGetDefinitionByName("mx.core.FlexGlobal")) != null)
            {
                return klassDef.topLevelApplicaton;
            }
            if ((klassDef = tryGetDefinitionByName("mx.core.Application")) != null)
            {
                return klassDef.application;
            }
            throw new FlexUnitHelperError("Application object was not found.");
        }

        /**
         * Create a new FlexUnitSystem object.
         * Generation and acquisition of the object of a FlexUnitSystem class
         * shold use a FlexUnitSystem#instance accessor-method.
         * Operation is not guaranteed when not using it.
         */
        public function FlexUnitSystem()
        {
        }

        /**
         * Initialize virtual swfroot object for unittest.
         * @param   as3Root
         */
        public function initializeVirtualRoot(as3Root:DisplayObjectContainer = null):void
        {
            var virtualRoot:DisplayObjectContainer;
            if (as3Root)
            {
                if (!as3Root.stage)
                {
                    throw new FlexUnitHelperError("Cannnot refer to stage.");
                }
                _as3Root = as3Root;
                virtualRoot = new Sprite();
            }
            else
            {
                virtualRoot = new UIComponent();
            }
            stage.addChildAt(virtualRoot, 0);
            var testEnvironment:IVisualEnvironmentBuilder = VisualTestEnvironmentBuilder.getInstance(virtualRoot);
            testEnvironment.buildVisualTestEnvironment();
            _virtualRoot = virtualRoot;
        }

        /**
         * Advance-preparations processing for visual test is performed.
         * @param   testCase        TestCase object.
         * @param   container       visual root for unittest.
         * @param   timeout         The timeout time of advance-preparations processing is specified.
         * @param   timeoutHandler  A call-back when advance-preparation processing timeout is specified.
         */
        public function beginVisualTest(
                testCase:Object,
                container:DisplayObjectContainer = null,
                timeout:int = 500,
                timeoutHandler:Function = null
            ):DisplayObjectContainer
        {
            if (!_virtualRoot)
            {
                initializeVirtualRoot();
            }
            if (_visualRoot)
            {
                endVisualTest();
            }
            if (!container)
            {
                container = new Sprite();
            }
            Async.proceedOnEvent(testCase, container, Event.ADDED_TO_STAGE, timeout, timeoutHandler);
            var visualRoot:DisplayObjectContainer;
            if (_as3Root)
            {
                visualRoot = container;
            }
            else
            {
                visualRoot = new UIComponent();
                visualRoot.addChild(container);
            }
            UIImpersonator.addChild(visualRoot);
            _visualRoot = visualRoot;
            return container;
        }

        /**
         * Termination processing of visual test is performed.
         * @return  null
         */
        public function endVisualTest():DisplayObjectContainer
        {
            UIImpersonator.removeAllChildren();
            _visualRoot = null;
            return null;
        }

        /**
         * @private
         */
        public function tryGetDefinitionByName(className:String):Class
        {
            try
            {
                return getDefinitionByName(className) as Class;
            }
            catch (error:Error)
            {
            }
            return null;
        }
    }
}

