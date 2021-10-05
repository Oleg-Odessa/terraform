### Read Commnds ###
terraform state show    # Show a resource in the state
terraform state list    # List resources in the state
terraform state pull    # Pull current state and output to stdout
### Write Commnds ###
terraform state rm                 # Remove instances from the state
terraform state mv                 # Move an item in the state
terraform state push               # Update remote state from a local state file
terraform state replace-provider   # Replace provider in the state
### Cycle Commnd ###
# Terminal #
for i in $(terraform state list); do terraform state mv - state-out="terraform.tfstate" $i $i; done
# Bash Script #
    for i in $(terraform state list)
        do terraform state mv - state-out="terraform.tfstate" $i $i
    done
