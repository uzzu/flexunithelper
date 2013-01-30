package org.uzzu.flexunithelper
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    /**
     * @copy FlexUnitSystem#beginVisualTest()
     */
    public function beginVisualTest(
            testCase:Object,
            container:DisplayObjectContainer = null,
            timeout:int = 500,
            timeoutHandler:Function = null
        ):DisplayObjectContainer
    {
        return FlexUnitSystem.instance.beginVisualTest(testCase, container, timeout, timeoutHandler);
    }
}

