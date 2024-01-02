#!/bin/bash

# AMI cleaner 
# Cleans the snapsthots too, instead of just de-registering the AMI and then leaving the snapshots dangling. 

# How to use: 
# - Get your AMIs and put them in the array "amis" below. 
# - Set the region in the variable, just below. 
# - Having your access keys in your CLI session, run the script. 

# This is the AMIs you want to delete. Replace your values here.
amis=('ami-0000a9ae4d221f3d2'
'ami-000c0e8a3d01379b3'
'ami-011408974335e8349'
'ami-0171f805dc2a947c3'
'ami-020154afe355d9195'
'ami-02534dbb2c2b062a0'
'ami-0287c5bd4baef4430'
'ami-02a5e04580eae87fb'
'ami-02a88bcd086c7b19a'
'ami-02b1a4929084252b7'
'ami-044b815a228368a92'
'ami-04e0370c6270f86d0'
'ami-05094ec835a04544e'
'ami-05ab70d040fcb4256'
'ami-05fb4c95a67f290a1'
'ami-0660158e94bdc95cd'
'ami-0d3bc63d46594d296'
'ami-0df2ca5252d29a0e9')

# This is the region. The script checks this region only, each time it runs. 
region_name=us-east-2

i=0
for ami_id in "${amis[@]}"; do 
    echo "Processing number ${i}: ami: $ami_id in region $region_name"
    ((++i))
    temp_snapshot_id='' # just a helper variable
    my_array=( $(aws ec2 describe-images --image-ids $ami_id --region $region_name  --output text --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId') ) # get the snapshots of this AMI
    my_array_length=${#my_array[@]} # count the snapshots of this AMI 
    echo "AMI $ami_id has ${my_array_length} snapshots"
    echo "Deregistering AMI: "$ami_id
    aws ec2 deregister-image --image-id $ami_id --region $region_name
    echo "Removing snapshots of $ami_id"
    for (( i=0; i<$my_array_length; i++ )); do # removing the snapshots of this AMI, one by one 
        temp_snapshot_id=${my_array[$i]}
        echo "Deleting Snapshot: "$temp_snapshot_id
        aws ec2 delete-snapshot --snapshot-id $temp_snapshot_id --region $region_name
    done
    echo ""

done 
