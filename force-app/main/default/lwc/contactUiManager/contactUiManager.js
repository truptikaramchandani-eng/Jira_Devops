import { LightningElement, track, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { createRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactUiManager extends LightningElement {

    @track contacts;
    @track error;

    firstName;
    lastName;

    /* ================= FETCH CONTACTS ================= */
    @wire(getListUi, {
        objectApiName: CONTACT_OBJECT,
        listViewApiName: 'AllContacts'
    })
    wiredContacts({ data, error }) {
        if (data) {
            this.contacts = data.records.records.map(record => ({
                Id: record.id,
                Name: record.fields.Name.value,
                Email: record.fields.Email?.value,
                Phone: record.fields.Phone?.value
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.contacts = undefined;
        }
    }

    /* ================= INPUT HANDLERS ================= */
    handleFirstName(event) {
        this.firstName = event.target.value;
    }

    handleLastName(event) {
        this.lastName = event.target.value;
    }

    /* ================= CREATE CONTACT ================= */
    createContact() {
        if (!this.lastName) {
            this.showToast('Error', 'Last Name is required', 'error');
            return;
        }

        const fields = {};
        fields[FIRSTNAME_FIELD.fieldApiName] = this.firstName;
        fields[LASTNAME_FIELD.fieldApiName] = this.lastName;

        createRecord({
            apiName: CONTACT_OBJECT.objectApiName,
            fields
        })
            .then(() => {
                this.showToast('Success', 'Contact created successfully', 'success');
                this.firstName = '';
                this.lastName = '';
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    /* ================= TOAST ================= */
    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }
}