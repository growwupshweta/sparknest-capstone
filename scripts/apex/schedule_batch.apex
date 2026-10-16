List<CronTrigger> existing = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'CloseStaleEnquiriesNightly'];
if (existing.isEmpty()) {
    String jobId = System.schedule('CloseStaleEnquiriesNightly', '0 0 0 * * ?', new CloseStaleEnquiriesScheduler());
    System.debug('Scheduled CloseStaleEnquiriesNightly with Job ID: ' + jobId);
} else {
    System.debug('CloseStaleEnquiriesNightly is already scheduled.');
}
