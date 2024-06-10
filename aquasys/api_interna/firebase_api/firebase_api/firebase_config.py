import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate(".\\firebase_api\\acquasysbd-firebase-adminsdk-ohjxe-8baa3c070e.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
