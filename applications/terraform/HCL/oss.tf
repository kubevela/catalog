resource "alicloud_oss_bucket" "bucket-acl" {
  bucket = "bucket-170309-terraform"
  acl    = "private"
}

output "oss_bucket_address" {
  description = "OSS bucket address"
  value = "${alicloud_oss_bucket.bucket-acl.bucket}.${alicloud_oss_bucket.bucket-acl.extranet_endpoint}"
}