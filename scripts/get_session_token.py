import boto
from boto.exception import BotoServerError
import argparse
import os

def serial_number():
    return os.environ['AWS_MFA_DEVICE']

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Obtains a set of temporary credentials tied to your MFA Key.",
        epilog="This will obtain a set of IAM credentials that have been MFA authorized. They may be sourced into the environment with a command like `source <(./get_session_token.py <token>)`.  The device serial number (or ARN in the case of virtual devices like Google Authenticator) must be present in the AWS_MFA_DEVICE environment variable"
    )

    parser.add_argument("token", help="The current value of your MFA token")

    args = parser.parse_args()
    try:
        sts = boto.connect_sts()
        creds = sts.get_session_token(mfa_serial_number=serial_number(),
                                    mfa_token=args.token,
                                    duration=12*60*60)

        print "export AWS_ACCESS_KEY_ID=" + creds.access_key
        print "export AWS_SECRET_ACCESS_KEY=" + creds.secret_key
        print "export AWS_SECURITY_TOKEN=" + creds.session_token
        print "export AWS_CREDS_EXPIRATION=" +  creds.expiration
        print "export AWS_ACCESS_KEY=" + creds.access_key
        print "export AWS_SECRET_KEY=" + creds.secret_key
        print "export AWS_DELEGATION_TOKEN=" + creds.session_token
    except BotoServerError as bse:
        exit(bse.message)
