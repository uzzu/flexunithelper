package org.uzzu.flexunithelper
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;

    import org.flexunit.assertThat;
    import org.flexunit.asserts.assertNotNull;
    import org.hamcrest.core.isA;

    public class UtilitiesTest
    {
        public var container:DisplayObjectContainer;

        [Before(async, ui)]
        public function begin():void
        {
            container = beginVisualTest(this);
        }

        [After]
        public function end():void
        {
            container = endVisualTest();
        }

        [Test]
        public function referToStage():void
        {
            assertNotNull(container.stage);
            assertThat(container.stage, isA(Stage));
        }
    }
}
