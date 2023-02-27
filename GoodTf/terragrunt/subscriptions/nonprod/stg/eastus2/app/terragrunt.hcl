terraform {
    source = "../../../../../../../tf"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    connection_string = "stg-connection-string"
}
