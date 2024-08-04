import firebase_admin
from firebase_admin import credentials, firestore
from firebase_functions import https_fn
import json

# Initialize Firebase Admin SDK
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred)
db = firestore.client()

@https_fn.on_request()
def mpesa_callback(request):
    try:
        # Parse the M-Pesa callback data
        data = json.loads(request.data)
        
        # Extract relevant information
        body = data.get('Body', {})
        stkCallback = body.get('stkCallback', {})
        checkout_request_id = stkCallback.get('CheckoutRequestID')
        result_code = stkCallback.get('ResultCode')
        
        # Find the corresponding transaction in Firestore
        transactions = db.collection('mpesa_transactions').where('transaction_id', '==', checkout_request_id).limit(1).get()
        
        if transactions:
            transaction = transactions[0]
            if result_code == 0:
                # Transaction successful
                transaction.reference.update({
                    'status': 'completed',
                    'completed_at': firestore.SERVER_TIMESTAMP
                })
                
                # Update user's balance
                user_ref = db.collection('users').document(transaction.get('user_id'))
                user_ref.update({
                    'account_balance': firestore.Increment(transaction.get('amount'))
                })
            else:
                # Transaction failed
                transaction.reference.update({
                    'status': 'failed',
                    'error': stkCallback.get('ResultDesc', 'Unknown error')
                })
        
        return https_fn.Response("OK", status=200)
    except Exception as e:
        print(f"Error processing M-Pesa callback: {str(e)}")
        return https_fn.Response("Error", status=500)
