public with sharing class PDFGeneratorController {
    public String recordId { get; set; }
    public String recordName { get; set; }

    public PDFGeneratorController() {
        recordId = ApexPages.currentPage().getParameters().get('id');
        if (recordId != null) {
            Account acc = [SELECT Name FROM Account WHERE Id = :recordId LIMIT 1];
            recordName = acc.Name;
        }
    }

    @AuraEnabled
    public static String generatePDF(String recordId) {
        PageReference pdfPage = Page.PDFGeneratorPage;
        pdfPage.getParameters().put('id', recordId);
        Blob pdfBlob = pdfPage.getContentAsPDF();
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Generated PDF',
            PathOnClient = 'GeneratedPDF.pdf',
            VersionData = pdfBlob
        );
        insert contentVersion;
        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId,
            LinkedEntityId = recordId,
            ShareType = 'V'
        );
        insert link;
        return '/sfc/servlet.shepherd/document/download/' + contentVersion.ContentDocumentId;
    }
}