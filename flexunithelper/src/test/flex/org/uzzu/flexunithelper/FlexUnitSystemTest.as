package org.uzzu.flexunithelper
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    import org.flexunit.assertThat;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNotNull;
    import org.flexunit.asserts.assertNull;
    import org.hamcrest.core.isA;

    public class FlexUnitSystemTest
    {
        [Test]
        public function isSingletonClass():void
        {
            var system:FlexUnitSystem = FlexUnitSystem.instance;
            assertNotNull(system);
            assertThat(system, isA(FlexUnitSystem));
            assertEquals(system, FlexUnitSystem.instance)
        }

        [Test(async, ui)]
        public function canReferToStage():void
        {
            var container:DisplayObjectContainer = FlexUnitSystem.instance.beginVisualTest(this, new Sprite(), 100, null);
            assertNotNull(container.stage);
            FlexUnitSystem.instance.endVisualTest();
            assertNull(container.stage);
        }

        [Test(async, ui)]
        public function beginVisualTestReturnsSameDisplayObjectContainer():void
        {
            var expected:DisplayObjectContainer = new Sprite();
            var actual:DisplayObjectContainer = FlexUnitSystem.instance.beginVisualTest(this, expected, 100, null);
            assertEquals(expected, actual);
        }

        [Test(async, ui)]
        public function endVisualTestReturnsNull():void
        {
            FlexUnitSystem.instance.beginVisualTest(this, new Sprite(), 100, null);
            var actual:DisplayObjectContainer = FlexUnitSystem.instance.endVisualTest();
            assertNull(actual);
        }
    }
}
