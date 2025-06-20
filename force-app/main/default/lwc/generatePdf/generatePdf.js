import { LightningElement, api } from 'lwc';
import generatePDF from '@salesforce/apex/PDFGeneratorController.generatePDF';

export default class GeneratePdf extends LightningElement {
    @api recordId;
    pdfUrl;

    handleGeneratePdf() {
        generatePDF({ recordId: this.recordId })
            .then(result => {
                this.pdfUrl = result;
            })
            .catch(error => {
                console.error('Error generating PDF:', error);
            });
    }
}