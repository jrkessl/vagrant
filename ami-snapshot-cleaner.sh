#!/bin/bash

# AMI cleaner 
# Cleans the snapsthots too, instead of just de-registering the AMI and then leaving the snapshots dangling. 

# How to use: 
# - Get your AMIs and put them in the array "amis" below. 
# - Set the region in the variable, just below. 
# - Having your access keys in your CLI session, run the script. 

# This is the AMIs you want to delete. Replace your values here.
amis=('ami-08775a2a15174c547'
'ami-0c1a98c83f199fce1'
'ami-0ee6c98eee842e5f6'
'ami-01573b59b3707b6ff'
'ami-00aa1e68d7c467a02')

# This is the region. The script checks this region only, each time it runs. 
region_name=us-east-2

i=0
for ami_id in "${amis[@]}"; do 
    echo "Processing number ${i}: $ami_id in region $region_name"
    ((++i))
    temp_snapshot_id='' # just a helper variable
    my_array=( $(aws ec2 describe-images --image-ids $ami_id --region $region_name  --output text --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId') ) # get the snapshots of this AMI
    my_array_length=${#my_array[@]} # count the snapshots of this AMI 
    echo "AMI $ami_id has ${my_array_length} snapshots"
    echo "Deregistering AMI..."
    aws ec2 deregister-image --image-id $ami_id --region $region_name
    echo "Removing snapshots..."
    for (( i=0; i<$my_array_length; i++ )); do # removing the snapshots of this AMI, one by one 
        temp_snapshot_id=${my_array[$i]}
        echo "Deleting Snapshot: "$temp_snapshot_id
        aws ec2 delete-snapshot --snapshot-id $temp_snapshot_id --region $region_name
    done
    echo ""

done 
