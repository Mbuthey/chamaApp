import os
from firebase_functions import https_fn
from firebase_admin import initialize_app

initialize_app()

from mpesa_callback_function.__main__ import mpesa_callback

mpesa_callback_function = https_fn.on_request(mpesa_callback)