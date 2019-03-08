import boto3
import argparse
import time
from boto3.exceptions import botocore
import operator
__version__ = "1.0.0"

class bcolors:
    """Setting Text ForeGround Color"""
    BOLD = '\033[1m'
    HEADER = '\033[95m' + BOLD
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m' + BOLD
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    UNDERLINE = '\033[4m'
    OK = BOLD + OKGREEN + u'\u2705' + "  "
    ERR = BOLD + FAIL + u"\u274C" + "  "
    WAIT = BOLD + OKBLUE + u'\u231b' + "  "
    HELP = OKBLUE
    BHELP = FAIL + BOLD
    BMSG = BOLD + OKBLUE
    DONE = BOLD + "Done " + u"\u2705"

def description():
    """
    Testing
    """

def parseCmdLineArgs():
    """Command Line Arguments for Program"""
    parser = argparse.ArgumentParser(description=description.__doc__, version=__version__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("-p", "--profile",
                        action="store",
                        dest="aws_profile",
                        required=True,
                        help=bcolors.BHELP + "[REQUIRED]:" + bcolors.HELP + "AWS Profile Name as in ~/.aws/credentials" + bcolors.ENDC)
    parser.add_argument("-r", "--region",
                        action="store",
                        dest="cluster_region",
                        required=True,
                        help=bcolors.BHELP + "[REQUIRED]:" + bcolors.HELP + "AWS Region" + bcolors.ENDC)
    parser.add_argument("-a", "--ami_id",
                        action="store",
                        dest="ami_to_preserve",
                        nargs='+',
                        required=False,
                        help=bcolors.BHELP + "[OPTIONAL]:" + bcolors.HELP + "Space Separated AWS AMI to be preserved explicitly" + bcolors.ENDC)
    parser.add_argument("-t", "--num_of_days",
                        action="store",
                        dest="num_of_days",
                        type=int,
                        required=False,
                        help=bcolors.BHELP + "[OPTIONAL]:" + bcolors.HELP + "Number of Days of which AMI has to be preserved.[UTC TIME]" + bcolors.ENDC)
    parser.add_argument("-d", "--dry-run-off",
                        action="store_true",
                        dest="dry_run_off",
                        help=bcolors.BHELP + "[OPTIONAL]:" + bcolors.HELP + "Switches off Dry Run and AMI and Snapshot will be deleted." + bcolors.ENDC)
    args = vars(parser.parse_args())
    return args


def main(args):
    """ The Main Arena """
    region_name = args['cluster_region']
    session = boto3.Session(profile_name=args['aws_profile'], region_name=region_name)
    acc_conn = session.client('sts')
    aws_acc_id = acc_conn.get_caller_identity()['Account']
    ec2_conn = session.client('ec2')
    ec2_res = ec2_conn.describe_instances()
    for reservation in ec2_res["Reservations"]:
        for instance in reservation["Instances"]:
            # This sample print will output entire Dictionary object
            #print(instance)
            print bcolors.BMSG + "Instance ID: {}".format(instance["InstanceId"]) + bcolors.ENDC
    print bcolors.BMSG + "Getting Details for Region: {}".format(region_name) + bcolors.ENDC
    print bcolors.WAIT + "Account Id {} will only be deleted.".format(aws_acc_id) + bcolors.ENDC
    s3client = session.client('s3')
    response = s3client.list_buckets()
    for bucket in response["Buckets"]:
        print(bucket['Name'])

if __name__ == '__main__':
    start_time = time.time()
    args = parseCmdLineArgs()
    try:
        main(args)
    except KeyboardInterrupt:
        print ""
        print bcolors.ERR + 'User Interruption received. Existing...' + bcolors.ENDC
    except botocore.exceptions.ProfileNotFound:
        print bcolors.ERR + 'Profile {} not found in ~/.aws/credentials.'.format(args['aws_profile']) + bcolors.ENDC
    except botocore.exceptions.ClientError as errObj:
        print bcolors.ERR + str(errObj) + bcolors.ENDC
    except ValueError:
        print bcolors.ERR + "Invalid Value Type are passed." + bcolors.ENDC
    print bcolors.BOLD + "Total Script Execution Time: {0:.2f} seconds".format(time.time() - start_time) + bcolors.ENDC
