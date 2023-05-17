trigger contentVersionExternalLink on ContentVersion (after insert) {
    ContentVersionTriggerHandler.createPublicLinkForFile(trigger.new);
}