locals {
    s3-artifact = {
        bucket = aws_s3_object.artifacts.bucket
        source = aws_s3_object.artifacts.source
        key    = aws_s3_object.artifacts.key
    }
}
