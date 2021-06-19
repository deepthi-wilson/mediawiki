#AWS Provider access 

provider "aws" {
 #access_key = "${var.access_key}"
 #secret_key = "${var.secret_key}"
 region     = "${var.region}"
# assume_role {
#     role_arn = "arn:aws:iam::128198028467:role/EC2-Instance-Role"
#     session_name = "assume_role"
# }
}
