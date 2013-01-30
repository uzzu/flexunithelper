package org.uzzu.flexunithelper
{
    /**
     * FlexUnitHelperError throws when Error in FlexUnitHelper
     */
    public class FlexUnitHelperError extends Error
    {
        public function FlexUnitHelperError(message:String, errorID:int = 0)
        {
            super(message, errorID);
        }
    }
}

